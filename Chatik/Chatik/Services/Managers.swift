//
//  OperationManager.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 23.03.2022.
//

import UIKit

class GCDManager {
    
    static func save(userName: String, userInfo: String, userProfileImage: UIImage, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            MainFileManager.saveUserProfile(userName: userName, userInfo: userInfo, userProfileImage: userProfileImage)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    static func load(completion: @escaping ((userName: String, userInfo: String, userProfileImage: UIImage)?) -> Void) {
        DispatchQueue.main.async {
            completion(MainFileManager.loadUserProfile())
        }
    }
}

func loader() {
    _ = OperationLoader()
}
    
class OperationSaver: AsyncOperation {
    
    let userName: String
    let userInfo: String
    let userProfileImage: UIImage
        
    init(userName: String, userInfo: String, userProfileImage: UIImage) {
        self.userName = userName
        self.userInfo = userInfo
        self.userProfileImage = userProfileImage
    }
    
    override func main() {
        MainFileManager.saveUserProfile(userName: userName, userInfo: userInfo, userProfileImage: userProfileImage)
        state = .finished
    }
}

class OperationLoader: AsyncOperation {
    
    var userProfile: (userName: String, userInfo: String, userProfileImage: UIImage)?
    
    override func main() {
        userProfile = MainFileManager.loadUserProfile()
        state = .finished
    }
}

class AsyncOperation: Operation {
    
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    
    override func cancel() {
        super.cancel()
        state = .finished
    }
}
