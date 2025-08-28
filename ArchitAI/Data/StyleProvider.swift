import Foundation

final class StyleProvider {
    static var styles: [DesignStyle] = {
        return [
            DesignStyle(
                name: "Organic Modern",
                description: "Natural materials with clean modern lines",
                image: "organic_modern",
                tags: ["natural", "modern", "minimal"]
            ),
            DesignStyle(
                name: "Vintage",
                description: "Classic and timeless design with retro elements",
                image: "vintage",
                tags: ["classic", "retro", "elegant"]
            ),
            DesignStyle(
                name: "Gothic",
                description: "Dark and dramatic with architectural elements",
                image: "gothic",
                tags: ["dark", "dramatic", "luxury"]
            ),
            DesignStyle(
                name: "Gamer",
                description: "Modern gaming setup with RGB lighting",
                image: "gamer",
                tags: ["gaming", "modern", "tech"]
            ),
            DesignStyle(
                name: "Technoland",
                description: "Futuristic design with high-tech elements",
                image: "technoland",
                tags: ["futuristic", "tech", "modern"]
            ),
            DesignStyle(
                name: "Bohem",
                description: "Free-spirited and artistic with natural elements",
                image: "bohem",
                tags: ["artistic", "natural", "cozy"]
            ),
            DesignStyle(
                name: "Classic",
                description: "Timeless elegance with traditional elements",
                image: "classic",
                tags: ["elegant", "traditional", "refined"]
            ),
            DesignStyle(
                name: "Dark Theme",
                description: "Bold and sophisticated with dark tones",
                image: "dark_theme",
                tags: ["dark", "modern", "bold"]
            ),
            DesignStyle(
                name: "Light Theme",
                description: "Bright and airy with natural light",
                image: "light_theme",
                tags: ["bright", "minimal", "fresh"]
            ),
            DesignStyle(
                name: "Industrial",
                description: "Raw and urban with exposed elements",
                image: "industrial",
                tags: ["urban", "raw", "modern"]
            ),
            DesignStyle(
                name: "Japandi",
                description: "Japanese minimalism meets Scandinavian design",
                image: "japandi",
                tags: ["minimal", "zen", "natural"]
            ),
            DesignStyle(
                name: "Loft",
                description: "Urban living with high ceilings and open spaces",
                image: "loft",
                tags: ["urban", "spacious", "modern"]
            ),
            DesignStyle(
                name: "Luxury",
                description: "Opulent design with premium finishes",
                image: "luxury",
                tags: ["premium", "elegant", "sophisticated"]
            ),
            DesignStyle(
                name: "Turkish",
                description: "Traditional Turkish design with modern touches",
                image: "turkish",
                tags: ["traditional", "cultural", "warm"]
            )
        ]
    }()
}