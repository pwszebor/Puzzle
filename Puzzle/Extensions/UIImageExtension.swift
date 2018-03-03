//
//  UIImageExtension.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 30/12/2017.
//  Copyright © 2017 Pawel Wszeborowski. All rights reserved.
//

import UIKit

extension UIImage {
    func splitInto(rows: Int, cols: Int) -> [UIImage] {
        var images = [UIImage]()
        images.reserveCapacity(rows * cols)

        var sliceSize = CGSize(width: size.width / CGFloat(cols), height: size.height / CGFloat(rows))

        for row in 0..<rows {
            for col in 0..<cols {
                let origin = CGPoint(x: CGFloat(col) * sliceSize.width, y: CGFloat(row) * sliceSize.height)
                sliceSize.width = min(sliceSize.width, size.width - origin.x)
                sliceSize.height = min(sliceSize.height, size.height - origin.y)

                guard let cropped = cgImage?.cropping(to: CGRect(origin: origin, size: sliceSize)) else {
                    return []
                }
                images.append(UIImage(cgImage: cropped))
            }
        }

        return images
    }
}
