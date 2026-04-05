import Foundation
import Combine

//final class: Same as before — prevents subclassing for better performance and clarity.
@MainActor
final class UserViewModel {
    
    //Creates a private instance of UserRepository.
    private let repository : UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    //Inject repository
    init(repository: UserRepository) {
        self.repository = repository
        setupBindings()
    }
    
    private func setupBindings() {
        // Bind repository's users to our local users array
        repository.$users
            .sink { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
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
    
    
    //    Calls the fetchUsers() method from UserRepository.
    //    [weak self]: This is a capture list to prevent retain cycles (memory leaks).
    //    It captures self weakly so the ViewModel doesn't strongly hold the closure.
    //    When data comes back, it assigns it to self?.users.
    //    Because of didSet on users, reloadTableView?() will automatically be called.
    func fetchUsers() {
        Task {
            await repository.load()
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
