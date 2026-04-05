import Foundation
import Combine

//final class: Same as before — prevents subclassing for better performance and clarity.
@MainActor
final class UserViewModel {
    
    enum LoadingState {
        case idle
        case loading
        case refreshing
    }
    
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
            
        // Observe repository's refresh state to update our internal LoadingState
        repository.$isRefreshing
            .sink { [weak self] isRefreshingFromNetwork in
                guard let self = self else { return }
                
                if isRefreshingFromNetwork {
                    // If we have data, we're refreshing. If empty, we're loading.
                    self.state = self.users.isEmpty ? .loading : .refreshing
                } else {
                    // Network refresh finished, transition to idle
                    self.state = .idle
                }
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
    var onStateChange: ((LoadingState) -> Void)?
    
    private(set) var state: LoadingState = .idle {
        didSet {
            onStateChange?(state)
        }
    }
    
    //    Calls the fetchUsers() method from UserRepository.
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
