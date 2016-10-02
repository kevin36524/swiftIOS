import UIKit
import XCPlayground

//: # Asynchronous Operation
//: ## Till now all the task in main() were sync
//:  ###eg: uncompressData(atPath:path)
//:  ###eg: applyFilter(toImage:image)
//: ## Now if we want to do some async task like fetch from Network
//:      eg: main() {fetchURL(url){// completeionHandler} }
//:      if we use normal opeartions then the control will go to next line soon
//: and the operation will be marked as finished.
//: hence we need to create an Operation subclass which will manage the state

// Create the class and declare all the states
// add KVO
class AsyncOperation: Operation {
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
    override var isReady: Bool {
        return super.isReady && state == .Ready
    }
    
    override var isExecuting: Bool {
        return state == .Executing
    }
    
    override var isFinished: Bool {
        return state == .Finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .Finished
        }
        
        main()
        state = .Executing
    }
    
    
    override func cancel() {
        state = .Finished
    }
}

// Concrete subclass of AsyncOperation that defines Main

class DataOperation: AsyncOperation {
    private let url: URL
    var loadedData: Data?
    
    init(urlPath: String) {
        self.url = URL(fileURLWithPath: urlPath)
        super.init()
    }
    
    override func main() {
        NetworkSimulator.asyncLoadDataAtURL(url: url) {
            (data) in
            self.loadedData = data;
            self.state = .Finished
        }
    }
}

let imageURLPath = Bundle.main.path(forResource: "city", ofType: "jpg")
let queue = OperationQueue()

let loadOperation = DataOperation(urlPath: imageURLPath!)
queue.addOperation(loadOperation)

queue.waitUntilAllOperationsAreFinished()

if let readData = loadOperation.loadedData {
    UIImage(data: readData);
}