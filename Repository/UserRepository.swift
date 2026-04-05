import Foundation
import Combine

@MainActor
final class UserRepository: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var isRefreshing: Bool = false

    private let service: UserServiceProtocol
    private let storage: UserStorageProtocol

    init(service: UserServiceProtocol, storage: UserStorageProtocol) {
        self.service = service
        self.storage = storage
    }

    /// Load cached users immediately, then refresh from the network and update storage and UI.
    func load() async {
        // 1) Load from storage first
        do {
            let cached = try storage.loadUsers()
            self.users = cached
        } catch {
            // Optionally log the storage load error
        }

        // 2) Refresh from network in background
        isRefreshing = true
        defer { isRefreshing = false }
        
        do {
            let fresh = try await service.fetchUsers()
            // Persist
            try storage.saveUsers(fresh)
            // Publish
            self.users = fresh
        } catch {
            // Optionally log the network error
        }
    }
}
