enum PlayerRewards {
    private static let experiencePerCoin = 20.0

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
