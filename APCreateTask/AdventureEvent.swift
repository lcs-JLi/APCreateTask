//
//  AdventureEvent.swift
//  APCreateTask
//
//  Created by John Li on 2026-11-20.
//  This code was generated using GitHub Copilot.
//  The existing event implementation was not changed.
//

import Foundation

struct AdventureEvent: Identifiable {
    enum Effect {
        case addPoints(Int)
        case addQuestions(Int)
        case none
    }

    struct Choice: Identifiable {
        let title: String
        let detail: String
        let effect: Effect

        var id: String { title }
    }

    let id: String
    let name: String
    let prompt: String
    let choices: [Choice]
}
