import UIKit
import Compressor

public class TiltShiftOperation : Operation {
    public var inputImage:UIImage?
    public var outputImage:UIImage?
    
    override public func main() {
        guard let inputImage = inputImage else {
            return;
        }
        
        let mask = topAndBottomGradient(size: inputImage.size)
        outputImage = inputImage.applyBlurWithRadius(blurRadius: 10, maskImage: mask)
    }
}

public class ImageDecompressorOperation: Operation {
    public var inputImagePath: String?
    public var outputImage: UIImage?
    
    override public func main() {
        guard let inputImagePath = inputImagePath else { return }
        
        if let decompressedData = Compressor.loadCompressedFile(inputImagePath) {
            outputImage = UIImage(data: decompressedData);
        }
    }
}


// Create the class and declare all the states
// add KVO
public class AsyncOperation: Operation {
    public enum State: String {
        case Ready, Executing, Finished
        
        public var keyPath: String {
            return "is\(rawValue)"
        }
    }
    
    public var state = State.Ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

// Manage all the states here
extension AsyncOperation {
    override public var isReady: Bool {
        return super.isReady && state == .Ready
    }
    
    override public var isExecuting: Bool {
        return state == .Executing
    }
    
    override public var isFinished: Bool {
        return state == .Finished
    }
    
    override public var isAsynchronous: Bool {
        return true
    }
    
    override public func start() {
        if isCancelled {
            state = .Finished
        }
        
        main()
        state = .Executing
    }
    
    override public func cancel() {
        state = .Finished
    }
}

public class DataFetchAsyncOperation: AsyncOperation {
    private let url: URL
    var loadedData: Data?
    
    public init(urlPath: String) {
        self.url = URL(fileURLWithPath: urlPath)
        super.init()
    }
    
    override public func main() {
        NetworkSimulator.asyncLoadDataAtURL(url: url) {
            (data) in
            self.loadedData = data;
            self.state = .Finished
        }
    }
}

protocol ImageDecompressionDataOperationDataProvider {
    var compressedData: Data? {get}
}

extension DataFetchAsyncOperation: ImageDecompressionDataOperationDataProvider {
    var compressedData: Data? {
        return self.loadedData
    }
}

public class ImageDecompressionDataOperation: Operation {
    public var inputData: Data?
    public var outputImage: UIImage?
    
    override public func main() {
        if let dependencyData = dependencies
            .filter({ $0 is ImageDecompressionDataOperationDataProvider})
            .first as? ImageDecompressionDataOperationDataProvider, inputData == .none {
            inputData = dependencyData.compressedData
        }
        
        guard let inputData = inputData else { return }
        
        if let decompressedData = Compressor.decompressData(inputData: inputData) {
            outputImage = UIImage(data: decompressedData);
        }
    }
}

protocol TiltShiftDependencyOperationDataProvider {
    var decompressedImage: UIImage? {get}
}

extension ImageDecompressionDataOperation: TiltShiftDependencyOperationDataProvider {
    var decompressedImage: UIImage? {
        return self.outputImage;
    }
}

public class TiltShiftDependencyOperation: Operation {
    public var inputImage: UIImage?
    public var outputImage: UIImage?
    
    public override func main() {
        if let dependencyOperation = dependencies
            .filter({$0 is TiltShiftDependencyOperationDataProvider})
            .first as? TiltShiftDependencyOperationDataProvider {
            inputImage = dependencyOperation.decompressedImage
        }
        
        guard let unwrappedInputImage = inputImage else {return}
        
        let mask = topAndBottomGradient(size: unwrappedInputImage.size)
        outputImage = unwrappedInputImage.applyBlurWithRadius(blurRadius: 10, maskImage: mask)
    }
}

infix operator |> { associativity left precedence 160 }
public func |> (lhs: Operation, rhs: Operation) -> Operation {
    rhs.addDependency(lhs)
    return rhs;
}


func slowAdd(input: (Int, Int)) -> Int {
    sleep(1)
    return input.0 + input.1
}

func slowAddArray(input: [(Int, Int)], progress: ((Double) -> (Bool))) -> [Int] {
    var results = [Int]()
    for pair in input {
        results.append(slowAdd(input:pair))
        if !progress(Double(results.count) / Double(input.count)) { return results }
    }
    return results
}


public class AnotherArraySumOperation: Operation {
    public var inputArr:[(Int, Int)]
    public var outputArr: [Int]?
    
    init(input: [(Int, Int)]) {
        inputArr = input
        super.init()
    }
    
    public override func main() {
        outputArr = slowAddArray(input: inputArr, progress: { progress in
            print("\(progress) I am progressing");
            return !self.isCancelled;
        })
    }
}

func testrun() {
    let numberArray = [(1,2), (3,4), (5,6), (7,8), (9,10)]
    let sumOperation = AnotherArraySumOperation(input: numberArray)
    let cancelQueue = OperationQueue()
    
    sumOperation.completionBlock = {
        if let outputArr = sumOperation.outputArr {
            print(outputArr);
        }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now()) {
        sumOperation.cancel()
    }
    
    cancelQueue.addOperation(sumOperation)
    
    
    cancelQueue.waitUntilAllOperationsAreFinished()
}

public func testFunc(closure:@escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        closure();
    }
}











