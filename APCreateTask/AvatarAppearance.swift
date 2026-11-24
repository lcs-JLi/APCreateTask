//
//  AvatarAppearance.swift
//  APCreateTask
//
//  Created by John Li on 2026-11-20.
//  This code was generated using GitHub Copilot:
//  Main definitions: skin, hairstyle, outfit, equipment, unlock requirements, and displayUsername.
//  Copilot change in this session: added this summary comment only.
//

import SwiftUI

enum AvatarUnlockRequirement: Equatable {
    case level(Int)
    case coins(Int)
    case fortunateWheel
}

struct AvatarAppearance {
    enum SkinTone: String, CaseIterable, Identifiable {
        case light
        case peach
        case golden
        case brown
        case deep
        case rose
        case amber
        case umber

        var id: Self { self }
        var inventoryID: String { "skin.\(rawValue)" }

        var unlockRequirement: AvatarUnlockRequirement? {
            switch self {
            case .rose: .level(8)
            case .amber: .coins(3)
            case .umber: .fortunateWheel
            default: nil
            }
        }

        var name: String {
            switch self {
            case .light: "Light"
            case .peach: "Peach"
            case .golden: "Golden"
            case .brown: "Brown"
            case .deep: "Deep"
            case .rose: "Rose"
            case .amber: "Amber"
            case .umber: "Umber"
            }
        }

        var color: Color {
            switch self {
            case .light: Color(red: 1.00, green: 0.84, blue: 0.69)
            case .peach: Color(red: 0.95, green: 0.70, blue: 0.51)
            case .golden: Color(red: 0.82, green: 0.54, blue: 0.34)
            case .brown: Color(red: 0.58, green: 0.34, blue: 0.22)
            case .deep: Color(red: 0.36, green: 0.22, blue: 0.17)
            case .rose: Color(red: 0.92, green: 0.63, blue: 0.56)
            case .amber: Color(red: 0.74, green: 0.45, blue: 0.26)
            case .umber: Color(red: 0.29, green: 0.18, blue: 0.14)
            }
        }
    }

    enum Hairstyle: String, CaseIterable, Identifiable {
        case curls
        case bow
        case cap
        case flower
        case ponytail
        case spiky
        case braids

        var id: Self { self }
        var inventoryID: String { "hairstyle.\(rawValue)" }

        var unlockRequirement: AvatarUnlockRequirement? {
            switch self {
            case .ponytail: .level(8)
            case .spiky: .coins(3)
            case .braids: .fortunateWheel
            default: nil
            }
        }

        var name: String {
            switch self {
            case .curls: "Curls"
            case .bow: "Bow"
            case .cap: "Cap"
            case .flower: "Flower"
            case .ponytail: "Ponytail"
            case .spiky: "Spiky"
            case .braids: "Braids"
            }
        }

        var symbol: String {
            switch self {
            case .curls: "🦱"
            case .bow: "🎀"
            case .cap: "🧢"
            case .flower: "🌼"
            case .ponytail: "🎀"
            case .spiky: "⚡"
            case .braids: "🪢"
            }
        }
    }

    enum Outfit: String, CaseIterable, Identifiable {
        case tee
        case hoodie
        case dress
        case superhero
        case spaceSuit
        case raincoat
        case wizard

        var id: Self { self }
        var inventoryID: String { "outfit.\(rawValue)" }

        var unlockRequirement: AvatarUnlockRequirement? {
            switch self {
            case .spaceSuit: .level(8)
            case .raincoat: .coins(3)
            case .wizard: .fortunateWheel
            default: nil
            }
        }

        var name: String {
            switch self {
            case .tee: "T-shirt"
            case .hoodie: "Hoodie"
            case .dress: "Dress"
            case .superhero: "Hero"
            case .spaceSuit: "Space Suit"
            case .raincoat: "Raincoat"
            case .wizard: "Wizard"
            }
        }

        var symbol: String {
            switch self {
            case .tee: "👕"
            case .hoodie: "🧥"
            case .dress: "👗"
            case .superhero: "🦸"
            case .spaceSuit: "🚀"
            case .raincoat: "🌧️"
            case .wizard: "🧙"
            }
        }
    }

    enum Equipment: String, CaseIterable, Identifiable {
        case pen
        case notebook
        case backpack

        var id: Self { self }
        var inventoryID: String { "equipment.\(rawValue)" }

        var unlockRequirement: AvatarUnlockRequirement? {
            self == .backpack ? .coins(10) : nil
        }

        var name: String {
            switch self {
            case .pen: "Regular pen"
            case .notebook: "Notebook"
            case .backpack: "Backpack"
            }
        }

        var effectDescription: String {
            switch self {
            case .pen: "Earn 1 extra point for each correct answer."
            case .notebook: "Protect your current streak from one incorrect answer per run."
            case .backpack: "Earn 30% extra experience."
            }
        }

        var symbol: String {
            switch self {
            case .pen: "🖊️"
            case .notebook: "📓"
            case .backpack: "🎒"
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
            skinTone: SkinTone.allCases
                .filter { $0.unlockRequirement == nil }
                .randomElement() ?? .golden,
            hairstyle: Hairstyle.allCases
                .filter { $0.unlockRequirement == nil }
                .randomElement() ?? .curls,
            outfit: Outfit.allCases
                .filter { $0.unlockRequirement == nil }
                .randomElement() ?? .tee,
            equippedEquipment: Set(
                Equipment.allCases
                    .filter { $0.unlockRequirement == nil }
                    .filter { _ in Bool.random() }
            )
        )
    }
}
