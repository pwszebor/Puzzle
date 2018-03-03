//
//  ArrayExtension.swift
//  Puzzle
//
//  Created by Pawel Wszeborowski on 29/12/2017.
//  Copyright © 2017 Pawel Wszeborowski. All rights reserved.
//

import Foundation

extension Array {
    func orderedRandomly() -> Array {
        if count < 2 {
            return self
        }
        var orderedRandomly = self
        for i in stride(from: count - 1, through: 1, by: -1) {
            let j = Int(arc4random_uniform(UInt32(i.advanced(by: 1))))
            if i != j {
                orderedRandomly.swapAt(i, j)
            }
        }
        return orderedRandomly
    }
}
