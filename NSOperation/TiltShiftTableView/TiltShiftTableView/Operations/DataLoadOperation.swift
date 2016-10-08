//
//  DataLoadOperation.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/7/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import Foundation

class DataLoadOperation: AsyncOperation {
    private let url: URL
    private let completion:((Data?) -> Void)?
    public var loadedData: Data?
    
    init(url: URL, completion:((Data?) -> Void)?) {
        self.url = url
        self.completion = completion
    }
    
    override func main() {
        
    }
}
