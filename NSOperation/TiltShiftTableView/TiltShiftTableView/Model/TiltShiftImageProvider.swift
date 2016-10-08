//
//  TiltShiftImageProvider.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/6/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import Foundation
import UIKit
import Compressor

class TiltShiftImageProvider {
    
    let tiltShiftImage: TiltShiftImage
    
    init(tiltImage: TiltShiftImage) {
        self.tiltShiftImage = tiltImage
    }
    
    var image: UIImage? {
        let url = Bundle.main.url(forResource: tiltShiftImage.imageName, withExtension: "compressed");
        
        guard let rawData = NetworkSimulator.syncLoadData(AtUrl: url!),
            let decompressedData = Compressor.decompressData(inputData: rawData),
            let inputImage = UIImage(data: decompressedData) else { return .none }
        
        let mask = topAndBottomGradient(size: inputImage.size)
        return inputImage.applyBlurWithRadius(blurRadius: 10, maskImage: mask);
    }
}

extension TiltShiftImageProvider: Hashable {
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        return(tiltShiftImage.imageTitle + tiltShiftImage.imageName).hashValue
    }
}

func ==(lhs: TiltShiftImageProvider, rhs: TiltShiftImageProvider) -> Bool {
    return lhs.tiltShiftImage == rhs.tiltShiftImage
}
