import Foundation
import Combine

//final class: Same as before — prevents subclassing for better performance and clarity.
final class UserViewModel {
    
    //Creates a private instance of UserService.
    private let service : UserServiceProtocol
    
    //Inject service
    init(service: UserServiceProtocol) {
        self.service = service
    }
    
    
//        didSet: This is a property observer
//        Every time users is assigned a new value, didSet automatically runs.
//        It calls reloadTableView?() to tell the View: “Hey, the data has changed, please refresh the table!”
//        This is a very common and clean way to notify the UI in MVVM without using delegates or notifications.
    var users: [User] = [] {
        didSet {
            self.reloadTableView?()
        }
    }
    
    
//    This is a closure property (callback).
//    The View (ViewController) will assign its own function here.
//    When the ViewModel wants the table to reload, it calls this closure.
//    It's optional (?) because it may not be set yet.
    var reloadTableView: (() -> Void)?
    
    
//    Calls the fetchUsers() method from UserService.
//    Uses a completion handler to get the result.
//    [weak self]: This is a capture list to prevent retain cycles (memory leaks).
//    It captures self weakly so the ViewModel doesn't strongly hold the closure.
//    When data comes back, it assigns it to self?.users.
//    Because of didSet on users, reloadTableView?() will automatically be called.
    func fetchUsers() {
        Task { [weak self] in
            do {
                let users = try await self?.service.fetchUsers() ?? []
                await MainActor.run {
                    self?.users = users
                }
            } catch {
                // You can surface errors via another callback if needed
                // For now, keep previous behavior and avoid crashing on failure
            }
        }
    }
    
//    Returns how many rows the table should show.
    func numberOfRows() -> Int {
        return users.count
    }
    
//    Returns the name of the user at a specific row (safe to call from the View).
    func userName(at index: Int) -> String {
        return users[index].name
    }
    
}
