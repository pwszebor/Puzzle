//
//  GameState.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 29/12/2017.
//  Copyright © 2017 Pawel Wszeborowski. All rights reserved.
//

import Foundation

fileprivate let elementsCountKey = "ElementsCount"
fileprivate let elementsPositionsKey = "ElementsPositions"
fileprivate let blankPositionKey = "BlankPosition"

typealias GameStateInfoDictionary = [String : Any]

struct GameStateInfo {
    var elementsCount: Int
    var elementsPositions: [Int]

    init(elementsCount: Int, elementsPositions: [Int]) {
        self.elementsCount = elementsCount
        self.elementsPositions = elementsPositions
    }

    init?(fromDictionary dict: GameStateInfoDictionary?) {
        guard let dict = dict else { return nil }
        guard let count = dict[elementsCountKey] as? Int else { return nil }
        guard let positions = dict[elementsPositionsKey] as? [Int] else { return nil }
        self.init(elementsCount: count, elementsPositions: positions)
    }

    var dictionary: GameStateInfoDictionary {
        return [elementsCountKey : elementsCount, elementsPositionsKey : elementsPositions]
    }

    mutating func randomize() {
        elementsPositions = elementsPositions.orderedRandomly()
    }
}

class GameState {
    var info: GameStateInfo

    init(with info: GameStateInfo) {
        guard info.elementsPositions.count == info.elementsCount else {
            let defaultState = GameState.randomState(withDifficultyLevel: .normal)
            self.info = defaultState.info
            return
        }
        self.info = info
    }

    static func randomState(withDifficultyLevel level: GameDifficulty) -> GameState {
        return GameState(with: GameStateInfo(elementsCount: level.numberOfElements, elementsPositions: Array(0..<level.numberOfElements).orderedRandomly()))
    }

    func checkVictory() -> Bool {
        return info.elementsPositions == Array(0..<info.elementsCount)
    }
}
