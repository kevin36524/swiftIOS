//
//  ImageFilterOperation.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/6/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import Foundation
import UIKit

protocol ImageFilterDataProvider {
    var image:UIImage? {get}
}

class ImageFilterOperation: Operation {
    var filterOutput: UIImage?
    private let _filterInput: UIImage?
    
    init(inputImage: UIImage?) {
        _filterInput = inputImage;
        super.init()
    }
    
    var filterInput: UIImage? {
        
        if let inputImage = _filterInput {
            return inputImage;
        }
        
        if let dataProvider = dependencies
            .filter({ $0 is ImageFilterDataProvider})
            .first as? ImageFilterDataProvider {
            return dataProvider.image
        }
        
        return nil;
    }
}

extension ImageFilterOperation: ImageFilterDataProvider {
    var image:UIImage? {
        return filterOutput
    }
}
