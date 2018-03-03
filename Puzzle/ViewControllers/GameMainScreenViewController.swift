//
//  GameMainScreenViewController.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 29/12/2017.
//  Copyright © 2017 Pawel Wszeborowski. All rights reserved.
//

import UIKit

class GameMenuButton: UIButton {
    convenience init() {
        self.init(frame: .zero)
        titleLabel?.textColor = .black
        backgroundColor = .orange
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }
}

class GameMainScreenViewController: UIViewController {
    private let newGameButton = GameMenuButton()
    private let loadPreviousGameButton = GameMenuButton()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [newGameButton, loadPreviousGameButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        newGameButton.addTarget(self, action: #selector(newGame), for: .touchUpInside)
        newGameButton.setTitle("NEW GAME", for: .normal)
        loadPreviousGameButton.addTarget(self, action: #selector(loadPreviousGame), for: .touchUpInside)
        loadPreviousGameButton.setTitle("LOAD PREVIOUS GAME", for: .normal)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7).isActive = true

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadPreviousGameButton.isHidden = Game.previousGame == nil
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator.stopAnimating()
    }

    @objc private func newGame() {
        activityIndicator.startAnimating()
        let newGameVC = NewGameViewController()
        navigationController?.pushViewController(newGameVC, animated: true)
    }

    @objc private func loadPreviousGame() {
        activityIndicator.startAnimating()
        guard let previousGame = Game.previousGame else {
            activityIndicator.stopAnimating()
            return
        }
        let gameVC = GameViewController(withGame: previousGame)
        navigationController?.pushViewController(gameVC, animated: true)
    }
}
