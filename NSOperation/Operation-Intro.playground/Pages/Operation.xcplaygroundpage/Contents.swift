//: Playground - noun: a place where people can play

import UIKit
import Compressor

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
let inputImage = UIImage(named: "dark_road_small.jpg")

class TiltShiftOperation : Operation {
    var inputImage: UIImage?
    var outputImage: UIImage?
    
    override func main() {
        guard let inputImage = inputImage else {
            return
        }
        
        let mask = topAndBottomGradient(size: inputImage.size)
        outputImage = inputImage.applyBlurWithRadius(blurRadius: 4, maskImage: mask)
    }
}

let tsOp = TiltShiftOperation()
tsOp.inputImage = inputImage

startClock()
tsOp.start()
stopClock()

tsOp.outputImage



//: ## Subclassing Operation -- example 2

let compressedFilePath = Bundle.main.path(forResource: "dark_road_small", ofType: "compressed")

class DecompressOperation: Operation {
    var inputPath: String?
    var outputImage: UIImage?
    
    override func main() {
        guard let inputPath = inputPath else {
            return
        }
        
        if let decompressedData = Compressor.loadCompressedFile(inputPath) {
            outputImage = UIImage(data: decompressedData)
        }
    }
}

let commpressionOperation = DecompressOperation()
commpressionOperation.inputPath = compressedFilePath
startClock()
commpressionOperation.start()
stopClock()

commpressionOperation.outputImage


