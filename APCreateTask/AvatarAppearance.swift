import SwiftUI

struct AvatarAppearance {
    enum SkinTone: String, CaseIterable, Identifiable {
        case light
        case peach
        case golden
        case brown
        case deep

        var id: Self { self }

        var name: String {
            switch self {
            case .light: "Light"
            case .peach: "Peach"
            case .golden: "Golden"
            case .brown: "Brown"
            case .deep: "Deep"
            }
        }

        var color: Color {
            switch self {
            case .light: Color(red: 1.00, green: 0.84, blue: 0.69)
            case .peach: Color(red: 0.95, green: 0.70, blue: 0.51)
            case .golden: Color(red: 0.82, green: 0.54, blue: 0.34)
            case .brown: Color(red: 0.58, green: 0.34, blue: 0.22)
            case .deep: Color(red: 0.36, green: 0.22, blue: 0.17)
            }
        }
    }

    enum Hairstyle: String, CaseIterable, Identifiable {
        case curls
        case bow
        case cap
        case flower

        var id: Self { self }

        var name: String {
            switch self {
            case .curls: "Curls"
            case .bow: "Bow"
            case .cap: "Cap"
            case .flower: "Flower"
            }
        }

        var symbol: String {
            switch self {
            case .curls: "🦱"
            case .bow: "🎀"
            case .cap: "🧢"
            case .flower: "🌼"
            }
        }
    }

    enum Outfit: String, CaseIterable, Identifiable {
        case tee
        case hoodie
        case dress
        case superhero

        var id: Self { self }

        var name: String {
            switch self {
            case .tee: "T-shirt"
            case .hoodie: "Hoodie"
            case .dress: "Dress"
            case .superhero: "Hero"
            }
        }

        var symbol: String {
            switch self {
            case .tee: "👕"
            case .hoodie: "🧥"
            case .dress: "👗"
            case .superhero: "🦸"
            }
        }
    }

    enum Equipment: String, CaseIterable, Identifiable {
        case pen
        case notebook

        var id: Self { self }

        var name: String {
            switch self {
            case .pen: "Regular pen"
            case .notebook: "Notebook"
            }
        }

        var effectDescription: String {
            switch self {
            case .pen: "Earn 1 extra point for each correct answer."
            case .notebook: "Protect your current streak from one incorrect answer per run."
            }
        }

        var symbol: String {
            switch self {
            case .pen: "🖊️"
            case .notebook: "📓"
            }
        }
    }

    var skinTone: SkinTone = .golden
    var hairstyle: Hairstyle = .curls
    var outfit: Outfit = .tee
    var equippedEquipment: Set<Equipment> = []
    var username = ""

    var displayUsername: String? {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedUsername.isEmpty ? nil : trimmedUsername
    }

    static var random: Self {
        Self(
            skinTone: SkinTone.allCases.randomElement() ?? .golden,
            hairstyle: Hairstyle.allCases.randomElement() ?? .curls,
            outfit: Outfit.allCases.randomElement() ?? .tee,
            equippedEquipment: Set(Equipment.allCases.filter { _ in Bool.random() })
        )
    }
}
