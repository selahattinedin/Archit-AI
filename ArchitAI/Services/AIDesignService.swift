import SwiftUI

protocol AIDesignServiceProtocol {
    func generateDesign(from image: UIImage, style: DesignStyle, room: Room) async throws -> UIImage
}

class AIDesignService: AIDesignServiceProtocol {
    private let stabilityService = StabilityAIService.shared
    private let revenueCatService = RevenueCatService.shared
    
    // OPTIMIZE EDİLMİŞ STYLE PROMPT'LARI - Kısa ve etkili
    private func createStylePrompt(for style: DesignStyle) -> String {
        switch style.name {
        case "Organic Modern":
            return "organic modern: natural wood, stone, linen, warm beige/sage green, curved lines, plants, soft lighting"
        case "Vintage":
            return "vintage mid-century: mustard yellow, teal blue, coral pink, retro furniture, brass accents, clean lines"
        case "Gothic":
            return "gothic: deep black/burgundy/emerald, velvet, dark mahogany, pointed arches, crystal chandeliers"
        case "Gamer":
            return "gaming setup: RGB lighting, ergonomic chairs, multiple monitors, tech-inspired furniture, cable management"
        case "Technoland":
            return "futuristic tech: glass, aluminum, LED panels, smart home tech, sleek lines, holographic displays"
        case "Bohem":
            return "bohemian: rattan, bamboo, earthy tones, vibrant accents, eclectic patterns, plants, handmade items"
        case "Classic":
            return "classic traditional: light beige walls, symmetrical layout, hardwood, stone, warm neutrals, refined details, elegant white trim"
        case "Dark Theme":
            return "dark moody: deep black/charcoal/navy, metallic finishes, dramatic lighting, leather, velvet"
        case "Light Theme":
            return "light airy: pure white walls, soft cream accents, bright pastels, abundant natural light, minimalist, clean lines, light wood"
        case "Industrial":
            return "industrial: exposed brick, concrete, steel, iron, high ceilings, raw character, vintage lighting"
        case "Japandi":
            return "japandi zen: light wood, natural textures, clean lines, neutral colors, minimal functional furniture"
        case "Loft":
            return "urban loft: high ceilings, open plan, industrial elements, spacious, large windows, contemporary"
        case "Luxury":
            return "luxury premium: marble, gold, crystal, high-end furniture, sophisticated colors, designer pieces"
        case "Turkish":
            return "turkish traditional: carpets, ceramics, warm reds/golds, ornate patterns, cultural motifs"
        default:
            return "beautiful \(style.name.lowercased()) style: premium materials, contemporary comfort"
        }
    }
    
    // OPTIMIZE EDİLMİŞ ROOM PROMPT'LARI - Çok daha kısa
    private func createRoomPrompt(for room: Room) -> String {
        switch room.name {
        case "Living Room":
            return "luxury living room: designer furniture, statement lighting, premium materials, elegant decor"
        case "Bedroom":
            return "luxury bedroom: dramatic lighting, custom headboard, premium bedding, elegant seating"
        case "Kitchen":
            return "chef kitchen: premium countertops, designer backsplash, high-end appliances, statement island"
        case "Bathroom":
            return "spa bathroom: luxury tiles, premium fixtures, sophisticated lighting"
        case "Office":
            return "productive workspace: premium finishes, ergonomic furniture, task lighting, smart storage"
        case "Garden":
            return "garden landscape: seasonal plants, stone paths, outdoor lighting, water features"
        case "Dining Room":
            return "elegant dining: statement chandelier, premium finishes, sophisticated furniture"
        case "Kids Room":
            return "magical kids space: safe materials, fun lighting, playful furniture, creative storage"
        case "Game Room":
            return "entertainment space: immersive lighting, gaming decor, functional layout"
        case "Home Gym":
            return "fitness center: durable materials, exercise flooring, energizing lighting"
        case "Library":
            return "reading sanctuary: bookshelves, task lighting, curated art, premium finishes"
        case "Home Theater":
            return "cinematic theater: premium seating, immersive lighting, entertainment setup"
        case "Balcony":
            return "outdoor retreat: weather-resistant furniture, cozy lighting, plants"
        case "Walk-in Closet":
            return "luxury dressing room: premium storage, sophisticated lighting, mirrors"
        case "Laundry Room":
            return "stylish laundry: durable materials, functional lighting, smart storage"
        case "Entryway":
            return "welcoming entrance: statement lighting, console storage, durable flooring, mirror"
        default:
            return "stunning \(room.name.lowercased()): premium finishes, sophisticated lighting"
        }
    }
    
    func generateDesign(from image: UIImage, style: DesignStyle, room: Room) async throws -> UIImage {
        // 🔒 PREMIUM KONTROLÜ
        guard revenueCatService.isPro else {
            throw StabilityAIError.apiError("Premium subscription required to generate images. Please subscribe to continue.")
        }
        
        let stylePrompt = createStylePrompt(for: style)
        let roomPrompt = createRoomPrompt(for: room)
        
        // ULTRA KISA VE ETKİLİ PROMPT - 2000 karakter sınırına uygun
        let basePrompt = """
            Transform this \(room.name.lowercased()) into \(style.name.lowercased()) style.
            \(roomPrompt). \(stylePrompt).
            Keep exact layout, boundaries, structural elements. Use light neutral walls for light/classic styles.
            Upgrade materials, lighting, furniture, decor. Ensure bright, well-lit spaces.
            Photorealistic, natural lighting, proper scale, high quality finishes, magazine worthy interior.
            """
        
        // KISA NEGATİVE PROMPT
        let negativePrompt = "ugly, blurry, distorted, altered structure, wrong scale, cartoon, watermark, text"
        
        return try await stabilityService.generateImage(
            from: image,
            prompt: basePrompt,
            negativePrompt: negativePrompt,
            stylePreset: "photographic",
            imageStrength: 0.35 // Biraz daha fazla değişiklik için artırdım
        )
    }
}
