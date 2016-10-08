//
//  DataLoadOperation.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/7/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import Foundation

class DataLoadOperation: AsyncOperation {
    private let url: URL?
    private let completion:((Data?) -> Void)?
    public var loadedData: Data?
    
    init(url: URL?, completion:((Data?) -> Void)?) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func main() {
        NetworkSimulator.asyncLoadData(AtUrl: url) { (data) in
            self.loadedData = data
            self.completion?(self.loadedData)
            self.state = .Finished
        }
    }
}

extension DataLoadOperation: ImageDecompressionOperationDataProvider {
    var inputData: Data? {
        return self.loadedData
    }
}
