//
//  NSOperationExtension.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/8/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import Foundation

infix operator |> { associativity left }
func |>(lhs: Operation, rhs: Operation) {
    rhs.addDependency(lhs)
}
