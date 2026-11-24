enum AvatarShopCategory: String, CaseIterable, Identifiable {
    case skinTone = "Skin Tones"
    case hairstyle = "Hairstyles"
    case outfit = "Outfits"

    var id: Self { self }
}

enum AvatarShopItem: Identifiable {
    case skin(AvatarAppearance.SkinTone)
    case hairstyle(AvatarAppearance.Hairstyle)
    case outfit(AvatarAppearance.Outfit)

    static let styleItems: [Self] = [
        .skin(.rose), .skin(.amber), .skin(.umber),
        .hairstyle(.ponytail), .hairstyle(.spiky), .hairstyle(.braids),
        .outfit(.spaceSuit), .outfit(.raincoat), .outfit(.wizard)
    ]

    static let allItems = styleItems

    var id: String {
        switch self {
        case .skin(let item): item.inventoryID
        case .hairstyle(let item): item.inventoryID
        case .outfit(let item): item.inventoryID
        }
    }

    var category: AvatarShopCategory {
        switch self {
        case .skin: .skinTone
        case .hairstyle: .hairstyle
        case .outfit: .outfit
        }
    }

    var name: String {
        switch self {
        case .skin(let item): item.name
        case .hairstyle(let item): item.name
        case .outfit(let item): item.name
        }
    }

    var symbol: String {
        switch self {
        case .skin: "🎨"
        case .hairstyle(let item): item.symbol
        case .outfit(let item): item.symbol
        }
    }

    var unlockRequirement: AvatarUnlockRequirement? {
        switch self {
        case .skin(let item): item.unlockRequirement
        case .hairstyle(let item): item.unlockRequirement
        case .outfit(let item): item.unlockRequirement
        }
    }

    func isUnlocked(level: Int, unlockedItems: Set<String>) -> Bool {
        guard let unlockRequirement else { return true }

        switch unlockRequirement {
        case .level(let requiredLevel):
            return level >= requiredLevel
        case .coins, .fortunateWheel:
            return unlockedItems.contains(id)
        }
    }
}
