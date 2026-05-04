import Foundation
import Combine

@MainActor
final class UserViewModel: ObservableObject {
    
    enum LoadingState {
        case idle
        case loading
        case refreshing
    }
    
    @Published private(set) var users: [User] = []
    @Published private(set) var state: LoadingState = .idle
    @Published private(set) var errorMessage: String? = nil
    @Published var favoriteNames: Set<String> = [] // Local mirror of repository favorites
    
    private let repository : UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: UserRepository) {
        self.repository = repository
        setupBindings()
    }
    
    private func setupBindings() {
        repository.$users
            .assign(to: &$users)
            
        repository.$isRefreshing
            .sink { [weak self] isRefreshingFromNetwork in
                guard let self = self else { return }
                if isRefreshingFromNetwork {
                    self.state = self.users.isEmpty ? .loading : .refreshing
                } else {
                    self.state = .idle
                }
            }
            .store(in: &cancellables)

        repository.$errorMessage
            .assign(to: &$errorMessage)

        repository.$favorites
            .assign(to: &$favoriteNames)
    }
    
    func fetchUsers() {
        Task {
            await repository.load()
        }
    }
    
    func toggleFavorite(for user: User) {
        repository.toggleFavorite(userName: user.name)
    }
    
    func isFavorite(_ user: User) -> Bool {
        favoriteNames.contains(user.name)
    }
}
