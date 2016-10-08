//
//  ImageDecompressionOperation.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/7/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import UIKit
import Compressor

protocol ImageDecompressionOperationDataProvider {
    var inputData: Data? {get}
}

class ImageDecompressionOperaration: Operation {
    var inputData: Data?
    var outputImage: UIImage?
    var completion: ((UIImage?) -> Void)?
    
    init(data: Data?, completion:((UIImage?) -> Void)?) {
        self.inputData = data
        self.completion = completion
    }
    
    override func main() {
        let compressedData: Data?
        
        if let inputData = inputData {
            compressedData = inputData
        } else {
            let dataProvider = self.dependencies
                .filter({$0 is ImageDecompressionOperationDataProvider })
                .first as? ImageDecompressionOperationDataProvider
            
            compressedData = dataProvider?.inputData
        }
        
        guard let data = compressedData else {
            return
        }
        
        if let decompressedData = Compressor.decompressData(inputData: data) {
            outputImage = UIImage(data: decompressedData)
        }
        
        completion?(outputImage);
    }
}

extension ImageDecompressionOperaration: ImageFilterDataProvider {
    var image: UIImage? {
        return self.outputImage
    }
}
