import SwiftUI

protocol AIDesignServiceProtocol {
    func generateDesign(from image: UIImage, style: DesignStyle, room: Room) async throws -> UIImage
}

class AIDesignService: AIDesignServiceProtocol {
    private let stabilityService = StabilityAIService.shared
    private let revenueCatService = RevenueCatService.shared
    
    // DETAYLI STYLE PROMPT'LARI - Room+Style+Ana prompt = 1900 karakter
    private func createStylePrompt(for style: DesignStyle) -> String {
        switch style.name {
        case "style_organic_modern":
            return "organic modern style: natural oak wood, travertine stone, linen fabrics, warm beige and sage green palette, curved furniture, abundant plants, soft natural lighting, earth tones, sustainable materials, biophilic design, organic shapes, natural textures"
        case "style_vintage":
            return "vintage mid-century style: mustard yellow, teal blue, coral pink accents, retro furniture with tapered legs, brass hardware, geometric patterns, atomic age decor, clean lines, vintage lighting, Eames-style chairs, record player, atomic motifs"
        case "style_gothic":
            return "gothic style: deep black and burgundy walls, emerald green accents, velvet upholstery, dark mahogany furniture, pointed arches, crystal chandeliers, ornate mirrors, gothic patterns, dramatic shadows, medieval-inspired decor, dark romantic atmosphere"
        case "style_gamer":
            return "gaming setup style: RGB LED lighting strips, ergonomic gaming chairs, multiple monitors, mechanical keyboard, gaming mouse, tech-inspired furniture, cable management systems, neon accents, gaming posters, headset stand, RGB peripherals"
        case "style_technoland":
            return "futuristic tech style: tempered glass surfaces, brushed aluminum, LED panel lighting, smart home technology, holographic displays, sleek minimalist lines, touch controls, automated systems, high-tech materials, sci-fi aesthetics, digital interfaces"
        case "style_bohem":
            return "bohemian style: rattan and bamboo furniture, earthy terracotta tones, vibrant jewel colors, eclectic patterns, macrame wall hangings, plants everywhere, handmade ceramics, vintage rugs, layered textures, artistic freedom, global influences"
        case "style_classic":
            return "classic traditional style: light beige and cream walls, symmetrical furniture layout, dark hardwood floors, marble accents, warm neutral colors, refined architectural details, elegant white trim, crown molding, timeless elegance, formal arrangement"
        case "style_dark_theme":
            return "dark moody style: deep black and charcoal walls, navy blue accents, metallic gold and silver finishes, dramatic spotlighting, leather furniture, velvet textures, moody atmosphere, sophisticated contrast, intimate lighting, luxurious darkness"
        case "style_light_theme":
            return "light airy style: pure white walls, soft cream and ivory accents, bright pastel colors, abundant natural sunlight, minimalist furniture, clean geometric lines, light oak wood, sheer curtains, fresh and bright atmosphere, Scandinavian influence"
        case "style_industrial":
            return "industrial style: exposed brick walls, concrete floors, steel beams, iron fixtures, high ceilings, raw materials, vintage Edison bulbs, metal shelving, distressed wood, urban loft character, utilitarian design, warehouse aesthetics"
        case "style_japandi":
            return "japandi zen style: light ash wood, natural textures, clean minimal lines, neutral color palette, functional furniture, zen garden elements, paper screens, bamboo accents, meditation space, peaceful atmosphere, wabi-sabi philosophy"
        case "style_loft":
            return "urban loft style: high exposed ceilings, open floor plan, industrial elements, spacious layout, large windows, contemporary furniture, modern art, concrete accents, steel details, urban sophistication, converted warehouse feel"
        case "style_luxury":
            return "luxury premium style: white marble surfaces, gold and brass accents, crystal chandeliers, high-end designer furniture, sophisticated color palette, premium materials, elegant details, opulent finishes, refined taste, palatial grandeur"
        case "style_turkish":
            return "turkish traditional style: handwoven carpets, ceramic tiles, warm red and gold colors, ornate patterns, cultural motifs, traditional furniture, copper accents, mosaic details, rich textures, authentic craftsmanship, Ottoman influence"
        case "style_rustic":
            return "rustic cabin style: reclaimed wood beams, natural stone, warm earthy tones, cozy textiles, leather accents, wrought iron details, vintage decor, fireplace centerpiece, handmade furniture, woven rugs, farmhouse influences"
        case "style_eighty_style":
            return "1980s retro style: bold neon colors, geometric patterns, lacquered surfaces, chrome accents, glass blocks, mirrored finishes, pop art decor, Memphis design influences, glossy furniture, black and white checker patterns, fluorescent lighting"
        case "style_tropic":
            return "tropical style: lush indoor plants, rattan and bamboo furniture, natural linen and cotton fabrics, vibrant green and teal accents, light wood tones, airy curtains, woven textures, tropical leaf patterns, abundant natural light, coastal vibes"
        default:
            return "beautiful \(style.name.lowercased()) style: premium materials, contemporary comfort, sophisticated design, quality finishes"
        }
    }
    
    // DETAYLI ROOM PROMPT'LARI - Room+Style+Ana prompt = 1900 karakter
    private func createRoomPrompt(for room: Room) -> String {
        switch room.name {
        case "room_living_room":
            return "luxury living room: comfortable sectional sofa, coffee table, entertainment center, accent chairs, area rug, floor lamps, wall art, plants, throw pillows, bookshelves, fireplace, large windows, side tables, decorative objects"
        case "room_bedroom":
            return "luxury bedroom: king-size bed with headboard, nightstands, dresser, wardrobe, reading chair, bedside lamps, curtains, area rug, wall art, plants, cozy seating area, vanity table, mirror, storage bench"
        case "room_kitchen":
            return "chef kitchen: island with seating, stainless steel appliances, granite countertops, subway tile backsplash, pendant lighting, bar stools, wine rack, pot rack, fruit bowl, herb garden, breakfast nook, pantry"
        case "room_bathroom":
            return "spa bathroom: freestanding bathtub, walk-in shower, double vanity, mirror, towel rack, plants, candles, bath mat, storage baskets, natural stone tiles, dimmable lighting, heated floors"
        case "room_home_office":
            return "productive workspace: ergonomic desk, office chair, computer setup, bookshelves, filing cabinet, desk lamp, plants, motivational art, storage boxes, whiteboard, comfortable seating, printer stand"
        case "room_laundry_room":
            return "organized laundry room: front-load washer and dryer, countertop folding station, upper and lower cabinets, open shelving, laundry baskets, hanging rod, utility sink, detergent and supplies organizer, tiled backsplash, bright task lighting, ventilation, ironing station, wall hooks"
        case "room_garden":
            return "beautiful garden: lush green grass, colorful flower beds, flowering shrubs, ornamental trees, stone pathways, garden bench, bird bath, outdoor lighting, potted plants, herb garden, water feature, garden tools, decorative stones, pergola"
        case "room_dining_room":
            return "elegant dining: dining table with chairs, chandelier, sideboard, wine cabinet, table centerpiece, curtains, area rug, wall art, plants, candle holders, placemats, serving dishes, china cabinet"
        case "room_kids_room":
            return "magical kids space: bunk bed or twin beds, toy storage, play area, desk for homework, colorful rugs, wall decals, bookshelf, bean bag chair, night light, stuffed animals, art supplies, growth chart, toy chest"
        case "room_study_room":
            return "focused study room: ergonomic desk, adjustable chair, task lighting, large bookshelf, organized storage, pinboard or whiteboard, cable management, quiet acoustic treatment, minimal distractions, indoor plant, desk organizer, cozy reading nook"
        case "room_entertainment":
            return "entertainment space: gaming setup, comfortable seating, LED lighting, sound system, game storage, mini fridge, snack area, posters, gaming chairs, multiple screens, cable management, headset stand"
        case "room_home_gym":
            return "fitness center: exercise equipment, yoga mat, mirrors, motivational posters, water station, towel rack, storage for weights, rubber flooring, bright lighting, music system, fitness tracker, resistance bands"
        case "room_library":
            return "reading sanctuary: floor-to-ceiling bookshelves, reading chair, reading lamp, coffee table, plants, comfortable seating, book ladder, reading nook, quiet atmosphere, desk for writing, ladder"
        case "room_balcony":
            return "outdoor retreat: weather-resistant furniture, potted plants, string lights, outdoor rug, small table, comfortable chairs, privacy screen, herb garden, bird feeder, cozy atmosphere, outdoor cushions"
        case "room_entryway":
            return "welcoming entrance: console table, mirror, coat rack, shoe storage, umbrella stand, welcome mat, key holder, decorative items, good lighting, seating bench, mail organizer, umbrella holder"
        case "room_pantry":
            return "organized pantry: floor-to-ceiling shelving, labeled containers, glass jars, pull-out baskets, tiered can racks, spice organizers, bulk storage bins, small appliance zone, countertop for prep, step stool, door racks, good ventilation, task lighting"
        default:
            return "stunning \(room.name.lowercased()): premium finishes, sophisticated lighting, functional furniture, decorative elements"
        }
    }
    
    func generateDesign(from image: UIImage, style: DesignStyle, room: Room) async throws -> UIImage {
        // 🔒 PREMIUM KONTROLÜ
        guard revenueCatService.isPro else {
            throw StabilityAIError.apiError("Premium subscription required to generate images. Please subscribe to continue.")
        }
        
        let stylePrompt = createStylePrompt(for: style)
        let roomPrompt = createRoomPrompt(for: room)
        
        // DETAYLI ANA PROMPT - Room+Style+Ana prompt = 1900 karakter
        let roomDisplayName = getRoomDisplayName(room.name)
        let styleDisplayName = getStyleDisplayName(style.name)
        
        let basePrompt = """
            Transform this \(roomDisplayName) into \(styleDisplayName) style. \(roomPrompt). \(stylePrompt). 
            Keep exact layout and structural elements. Upgrade materials, lighting, furniture, decor with premium finishes. 
            Ensure bright, well-lit spaces with natural lighting. MUST BE PHOTOREALISTIC AND REALISTIC. 
            Real photography quality, proper scale, high quality finishes, magazine worthy interior design, professional photography.
            """
        
        // KISA NEGATİVE PROMPT
        let negativePrompt = "ugly, blurry, distorted, altered structure, wrong scale, cartoon, watermark, text"
        
        // 📝 PROMPT LOGLAMA
        print("🎨 AIDesignService: Generating design for \(room.name) in \(style.name) style")
        print("📏 Room Prompt (\(roomPrompt.count) chars): \(roomPrompt)")
        print("🎭 Style Prompt (\(stylePrompt.count) chars): \(stylePrompt)")
        print("📝 Base Prompt (\(basePrompt.count) chars): \(basePrompt)")
        print("❌ Negative Prompt (\(negativePrompt.count) chars): \(negativePrompt)")
        print("📊 Total Prompt Length: \(basePrompt.count) characters")
        
        return try await stabilityService.generateImage(
            from: image,
            prompt: basePrompt,
            negativePrompt: negativePrompt,
            stylePreset: "photographic",
            imageStrength: 0.35 // Biraz daha fazla değişiklik için artırdım
        )
    }
    
    // Helper fonksiyonlar - localized key'leri gerçek isimlere çevir
    private func getRoomDisplayName(_ roomName: String) -> String {
        switch roomName {
        case "room_living_room": return "living room"
        case "room_bedroom": return "bedroom"
        case "room_kitchen": return "kitchen"
        case "room_bathroom": return "bathroom"
        case "room_home_office": return "office"
        case "room_garden": return "garden"
        case "room_dining_room": return "dining room"
        case "room_kids_room": return "kids room"
        case "room_entertainment": return "entertainment room"
        case "room_home_gym": return "home gym"
        case "room_library": return "library"
        case "room_balcony": return "balcony"
        case "room_entryway": return "entryway"
        case "room_pantry": return "pantry"
        case "room_laundry_room": return "laundry room"
        case "room_study_room": return "study room"
        default: return roomName.lowercased()
        }
    }
    
    private func getStyleDisplayName(_ styleName: String) -> String {
        switch styleName {
        case "style_organic_modern": return "organic modern"
        case "style_vintage": return "vintage"
        case "style_gothic": return "gothic"
        case "style_gamer": return "gamer"
        case "style_technoland": return "technoland"
        case "style_bohem": return "bohemian"
        case "style_classic": return "classic"
        case "style_dark_theme": return "dark theme"
        case "style_light_theme": return "light theme"
        case "style_industrial": return "industrial"
        case "style_japandi": return "japandi"
        case "style_loft": return "loft"
        case "style_luxury": return "luxury"
        case "style_turkish": return "turkish"
        case "style_rustic": return "rustic"
        case "style_eighty_style": return "80s retro"
        case "style_tropic": return "tropic"
        default: return styleName.lowercased()
        }
    }
}
