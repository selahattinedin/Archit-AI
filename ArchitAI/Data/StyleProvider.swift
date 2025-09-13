import Foundation

final class StyleProvider {
    static var styles: [DesignStyle] = {
        return [
            DesignStyle(
                name: "style_organic_modern",
                description: "style_organic_modern_desc",
                image: "organic_modern",
                tags: ["natural", "modern", "minimal"]
            ),
            DesignStyle(
                name: "style_vintage",
                description: "style_vintage_desc",
                image: "vintage",
                tags: ["classic", "retro", "elegant"]
            ),
            DesignStyle(
                name: "style_gothic",
                description: "style_gothic_desc",
                image: "gothic",
                tags: ["dark", "dramatic", "luxury"]
            ),
            DesignStyle(
                name: "style_gamer",
                description: "style_gamer_desc",
                image: "gamer",
                tags: ["gaming", "modern", "tech"]
            ),
            DesignStyle(
                name: "style_technoland",
                description: "style_technoland_desc",
                image: "technoland",
                tags: ["futuristic", "tech", "modern"]
            ),
            DesignStyle(
                name: "style_bohem",
                description: "style_bohem_desc",
                image: "bohem",
                tags: ["artistic", "natural", "cozy"]
            ),
            DesignStyle(
                name: "style_classic",
                description: "style_classic_desc",
                image: "classic",
                tags: ["elegant", "traditional", "refined"]
            ),
            DesignStyle(
                name: "style_dark_theme",
                description: "style_dark_theme_desc",
                image: "dark_theme",
                tags: ["dark", "modern", "bold"]
            ),
            DesignStyle(
                name: "style_light_theme",
                description: "style_light_theme_desc",
                image: "light_theme",
                tags: ["bright", "minimal", "fresh"]
            ),
            DesignStyle(
                name: "style_industrial",
                description: "style_industrial_desc",
                image: "industrial",
                tags: ["urban", "raw", "modern"]
            ),
            DesignStyle(
                name: "style_japandi",
                description: "style_japandi_desc",
                image: "japandi",
                tags: ["minimal", "zen", "natural"]
            ),
            DesignStyle(
                name: "style_loft",
                description: "style_loft_desc",
                image: "loft",
                tags: ["urban", "spacious", "modern"]
            ),
            DesignStyle(
                name: "style_luxury",
                description: "style_luxury_desc",
                image: "luxury",
                tags: ["premium", "elegant", "sophisticated"]
            ),
            DesignStyle(
                name: "style_turkish",
                description: "style_turkish_desc",
                image: "turkish",
                tags: ["traditional", "cultural", "warm"]
            )
        ]
    }()
}