//
//  CGPointExtension.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 06/01/2018.
//  Copyright © 2018 Pawel Wszeborowski. All rights reserved.
//

import UIKit

extension CGPoint {
    func distance(from point: CGPoint) -> CGFloat {
        let distanceX = x - point.x
        let distanceY = y - point.y
        return CGFloat(sqrt(distanceX*distanceX + distanceY*distanceY))
    }
}
