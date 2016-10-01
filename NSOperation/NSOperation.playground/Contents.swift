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

//: BlockOperations can have multiple blocks, that run concurrently.
//: Cannot guarantee the order in which the operations will be executed.
//: Number of concurrent blocks that can be executed depends on the number of available threads.
//: Add some more blocks and observe the time taken.

let multiPrinter = BlockOperation()
multiPrinter.addExecutionBlock { print ("All"); sleep(5);}
multiPrinter.addExecutionBlock { print ("these"); sleep(5);}
multiPrinter.addExecutionBlock { print ("blocks"); sleep(5);}
multiPrinter.addExecutionBlock { print ("will"); sleep(5);}
multiPrinter.addExecutionBlock { print ("run"); sleep(5);}
multiPrinter.addExecutionBlock { print ("concurrently"); sleep(5);}

startClock()
multiPrinter.start()
stopClock()

//: ## Subclassing Operation -- Create your own Operation
