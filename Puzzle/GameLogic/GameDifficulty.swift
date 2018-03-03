//
//  GameDifficulty.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 29/12/2017.
//  Copyright © 2017 Pawel Wszeborowski. All rights reserved.
//

enum GameDifficulty: Int {
    case easy = 3
    case normal = 4
    case hard = 5
    case veryHard = 6

    static let difficulties: [GameDifficulty] = [.easy, .normal, .hard, .veryHard]

    func description() -> String {
        var description = ""
        switch self {
        case .easy:
            description = "Easy"
        case .normal:
            description = "Normal"
        case .hard:
            description = "Hard"
        case .veryHard:
            description = "Very hard"
        }
        description += " - \(rawValue)x\(rawValue)"
        return description
    }

    var numberOfElements: Int {
        return rawValue * rawValue
    }
}
