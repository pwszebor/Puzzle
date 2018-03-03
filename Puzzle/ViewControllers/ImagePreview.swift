//
//  ImagePreview.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 30/12/2017.
//  Copyright © 2017 Pawel Wszeborowski. All rights reserved.
//

import UIKit

class ImagePreview: UIViewController {
    private let imageView = UIImageView()
    private var image: UIImage?

    convenience init(ofImage img: UIImage) {
        self.init(nibName: nil, bundle: nil)
        image = img
        modalPresentationStyle = .overFullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)

        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)

        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.8).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9).isActive = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true, completion: nil)
    }
}
