//
//  ExperienceProgressView.swift
//  APCreateTask
//
//  Created by John Li on 2026-11-20.
//  This code was generated using GitHub Copilot.
//  The existing experience progress implementation was not changed.
//

import SwiftUI

struct ExperienceProgressView: View {
    let level: Int
    let experience: Double
    var earnedThisRun: Double? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Experience")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))

                Spacer()

                Text("LV. \(level)")
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.49, green: 0.39, blue: 0.14))
            }

            ProgressView(value: min(max(experience, 0), 100), total: 100)
                .tint(Color(red: 0.20, green: 0.58, blue: 0.49))
                .accessibilityLabel("Experience")
                .accessibilityValue(
                    "\(experience.formatted(.number.precision(.fractionLength(0...1)))) of 100"
                )

            HStack {
                Text("\(experience.formatted(.number.precision(.fractionLength(0...1)))) / 100 XP")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)

                Spacer()

                if let earnedThisRun {
                    Text("+\(earnedThisRun.formatted(.number.precision(.fractionLength(0...1)))) XP this run")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
                }
            }
        }
        .padding(14)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 18))
    }
}
