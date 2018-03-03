//
//  Tile.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 30/12/2017.
//  Copyright © 2017 Pawel Wszeborowski. All rights reserved.
//

import UIKit

struct TilePosition {
    var x: Int
    var y: Int

    static let zero = TilePosition(x: 0, y: 0)

    static func array(from array: [Int], withDifficulty d: Int) -> [TilePosition] {
        return array.map { TilePosition.from(position: $0, withDifficulty: d) }
    }

    static func from(position: Int, withDifficulty d: Int) -> TilePosition {
        return TilePosition(x: position % d, y: position / d)
    }

    func toInt(withDifficulty d: Int) -> Int {
        return y * d + x
    }

    func isNeighbour(of other: TilePosition) -> Bool {
        return (y == other.y && abs(x - other.x) == 1) || (x == other.x && (abs(y - other.y) == 1))
    }
}

class Tile: UIImageView {
    static func defaultTile(withNumber number: Int) -> Tile {
        let tile = Tile()
        let label = UILabel()
        tile.layer.borderColor = UIColor.black.cgColor
        tile.layer.borderWidth = 3
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .black
        label.text = "\(number)"
        label.translatesAutoresizingMaskIntoConstraints = false
        tile.addSubview(label)
        label.centerXAnchor.constraint(equalTo: tile.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: tile.centerYAnchor).isActive = true
        return tile
    }
}
