import Foundation
import Combine


protocol UserServiceProtocol {
    func fetchUsers(completion: @escaping ([User]) -> Void)
}


//final class: This means the class cannot be subclassed. It's a performance optimization and a way to clearly signal that this class is not meant to be inherited from.
final class UserService : UserServiceProtocol {

//    This is a completion handler (callback).
//    It takes an array of User objects as input and returns nothing (Void).
//    @escaping is required because the closure will be stored and called later (after the function returns), not immediately.
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        
//        DispatchQueue.global(): Gets a background (global) concurrent queue. This is where heavy or long-running work should happen so it doesn't block the main thread.
//    asyncAfter(deadline: .now() + 1): Delays the execution by 1 second.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            
            let users = [
                User(name: "John"),
                User(name: "Emma"),
                User(name: "Michael"),
                User(name: "Sophia"),
                User(name: "Daniel")
            ]
//            Switches back to the main thread (UI thread).
            DispatchQueue.main.sync {
                completion(users)
            }
        }
    }
}
