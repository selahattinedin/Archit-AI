import Foundation
import UIKit

enum StabilityAIError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case apiError(String)
    case imageConversionError
}

struct StabilityAIResponse: Codable {
    let artifacts: [ImageArtifact]
}

struct ImageArtifact: Codable {
    let base64: String
    let finishReason: String
    let seed: Int
}

actor StabilityAIService {
    static let shared = StabilityAIService()
    private let baseURL = Constants.API.stabilityBaseURL
    private let apiKey = Constants.API.stabilityAPIKey
    private let revenueCatService = RevenueCatService.shared
    
    private init() {}
    
    func generateImage(
        from inputImage: UIImage,
        prompt: String,
        negativePrompt: String = "",
        stylePreset: String? = nil,
        steps: Int = Constants.API.defaultSteps,
        cfgScale: Double = Constants.API.defaultCFGScale,
        engine: String = Constants.API.defaultEngine,
        imageStrength: Double = 0.35 // Orijinal görüntünün ne kadar korunacağı (0-1)
    ) async throws -> UIImage {
        // 🔒 PREMIUM KONTROLÜ - En son güvenlik katmanı
        guard await revenueCatService.isPro else {
            print("🚫 StabilityAIService: User is not premium, blocking API call")
            throw StabilityAIError.apiError("Premium subscription required to generate images. Please subscribe to continue.")
        }
        
        print("✅ StabilityAIService: User is premium, proceeding with API call")
        let endpoint = "\(baseURL)/generation/\(engine)/image-to-image"
        
        let size = CGSize(width: 1024, height: 1024)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        inputImage.draw(in: CGRect(origin: .zero, size: size))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            throw StabilityAIError.imageConversionError
        }
        UIGraphicsEndImageContext()
        
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.8),
              let base64Image = imageData.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw StabilityAIError.imageConversionError
        }
        
        guard let url = URL(string: endpoint) else {
            throw StabilityAIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let trimmedAPIKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        request.setValue("Bearer \(trimmedAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"init_image\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image_strength\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(imageStrength)\r\n".data(using: .utf8)!)
        
        let textPrompts: [[String: Any]] = [
            ["text": prompt, "weight": 1],
            ["text": negativePrompt, "weight": -1]
        ].filter { !($0["text"] as! String).isEmpty }
        
        // 📝 API'YA GÖNDERİLEN PROMPT LOGLAMA
        print("🚀 StabilityAIService: Sending to API")
        print("🔑 API Key: \(apiKey.prefix(10))...")
        print("🌐 Endpoint: \(endpoint)")
        print("📝 Main Prompt (\(prompt.count) chars): \(prompt)")
        print("❌ Negative Prompt (\(negativePrompt.count) chars): \(negativePrompt)")
        print("⚙️ Parameters: cfg_scale=\(cfgScale), steps=\(steps), style_preset=\(stylePreset ?? "none"), image_strength=\(imageStrength)")
        print("🔐 Authorization Header: Bearer \(apiKey.prefix(10))...")
        
        for (index, prompt) in textPrompts.enumerated() {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"text_prompts[\(index)][text]\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(prompt["text"] as! String)\r\n".data(using: .utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"text_prompts[\(index)][weight]\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(prompt["weight"] as! Int)\r\n".data(using: .utf8)!)
        }
        
        let parameters: [String: Any] = [
            "cfg_scale": cfgScale,
            "steps": steps,
            "samples": 1
        ].merging(
            stylePreset.map { ["style_preset": $0] } ?? [:],
            uniquingKeysWith: { $1 }
        )
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw StabilityAIError.invalidResponse
        }
        
        // 📝 API YANITI LOGLAMA
        print("📡 StabilityAIService: API Response received")
        print("📊 Status Code: \(httpResponse.statusCode)")
        print("📏 Response Data Size: \(data.count) bytes")
        
        guard httpResponse.statusCode == 200 else {
            if let errorMessage = String(data: data, encoding: .utf8) {
                print("❌ API Error Response: \(errorMessage)")
                throw StabilityAIError.apiError("API Error: \(httpResponse.statusCode) - \(errorMessage)")
            }
            print("❌ API Error: \(httpResponse.statusCode) - No error message")
            throw StabilityAIError.apiError("API Error: \(httpResponse.statusCode)")
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let result = try decoder.decode(StabilityAIResponse.self, from: data)
        
        // 📝 BAŞARILI YANIT LOGLAMA
        print("✅ StabilityAIService: Image generation successful")
        print("🖼️ Artifacts count: \(result.artifacts.count)")
        if let firstArtifact = result.artifacts.first {
            print("🎨 First artifact - finish_reason: \(firstArtifact.finishReason), seed: \(firstArtifact.seed)")
        }
        
        guard let firstArtifact = result.artifacts.first,
              let imageData = Data(base64Encoded: firstArtifact.base64),
              let image = UIImage(data: imageData) else {
            print("❌ Image conversion failed")
            throw StabilityAIError.imageConversionError
        }
        
        print("🎉 StabilityAIService: Image successfully generated and converted")
        return image
    }
}
