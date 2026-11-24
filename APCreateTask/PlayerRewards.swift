//
//  PlayerRewards.swift
//  APCreateTask
//
//  Created by John Li on 2026-11-20.
//  This code was generated using GitHub Copilot.
//  The existing reward calculations were not changed.
//

enum PlayerRewards {
    private static let experiencePerCoin = 20.0

    static func experienceWithBackpackBonus(_ earned: Double, backpackEquipped: Bool) -> Double {
        backpackEquipped ? earned * 1.3 : earned
    }

    @discardableResult
    static func awardExperience(
        _ earned: Double,
        level: inout Int,
        experience: inout Double,
        coins: inout Int,
        coinExperienceProgress: inout Double
    ) -> Int {
        var accumulatedExperience = experience + earned
        while accumulatedExperience >= 100 {
            level += 1
            accumulatedExperience -= 100
        }
        experience = accumulatedExperience

        let accumulatedCoinExperience = coinExperienceProgress + earned
        let coinsEarned = Int(accumulatedCoinExperience / experiencePerCoin)
        coinExperienceProgress = accumulatedCoinExperience - Double(coinsEarned) * experiencePerCoin
        coins += coinsEarned
        return coinsEarned
    }
}
