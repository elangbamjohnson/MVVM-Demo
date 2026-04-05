import Foundation
import Combine

// UserViewModel: Refactored to be an ObservableObject for SwiftUI.
@MainActor
final class UserViewModel: ObservableObject {
    
    enum LoadingState {
        case idle
        case loading
        case refreshing
    }
    
    // Observed by SwiftUI
    @Published private(set) var users: [User] = []
    @Published private(set) var state: LoadingState = .idle
    
    private let repository : UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    // Inject repository
    init(repository: UserRepository) {
        self.repository = repository
        setupBindings()
    }
    
    private func setupBindings() {
        // Bind repository's users to our local users array
        repository.$users
            .assign(to: &$users)
            
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
    
    // Calls the fetchUsers() method from UserRepository.
    func fetchUsers() {
        Task {
            await repository.load()
        }
    }
    
    // Helpers for SwiftUI View (if needed, though SwiftUI can access users directly)
    func userName(at index: Int) -> String {
        guard index < users.count else { return "" }
        return users[index].name
    }
}
