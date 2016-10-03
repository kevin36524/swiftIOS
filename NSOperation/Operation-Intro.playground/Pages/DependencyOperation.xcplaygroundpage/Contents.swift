import Compressor
import UIKit

let compressedImagePaths = ["01", "02", "03", "04", "05"].map {
    Bundle.main.path(forResource: "sample_\($0)_small", ofType: "compressed")
}

var decompressedImages = [UIImage]()

let queue = OperationQueue()
let appendQueue = OperationQueue()
appendQueue.maxConcurrentOperationCount = 1


for path in compressedImagePaths {
    guard let inputURLPath = path else {continue}
    
    let inputURL = URL(fileURLWithPath: inputURLPath)
    
    let dataFetchAsyncOperation = DataFetchAsyncOperation(urlPath: inputURLPath);
    
    let imageDecompressionDataOperation = ImageDecompressionDataOperation();
    imageDecompressionDataOperation.completionBlock = {
        guard let outputImage = imageDecompressionDataOperation.outputImage else { return }
        appendQueue.addOperation {
            decompressedImages.append(outputImage)
        }
    }
    
    dataFetchAsyncOperation |> imageDecompressionDataOperation
    
    queue.addOperations([imageDecompressionDataOperation, dataFetchAsyncOperation], waitUntilFinished: false)
    
}

queue.waitUntilAllOperationsAreFinished()

decompressedImages;