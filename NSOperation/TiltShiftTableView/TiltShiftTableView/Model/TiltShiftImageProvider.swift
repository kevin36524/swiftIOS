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
    
    private let operationQueue = OperationQueue()
    public let tiltShiftImage: TiltShiftImage
    
    init(tiltImage: TiltShiftImage, completion:((UIImage?) -> Void)?) {
        self.tiltShiftImage = tiltImage
        let url = Bundle.main.url(forResource: tiltImage.imageName, withExtension: "compressed")
        
        let dataLoad = DataLoadOperation(url: url, completion: nil)
        let imageDecompress = ImageDecompressionOperaration(data: nil, completion: nil)
        let tiltShift = TiltShiftOperation(inputImage: nil)
        let filterOutput = ImageFilterOutputOperation(completion: completion)
        
        dataLoad |> imageDecompress 
        imageDecompress |> tiltShift
        tiltShift |> filterOutput
        
        operationQueue.addOperations([dataLoad, imageDecompress, tiltShift, filterOutput], waitUntilFinished: false)
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
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
