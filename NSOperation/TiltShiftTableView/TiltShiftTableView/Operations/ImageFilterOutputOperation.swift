//
//  ImageFilterOutputOperation.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/7/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import UIKit

class ImageFilterOutputOperation: ImageFilterOperation {
    private let completion: ((UIImage?) -> Void)?
    
    init(completion: ((UIImage?) -> Void)? ) {
        self.completion = completion
        super.init(inputImage: nil)
    }
    
    override func main() {
        completion?(filterInput)
    }
}
