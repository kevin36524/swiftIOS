//
//  TiltShiftOperation.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/6/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import Foundation

class TiltShiftOperation : ImageFilterOperation {
    override func main() {
        guard let inputImage = self.filterInput else {return}
        
        let mask = topAndBottomGradient(size: inputImage.size)
        filterOutput = inputImage.applyBlurWithRadius(blurRadius: 10.0, maskImage: mask)
    }
}
