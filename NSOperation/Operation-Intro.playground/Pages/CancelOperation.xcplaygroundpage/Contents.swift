import Foundation
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

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
            if(Thread.isMainThread) {
                print("I am in MainThread")
            }
            print("\(progress) I am progressing");
            return !self.isCancelled;
        })
    }
}



let numberArray = [(1,2), (3,4), (5,6), (7,8), (9,10)]
let sumOperation = AnotherArraySumOperation(input: numberArray)
let cancelQueue = OperationQueue()
cancelQueue.qualityOfService = .background;


cancelQueue.addOperation(sumOperation)

let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//
//sleep(1.5)
//sumOperation.cancel()

DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { 
    sumOperation.cancel()
}

sumOperation.completionBlock = {
    if let outputArr = sumOperation.outputArr {
        print(outputArr);
    }
}

sumOperation.cancel()

cancelQueue.waitUntilAllOperationsAreFinished()



