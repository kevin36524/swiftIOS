import UIKit
import XCPlayground

//: # OperationQueue

//XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

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

