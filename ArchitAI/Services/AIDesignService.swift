import SwiftUI

protocol AIDesignServiceProtocol {
    func generateDesign(from image: UIImage, style: DesignStyle, room: Room) async throws -> UIImage
}

class AIDesignService: AIDesignServiceProtocol {
    private let stabilityService = StabilityAIService.shared
    
    private func createStylePrompt(for style: DesignStyle) -> String {
        switch style.name {
        case "Organic Modern":
            return """
                **Organic Modern:**
                - Materials: solid wood, stone, linen, organic cotton, reclaimed wood
                - Colors: warm beiges, soft browns, sage greens, warm whites
                - Features: minimalist lines, organic curves, abundant plants (biophilic), handcrafted elements, soft diffused lighting, seamless indoor-outdoor feel.
                """
        case "Vintage":
            return """
                **Vintage:**
                - Furniture: authentic mid-century modern, clean lines
                - Colors: mustard yellows, teal blues, coral pinks, warm browns
                - Features: antique accessories, retro clocks, layered textures, vintage-inspired lighting, brass/copper accents, timeless elegance.
                """
        case "Gothic":
            return """
                **Gothic:**
                - Colors: deep blacks, burgundy reds, emerald greens, gold accents
                - Materials: velvet, leather, dark mahogany wood, silk
                - Features: pointed arches, ornate details, crystal chandeliers, canopied beds, heavy drapery, sophisticated drama.
                """
        case "Gamer":
            return """
                **Gamer:**
                - Lighting: advanced RGB lighting, customizable effects
                - Furniture: ergonomic gaming chairs, modern tech-inspired furniture
                - Features: multiple monitors, soundproofing, cable management, gaming-themed decor, smart home integration.
                """
        case "Technoland":
            return """
                **Technoland:**
                - Materials: tempered glass, brushed aluminum, carbon fiber, LED panels
                - Technology: cutting-edge smart home tech, automation, holographic displays
                - Features: sleek modern lines, clean aesthetics, futuristic furniture, energy-efficient solutions.
                """
        case "Bohem":
            return """
                **Bohem:**
                - Materials: rattan, bamboo, jute, organic fabrics
                - Colors: warm earthy tones with vibrant accents
                - Features: eclectic mix of patterns/textures, cultural influences, handmade vintage items, abundant plants, cozy atmosphere.
                """
        case "Classic":
            return """
                **Classic:**
                - Materials: silk, velvet, fine woods, premium metals
                - Design: symmetrical layouts, balanced proportions, traditional furniture styles
                - Features: rich sophisticated colors, quality craftsmanship, formal refined atmosphere, elegant lighting, timeless beauty.
                """
        case "Dark Theme":
            return """
                **Dark Theme:**
                - Colors: deep blacks, charcoals, dark grays, navy blues
                - Features: dramatic contrast with metallic finishes, sleek modern furniture, strategic accent lighting, luxurious moody ambiance, rich textures (leather, velvet).
                """
        case "Light Theme":
            return """
                **Light Theme:**
                - Colors: soft whites, creams, light grays, pastel accents
                - Features: abundant natural light, minimalist clean aesthetic, uncluttered spaces, light wood finishes, large windows, fresh modern atmosphere.
                """
        case "Industrial":
            return """
                **Industrial:**
                - Materials: exposed brick, concrete floors, steel, iron, copper
                - Features: urban warehouse aesthetic, exposed pipes/ducts, high ceilings, raw authentic character, modern functional furniture, vintage industrial lighting.
                """
        case "Japandi":
            return """
                **Japandi:**
                - Design: Japanese minimalism meets Scandinavian design, zen-like simplicity
                - Materials: light wood tones, natural textures
                - Features: clean lines, functional furniture, neutral colors, natural light, peaceful harmonious atmosphere.
                """
        case "Loft":
            return """
                **Loft:**
                - Design: high ceilings, open floor plans, urban living aesthetic
                - Features: industrial elements, exposed structures, spacious airy feel, contemporary furniture, large windows, open concept living.
                """
        case "Luxury":
            return """
                **Luxury:**
                - Materials: marble, gold, crystal, fine fabrics
                - Features: high-end furniture, sophisticated color schemes, elegant refined atmosphere, impeccable quality, custom details, designer pieces.
                """
        case "Turkish":
            return """
                **Turkish:**
                - Materials: Turkish carpets, traditional textiles, handcrafted ceramics
                - Colors: rich warm palettes, deep reds, golds, warm earth tones
                - Features: authentic cultural elements, traditional motifs, ornate patterns, warm inviting atmosphere, blend of tradition and modern comfort.
                """
        default:
            return "Beautiful \(style.name.lowercased()) interior design with premium materials and a professional, polished appearance. Contemporary comfort and style."
        }
    }
    
    private func createRoomSpecificPrompt(for room: Room) -> String {
        switch room.name {
        case "Living Room":
            return """
                **Living Room Transformation:**
                - Goal: magazine-quality space.
                - Preserve: exact room layout, all windows, doors, structural features.
                - Upgrades: premium wall/floor finishes, sophisticated lighting, contemporary furniture, stylish storage.
                """
        case "Bedroom":
            return """
                **Bedroom Transformation:**
                - Goal: luxurious sanctuary.
                - Preserve: exact room layout, all windows, doors, structural features.
                - Upgrades: premium materials, modern flooring, ambient lighting, premium bed, stylish storage.
                """
        case "Kitchen":
            return """
                **Kitchen Renovation:**
                - Goal: dream culinary space.
                - Preserve: exact layout, all plumbing/gas lines, appliance locations.
                - Upgrades: premium countertops (marble, quartz), modern backsplash, statement lighting (under-cabinet, pendant).
                """
        case "Bathroom":
            return """
                **Bathroom Transformation:**
                - Goal: luxury spa-like retreat.
                - Preserve: exact layout, all plumbing fixtures.
                - Upgrades: premium wall tiles/finishes, luxury fixtures (toilet, sink, shower), sophisticated lighting.
                """
        case "Office":
            return """
                **Office Transformation:**
                - Goal: productive inspiring workspace.
                - Preserve: exact layout, all windows, doors.
                - Upgrades: premium finishes, modern flooring, ergonomic furniture, task lighting, smart storage.
                """
        case "Garden":
            return """
                **Garden Transformation:**
                - Goal: stunning outdoor oasis.
                - Preserve: exact layout, existing trees, and structures.
                - Upgrades: modern landscaping, sophisticated outdoor lighting, premium furniture, water features.
                """
        case "Dining Room":
            return """
                **Dining Room Transformation:**
                - Goal: elegant entertaining space.
                - Preserve: exact layout, all windows, doors.
                - Upgrades: premium finishes, modern flooring, statement chandelier, elegant furniture.
                """
        case "Kids Room":
            return """
                **Kids Room Transformation:**
                - Goal: magical functional space.
                - Preserve: exact layout, all windows, doors.
                - Upgrades: child-safe materials, fun lighting, playful furniture, creative storage.
                """
        case "Game Room":
            return """
                **Game Room Transformation:**
                - Goal: ultimate entertainment space.
                - Preserve: exact layout, all windows, doors.
                - Upgrades: premium finishes, immersive lighting, functional furniture, gaming-themed decor.
                """
        case "Home Gym":
            return """
                **Home Gym Transformation:**
                - Goal: inspiring home fitness center.
                - Preserve: exact layout, all windows, doors.
                - Upgrades: durable materials, flooring for exercise, energizing lighting, functional layout.
                """
        case "Library":
            return """
                **Library Transformation:**
                - Goal: sophisticated reading sanctuary.
                - Preserve: exact layout, all windows, doors.
                - Upgrades: premium finishes, task lighting, functional bookshelves, curated art.
                """
        case "Home Theater":
            return """
                **Home Theater Transformation:**
                - Goal: immersive home theater.
                - Preserve: exact layout, all windows, doors.
                - Upgrades: premium finishes, cinematic lighting, functional seating/equipment layout.
                """
        case "Balcony":
            return """
                **Balcony Transformation:**
                - Goal: charming outdoor retreat.
                - Preserve: exact layout, all railings, doors.
                - Upgrades: weather-resistant materials, cozy outdoor lighting, functional furniture.
                """
        case "Walk-in Closet":
            return """
                **Walk-in Closet Transformation:**
                - Goal: luxury dressing room.
                - Preserve: exact layout, doors, windows.
                - Upgrades: premium finishes, sophisticated lighting, premium storage solutions, mirrors.
                """
        case "Laundry Room":
            return """
                **Laundry Room Transformation:**
                - Goal: functional stylish space.
                - Preserve: exact layout, all doors, windows.
                - Upgrades: durable materials, modern flooring, functional task lighting, smart storage.
                """
        case "Entryway":
            return """
                **Entryway Enhancement:**
                - Goal: welcoming, practical entrance with a strong first impression.
                - Preserve: door placements, circulation, and architectural details.
                - Upgrades: statement lighting (pendant/sconces/LED), console with storage, wall hooks or closet, bench seating, durable easy-clean flooring, large mirror, cohesive decor.
                """
        default:
            return "**\(room.name) Transformation:**\n- Goal: stunning magazine-quality space.\n- Preserve: exact room layout, all windows, doors, structural features.\n- Upgrades: premium finishes, modern flooring, sophisticated lighting."
        }
    }
    
    func generateDesign(from image: UIImage, style: DesignStyle, room: Room) async throws -> UIImage {
        let stylePrompt = createStylePrompt(for: style)
        let roomPrompt = createRoomSpecificPrompt(for: room)
        
        let basePrompt = """
            professional, magazine-quality interior visualization of a \(room.name.lowercased()) in the \(style.name.lowercased()) style.
            
            \(roomPrompt)
            \(stylePrompt)
            
            **CRITICAL REQUIREMENTS:**
            - Maintain EXACT room layout, structural integrity, windows, doors, plumbing, and electrical points.
            - Preserve architectural features and room proportions completely.
            - Create photorealistic, high-end results with perfect lighting, shadows, and architectural accuracy.
            """
        
        let negativePrompt = """
            ugly, low quality, blurry, distorted, disfigured, poor lighting, amateur, unprofessional, unrealistic architecture, altered room structure, moved windows/doors, incorrect perspective, deformed space, low resolution, pixelated, watermark, text, signature, cartoon, illustration.
            """
        
        return try await stabilityService.generateImage(
            from: image,
            prompt: basePrompt,
            negativePrompt: negativePrompt,
            stylePreset: "photographic",
            imageStrength: 0.35
        )
    }
}
