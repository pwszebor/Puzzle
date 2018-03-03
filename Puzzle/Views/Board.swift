//
//  Board.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 30/12/2017.
//  Copyright © 2017 Pawel Wszeborowski. All rights reserved.
//

import UIKit

protocol BoardDelegate: class {
    func positionsChanged(_ new: [TilePosition])
}

class Board: UIView {
    internal var tiles = [Tile]()
    internal var positions = [TilePosition]()

    internal var touchBeginLocation: CGPoint?
    internal var blockMoves = false
    internal var tileBeingMoved: Tile?
    internal var positionOfTileBeingMoved: TilePosition?
    internal var staticFrameOfTileBeingMoved: CGRect?

    weak var delegate: BoardDelegate?

    init(withImages images: [UIImage], andPositions positions: [TilePosition]) {
        super.init(frame: .zero)
        tiles = images.map { Tile(image: $0) }
        setupView()
    }

    init(forDefaultGameWithDifficulty d: GameDifficulty) {
        super.init(frame: .zero)
        tiles = Array(0..<d.numberOfElements).map { Tile.defaultTile(withNumber: $0 + 1) }
        setupView()
    }

    private func setupView() {
        tiles.forEach {
            self.addSubview($0)
        }
        tiles.last?.alpha = 0.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func positionTiles() {
        tiles.forEach {
            $0.frame = calculateFrameFor(tile: $0)
        }
    }

    func updatePositions(with p: [TilePosition]) {
        UIView.animate(withDuration: 0.5, animations: {
            self.positions = p
            self.positionTiles()
            self.layoutIfNeeded()
        }, completion: { _ in
            self.delegate?.positionsChanged(self.positions)
        })
    }

    func victoryAnimation() {
        blockMoves = true
        UIView.animate(withDuration: 1) {
            self.tiles.last?.alpha = 1.0
        }
    }

    internal var tileSize: CGSize {
        let numOfTilesInARow = CGFloat(sqrt(Double(tiles.count)))
        guard numOfTilesInARow != 0 else { return .zero }
        return CGSize(width: frame.size.width / numOfTilesInARow, height: frame.size.height / numOfTilesInARow)
    }

    internal func calculateFrameFor(tile: Tile) -> CGRect {
        guard let index = tiles.index(of: tile) else { return .zero }
        let position = positions[index]
        let size = tileSize
        return CGRect(origin: CGPoint(x: CGFloat(position.x) * size.width, y: CGFloat(position.y) * size.height), size: tileSize)
    }

    internal func isMovable(tile: Tile) -> Bool {
        guard let index = tiles.index(of: tile) else { return false }
        let position = positions[index]
        let positionOfBlank = positions.last ?? .zero
        return position.isNeighbour(of: positionOfBlank)
    }

    internal func positionOf(tile: Tile) -> TilePosition {
        guard let index = tiles.index(of: tile) else { return .zero }
        return positions[index]
    }

    internal var blankFrame: CGRect {
        return tiles.last?.frame ?? .zero
    }

    internal var blankPosition: TilePosition {
        return positions.last ?? .zero
    }
}

extension Board {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard !blockMoves else { return }
        guard let location = touches.first?.location(in: self) else { return }
        touchBeginLocation = location
        tileBeingMoved = tiles.first { $0.frame.contains(location) }
        if let tileBeingMoved = tileBeingMoved {
            positionOfTileBeingMoved = positionOf(tile: tileBeingMoved)
            staticFrameOfTileBeingMoved = calculateFrameFor(tile: tileBeingMoved)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard !blockMoves else { return }
        guard let previousLocation = touches.first?.previousLocation(in: self), let location = touches.first?.location(in: self) else { return }
        guard let tileBeingMoved = tileBeingMoved else { return }
        guard let positionOfTileBeingMoved = positionOfTileBeingMoved else { return }
        guard let staticFrameOfTileBeingMoved = staticFrameOfTileBeingMoved else { return }

        guard isMovable(tile: tileBeingMoved) else { return }

        let positionOfBlank = blankPosition

        if positionOfTileBeingMoved.x != positionOfBlank.x {
            let deltaX = location.x - previousLocation.x
            var newOriginX = tileBeingMoved.frame.origin.x + deltaX
            if positionOfBlank.x > positionOfTileBeingMoved.x {
                newOriginX = max(staticFrameOfTileBeingMoved.origin.x, min(newOriginX, staticFrameOfTileBeingMoved.maxX))
            } else {
                newOriginX = max(blankFrame.origin.x, min(newOriginX, staticFrameOfTileBeingMoved.origin.x))
            }
            tileBeingMoved.frame.origin.x = newOriginX
        } else if positionOfTileBeingMoved.y != positionOfBlank.y {
            let deltaY = location.y - previousLocation.y
            var newOriginY = tileBeingMoved.frame.origin.y + deltaY
            if positionOfBlank.y > positionOfTileBeingMoved.y {
                newOriginY = max(staticFrameOfTileBeingMoved.origin.y, min(newOriginY, staticFrameOfTileBeingMoved.maxY))
            } else {
                newOriginY = max(blankFrame.origin.y, min(newOriginY, staticFrameOfTileBeingMoved.origin.y))
            }
            tileBeingMoved.frame.origin.y = newOriginY
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchesEnded(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard !blockMoves else { return }
        guard let tileBeingMoved = tileBeingMoved else { return }
        guard isMovable(tile: tileBeingMoved) else { return }
        guard let positionOfTileBeingMoved = positionOfTileBeingMoved else { return }
        guard let indexOfMovedTile = tiles.index(of: tileBeingMoved) else { return }
        guard let staticFrameOfTileBeingMoved = staticFrameOfTileBeingMoved else { return }

        let swapTiles = {
            UIView.animate(withDuration: 0.1, animations: {
                tileBeingMoved.frame = self.blankFrame
                self.tiles.last?.frame = staticFrameOfTileBeingMoved
            }, completion: { _ in
                self.positions[indexOfMovedTile] = self.blankPosition
                self.positions[self.positions.count - 1] = positionOfTileBeingMoved
                self.delegate?.positionsChanged(self.positions)
            })
        }

        if let location = touches.first?.location(in: self), let touchBeginLocation = touchBeginLocation {
            if location == touchBeginLocation {
                swapTiles()
                return
            }
        }

        if tileBeingMoved.frame.origin.distance(from: staticFrameOfTileBeingMoved.origin) >= tileSize.width / 2 {
            swapTiles()
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                tileBeingMoved.frame = staticFrameOfTileBeingMoved
            })
        }
    }
}
