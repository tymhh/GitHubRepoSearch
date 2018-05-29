import Foundation

class GroupOperation: AsyncOperation {
    let queue = OperationQueue()
    var operations: [AsyncOperation] = []
    
    override func execute() {
        queue.addOperations(operations, waitUntilFinished: true)
    }
}

class ThreadManager: GroupOperation {
    init(resourse: String?, code: @escaping (_ resourse: Any?) -> ()) {
        super.init()
        let op = LoadOperation(resourse: resourse) { value in
            code(value)
        }
        let op2 = LoadOperation(resourse: resourse) { value in
            code(value)
        }
        
        let adapter = BlockOperation() { [unowned op, unowned op2] in
            op2.resourse = op.resourse
        }
        
        adapter.addDependency(op)
        op2.addDependency(adapter)
        
        operations = [op, op2, adapter] as! [AsyncOperation]
    }
}

class LoadOperation: AsyncOperation {
    let code: (Any?) -> ()
    var resourse: Any?
    
    init(resourse: Any?, code: @escaping (Any?) -> ()) {
        self.resourse = resourse
        self.code = code
    }
    
    override func execute() {
        code(resourse)
    }
}

class AsyncOperation: Operation {
    override var isAsynchronous: Bool {
        return true
    }
    
    var _isFinished: Bool = false
    
    override var isFinished: Bool {
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
        
        get {
            return _isFinished
        }
    }
    
    var _isExecuting: Bool = false
    
    override var isExecuting: Bool {
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
        
        get {
            return _isExecuting
        }
    }
    
    func execute() {
    }
    
    override func start() {
        isExecuting = true
        execute()
        isExecuting = false
        isFinished = true
    }
}
