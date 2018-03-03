//
//  NewGameViewController.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 29/12/2017.
//  Copyright © 2017 Pawel Wszeborowski. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {
    private let defaultGameButton = GameMenuButton()
    private let loadImageButton = GameMenuButton()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [defaultGameButton, loadImageButton])
        stackView.axis = .vertical
        stackView.spacing = 20

        defaultGameButton.addTarget(self, action: #selector(defaultGame), for: .touchUpInside)
        defaultGameButton.setTitle("DEFAULT PUZZLE", for: .normal)
        loadImageButton.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
        loadImageButton.setTitle("LOAD IMAGE...", for: .normal)

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
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator.stopAnimating()
    }

    @objc private func defaultGame() {
        startGame(withImage: nil)
    }

    @objc private func loadImage() {
        activityIndicator.startAnimating()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            present(picker, animated: true, completion: {
                self.activityIndicator.stopAnimating()
            })
        }
    }

    internal func startGame(withImage img: UIImage?) {
        activityIndicator.startAnimating()
        let difficultyChoiceController = UIAlertController(title: "Choose difficulty", message: "", preferredStyle: .actionSheet)
        if UIDevice.current.userInterfaceIdiom == .pad {
            difficultyChoiceController.modalPresentationStyle = .popover
            difficultyChoiceController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            difficultyChoiceController.popoverPresentationController?.sourceView = view
            difficultyChoiceController.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: view.frame.midX, y: view.frame.midY), size: .zero)
        }
        difficultyChoiceController.modalPresentationStyle = .popover
        for difficulty in GameDifficulty.difficulties {
            difficultyChoiceController.addAction(UIAlertAction(title: difficulty.description(), style: .default, handler: { _ in
                let gameVC = GameViewController(withGame: Game(withImage: img, andState: GameState.randomState(withDifficultyLevel: difficulty)))
                let navigation = self.navigationController
                navigation?.popViewController(animated: false)
                navigation?.pushViewController(gameVC, animated: true)
            }))
        }
        difficultyChoiceController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.activityIndicator.stopAnimating()
        }))
        present(difficultyChoiceController, animated: true, completion: nil)
    }
}

extension NewGameViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            guard let img = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
            self.startGame(withImage: img)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
