import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

// ##Default Global Queue with QOS
let queue = DispatchQueue.global(qos: .userInitiated)

// ##Main Queue
let mainQueue = DispatchQueue.main

// ##Creating your own Concurrent Queue
let concurrentQueue = DispatchQueue(label: "com.yahoo.test.concurrent", attributes: DispatchQueue.Attributes.concurrent)
let workerQueue = DispatchQueue(label: "com.yahoo.test.serialWorkerQueue")

func getCurrentQueueName() -> String? {
    return String(validatingUTF8: __dispatch_queue_get_label(nil))
}


//: ## Dispatching work asynchronously
//: Send some work off to be done, and then continue on—don't await a result
print("=== Sending asynchronously to Worker Queue ===")
workerQueue.async {
    print("=== ASYNC:: Executing on \(getCurrentQueueName()) ===")
}
print("=== Completed sending asynchronously to worker queue ===\n")

//: ## Dispatching work synchronously
//: Send some work off and wait for it to complete before continuing (here be more dragons)
print("=== Sending SYNChronously to Worker Queue ===")
workerQueue.sync {
    print("=== SYNC:: Executing on \(getCurrentQueueName()) ===")
}
print("=== Completed sending synchronously to worker queue ===\n")


//: ## Concurrent and serial queues
//: Serial allows one job to be worked on at a time, concurrent multitple
func doComplexWork() {
    sleep(1)
    print("\(stopClock()) :: \(getCurrentQueueName()) :: Done!")
}

startClock()
print("==== Starting Serial Queue ====")
workerQueue.async(execute: doComplexWork)
workerQueue.async(execute: doComplexWork)
workerQueue.async(execute: doComplexWork)
workerQueue.async(execute: doComplexWork)
workerQueue.async(execute: doComplexWork)

sleep(6)

print("==== Starting Concurrent Queue ====")
concurrentQueue.async(execute: doComplexWork)
concurrentQueue.async(execute: doComplexWork)
concurrentQueue.async(execute: doComplexWork)
concurrentQueue.async(execute: doComplexWork)
concurrentQueue.async(execute: doComplexWork)

sleep(2)

func slowSum (input:(Int, Int)) -> Int {
    sleep(1)
    return input.0 + input.1
}

print("=======\(stopClock()): Starting Slow Sum =======")
let result = slowSum(input: (1, 2))
print("=======\(stopClock()): Done Slow Sum \(result) =======")

func asyncSum(input:(Int, Int), completionQueue:DispatchQueue, completion: @escaping ((Int) -> Void)) {
    workerQueue.async {
        let output = slowSum(input: input)
        completionQueue.async {
            completion(output)
        }
    }
}

print("=====\(stopClock()): Starting SlowSum Async =====")
asyncSum(input: (3, 4), completionQueue: DispatchQueue.main) { (output) in
    print("\(stopClock()): Output result is \(output)")
}
print("=====\(stopClock()): Done SlowSum Async =====")



