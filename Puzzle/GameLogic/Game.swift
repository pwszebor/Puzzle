//
//  Game.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 29/12/2017.
//  Copyright © 2017 Pawel Wszeborowski. All rights reserved.
//

import UIKit

fileprivate let previousGameStateKey = "PreviousGameStateKey"
fileprivate let previousGameImageFileName = "PuzzleGamePreviousGameImage"

class Game {
    var image: UIImage?
    var state: GameState

    var difficulty: GameDifficulty {
        return GameDifficulty(rawValue: Int(sqrt(Double(state.info.elementsCount)))) ?? .normal
    }

    private static var imgFilePath: String? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return dir.appendingPathComponent(previousGameImageFileName).path
    }

    init(withImage img: UIImage?, andState s: GameState) {
        image = img
        state = s
    }

    static var previousGame: Game? {
        guard let previousGameStateInfo = GameStateInfo(fromDictionary: UserDefaults.standard.object(forKey: previousGameStateKey) as? GameStateInfoDictionary) else { return nil }
        guard let previousImgPath = Game.imgFilePath else { return nil }
        if FileManager.default.fileExists(atPath: previousImgPath), let image = UIImage(named: previousImgPath) {
            return Game(withImage: image, andState: GameState(with: previousGameStateInfo))
        }
        return Game(withImage: nil, andState: GameState(with: previousGameStateInfo))
    }

    func save() {
        if let imgSaveUrl = Game.imgFilePath {
            if let image = image {
                FileManager.default.createFile(atPath: imgSaveUrl, contents: UIImagePNGRepresentation(image), attributes: nil)
            } else if FileManager.default.isDeletableFile(atPath: imgSaveUrl) {
                try? FileManager.default.removeItem(atPath: imgSaveUrl)
            }
        }
        UserDefaults.standard.set(state.info.dictionary, forKey: previousGameStateKey)
    }
}
