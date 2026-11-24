//
//  FortuneWheelPrize.swift
//  APCreateTask
//
//  Created by John Li on 2026-11-20.
//  This code was generated using GitHub Copilot.
//  The existing prize definitions were not changed.
//

enum FortuneWheelPrize: CaseIterable, Hashable {
    case twoCoins
    case wizard
    case nothing
    case braids
    case tenCoins
    case umber

    var percentage: Int {
        switch self {
        case .twoCoins: 30
        case .wizard: 10
        case .nothing: 10
        case .braids: 10
        case .tenCoins: 30
        case .umber: 10
        }
    }

    var wheelLabel: String {
        switch self {
        case .twoCoins: "2 Coins"
        case .wizard: "Wizard"
        case .nothing: "Nothing"
        case .braids: "Braids"
        case .tenCoins: "10 Coins"
        case .umber: "Umber"
        }
    }

    static func random() -> Self {
        let roll = Int.random(in: 0..<100)
        var upperBound = 0

        for prize in allCases {
            upperBound += prize.percentage
            if roll < upperBound {
                return prize
            }
        }

        return .nothing
    }
}
