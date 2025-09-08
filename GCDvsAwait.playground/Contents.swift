import UIKit

let start = DispatchTime.now()
//// 10000 - 2119.84 ms
//// 100000 - 측정안됨
//////GCD Concurrent
let queue = DispatchQueue(label: "my.concurrent", attributes: .concurrent)
let group = DispatchGroup()

for i in 1...10000 {
    group.enter()
    queue.async {
        _ = (0...10000).reduce(0, +)
        group.leave()
    }
}

group.notify(queue: .main) {
    let end = DispatchTime.now()
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    let timeInterval = Double(nanoTime) / 1_000_000
    print("GCD 작업 완료 시간: \(timeInterval) ms")
}

// 10000 - 131.80 ms
// 100000 -1312.00 ms
Task {
    let start = DispatchTime.now()
    
    await withTaskGroup(of: Void.self) { group in
        for _ in 1...10000 {
            group.addTask {
                _ = (0...10000).reduce(0, +)
            }
        }
        
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000
        print("async/await 작업 완료 시간: \(timeInterval) ms")
    }
}
