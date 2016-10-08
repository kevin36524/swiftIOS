//
//  NetworkSimulator.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/7/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import Foundation

class NetworkSimulator {
    public static func asyncLoadData(AtUrl url:URL?, completion:((_ data: Data?) -> Void)?) {
        OperationQueue().addOperation {
            let data = syncLoadData(AtUrl: url)
            completion!(data)
        }
    }
    
    public static func syncLoadData(AtUrl url:URL?) -> Data? {
        var returnData:Data? = nil;
        let waitTime = arc4random_uniform(2 * 1000000)
        usleep(waitTime)
        
        if let url = url {
            returnData = try? Data.init(contentsOf: url)
        }
        
        return returnData
    }
}
