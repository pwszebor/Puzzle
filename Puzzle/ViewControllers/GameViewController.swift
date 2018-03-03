//
//  GameViewController.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 29/12/2017.
//  Copyright © 2017 Pawel Wszeborowski. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    private let game: Game
    private let board: Board
    internal let victoryLabel = UILabel()

    init(withGame g: Game) {
        game = g
        let diff = game.difficulty
        if let image = game.image {
            board = Board(withImages: image.splitInto(rows: diff.rawValue, cols: diff.rawValue), andPositions: TilePosition.array(from: game.state.info.elementsPositions, withDifficulty: diff.rawValue))
        } else {
            board = Board(forDefaultGameWithDifficulty: diff)
        }
        super.init(nibName: nil, bundle: nil)
    }

    init(forDefaultGameWithDifficulty d: GameDifficulty) {
        let state = GameState.randomState(withDifficultyLevel: d)
        board = Board(forDefaultGameWithDifficulty: d)
        game = Game(withImage: nil, andState: state)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)

        view.backgroundColor = .white

        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffle))]
        if game.image != nil {
            navigationItem.rightBarButtonItems?.append(UIBarButtonItem(title: "Preview", style: .plain, target: self, action: #selector(preview)))
        }

        board.delegate = self

        board.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(board)
        board.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        board.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        board.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        board.heightAnchor.constraint(equalTo: board.widthAnchor).isActive = true
        board.alpha = 0.0

        victoryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(victoryLabel)
        victoryLabel.font = UIFont.boldSystemFont(ofSize: 40)
        victoryLabel.textColor = .black
        victoryLabel.text = "VICTORY!"
        victoryLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        victoryLabel.topAnchor.constraint(equalTo: board.bottomAnchor, constant: 20).isActive = true
        victoryLabel.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.board.alpha = 1.0
        }
        board.updatePositions(with: TilePosition.array(from: game.state.info.elementsPositions, withDifficulty: game.difficulty.rawValue))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.save()
    }

    @objc private func shuffle() {
        game.state.info.randomize()
        board.updatePositions(with: TilePosition.array(from: game.state.info.elementsPositions, withDifficulty: game.difficulty.rawValue))
    }

    @objc private func preview() {
        guard let image = game.image else { return }
        let preview = ImagePreview(ofImage: image)
        present(preview, animated: true, completion: nil)
    }
}

extension GameViewController: BoardDelegate {
    func positionsChanged(_ new: [TilePosition]) {
        game.state.info.elementsPositions = new.map { $0.toInt(withDifficulty: game.difficulty.rawValue) }
        if game.state.checkVictory() {
            board.victoryAnimation()
            UIView.animate(withDuration: 1, animations: {
                self.victoryLabel.alpha = 1.0
                self.navigationItem.rightBarButtonItems = []
            })
        }
    }
}
