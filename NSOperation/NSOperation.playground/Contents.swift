//: Playground - noun: a place where people can play

import UIKit

//: # Operation
//: Operation represents a 'unit of work' and can be constructed in a few ways.
//: ## BlockOperation
//: BlockOperation allows you to create an Operation from one or more closures.

var result: Int?

//: Creating a BlockOperation to add two numbers
let summationOperation = BlockOperation { 
    result = 2 + 3;
    sleep(5);
}

startClock()
summationOperation.start()
stopClock()

result