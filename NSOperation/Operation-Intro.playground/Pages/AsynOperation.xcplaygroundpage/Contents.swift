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

// eg 1 Concrete subclass of AsyncOperation that defines Main


// Step 1 Defining an Async Add Func
func asyncAdd(lhs: Int, rhs: Int, callback:@escaping (Int) -> Void) {
    OperationQueue().addOperation {
        sleep(2)
        let returnVal = lhs + rhs;
        callback(returnVal);
    }
}

// Step 2 Now making an async operation which invokes the asyncAdd func

class AsyncAddOperation: AsyncOperation {
    private var lhs:Int;
    private var rhs:Int;
    public var result:Int?;
    
    init(lhs: Int, rhs: Int) {
        self.lhs = lhs;
        self.rhs = rhs;
        super.init()
    }
    
    override func main() {
        asyncAdd(lhs: lhs, rhs: rhs) { (result) in
            self.result = result;
            self.state = .Finished;
        }
    }
}

// Step 3 Invoke the asyncAddOperation
let asyncAddQueue = OperationQueue();
let elementsToBeAdded = [(2,3), (3,4), (4,5)];

for element in elementsToBeAdded {
    let addOperation = AsyncAddOperation(lhs: element.0, rhs: element.1);
    addOperation.completionBlock = {
        print(" Result is \(addOperation.result)");
    }
    asyncAddQueue.addOperation(addOperation);
}

asyncAddQueue.waitUntilAllOperationsAreFinished()

// eg 2 Concrete subclass of AsyncOperation that defines Main

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
