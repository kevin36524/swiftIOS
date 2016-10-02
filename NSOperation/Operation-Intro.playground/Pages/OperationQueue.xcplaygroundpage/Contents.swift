import UIKit
import XCPlayground

//: # OperationQueue
//: ## Creating a queue
//: Operations can be added to queue directly
let printerQueue = OperationQueue()
printerQueue.maxConcurrentOperationCount = 2
startClock()
printerQueue.addOperation { sleep(2); print("This"); }
printerQueue.addOperation { sleep(2); print("is"); }
printerQueue.addOperation { sleep(2); print("an"); }
printerQueue.addOperation { sleep(2); print("example"); }
printerQueue.addOperation { sleep(2); print("of"); }
printerQueue.addOperation { sleep(2); print("operation"); }
printerQueue.addOperation { sleep(2); print("queue"); }
stopClock()

startClock()
printerQueue.waitUntilAllOperationsAreFinished()
stopClock()

//: ## Adding Operations to queues
let images = ["city", "dark_road", "train_day", "train_dusk", "train_night"].map { UIImage.init(named: "\($0).jpg") }
var filteredImages = [UIImage]()

//: Create the queue with the default constructor
let filterQueue = OperationQueue()
//: Create a serial queue to handle addtions to the array
let appendQueue = OperationQueue()
appendQueue.maxConcurrentOperationCount = 1
//: Create a filter operations for each of the images, adding a completion block
for image in images {
    let filterOp = TiltShiftOperation()
    filterOp.inputImage = image
    filterOp.completionBlock = {
        guard let output = filterOp.outputImage else {
            return
        }
        // filteredImages should not be modified from multiple threads
        appendQueue.addOperation({ 
            filteredImages.append(output);
        })
    }
    filterQueue.addOperation(filterOp);
}

filterQueue.waitUntilAllOperationsAreFinished()

filteredImages;
//: Eg-2 Creating filterOperation Queue for decompression
let inputPaths = ["01", "02", "03", "04", "05"].map {
    Bundle.main.path(forResource: "sample_\($0)_small", ofType: "compressed")
}

let decompressionQueue = OperationQueue()

let outputSerialQueue = OperationQueue()
outputSerialQueue.maxConcurrentOperationCount = 1

var decompressedImages = [UIImage]()

for inputPath in inputPaths {
    let decompressionOp = ImageDecompressorOperation()
    decompressionOp.inputImagePath = inputPath;
    decompressionOp.completionBlock = {
        if let outputImage = decompressionOp.outputImage {
            outputSerialQueue.addOperation({ 
                decompressedImages.append(outputImage)
            })
        }
    }
    decompressionQueue.addOperation(decompressionOp)
}

decompressionQueue.waitUntilAllOperationsAreFinished()

decompressedImages;
