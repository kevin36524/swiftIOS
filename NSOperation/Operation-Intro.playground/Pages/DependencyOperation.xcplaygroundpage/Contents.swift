import Compressor
import UIKit

let compressedImagePaths = ["01", "02", "03", "04", "05"].map {
    Bundle.main.path(forResource: "sample_\($0)_small", ofType: "compressed")
}

var tiltShiftedImages = [UIImage]()

let queue = OperationQueue()
let appendQueue = OperationQueue()
appendQueue.maxConcurrentOperationCount = 1


for path in compressedImagePaths {
    guard let inputURLPath = path else {continue}
    
    let inputURL = URL(fileURLWithPath: inputURLPath)
    
    let dataFetchAsyncOperation = DataFetchAsyncOperation(urlPath: inputURLPath);
    
    let imageDecompressionDataOperation = ImageDecompressionDataOperation();
    
    let tiltShiftDependencyOperation = TiltShiftDependencyOperation();
    tiltShiftDependencyOperation.completionBlock = {
        guard let outputImage = tiltShiftDependencyOperation.outputImage else { return }
        appendQueue.addOperation {
            tiltShiftedImages.append(outputImage)
        }
    }
    
    (dataFetchAsyncOperation |> imageDecompressionDataOperation) |> tiltShiftDependencyOperation
    
    queue.addOperations([dataFetchAsyncOperation, imageDecompressionDataOperation, tiltShiftDependencyOperation], waitUntilFinished: false)
    
}

queue.waitUntilAllOperationsAreFinished()

tiltShiftedImages;
