import Foundation
import Combine

@MainActor
final class UserRepository: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var isRefreshing: Bool = false
    @Published var errorMessage: String? = nil

    private let service: UserServiceProtocol
    private let storage: UserStorageProtocol

    init(service: UserServiceProtocol, storage: UserStorageProtocol) {
        self.service = service
        self.storage = storage
    }

    func load() async {
        errorMessage = nil
        
        do {
            let cached = try storage.loadUsers()
            if !cached.isEmpty {
                self.users = cached
            }
        } catch {
            print("Storage load error: \(error.localizedDescription)")
        }

        isRefreshing = true
        defer { isRefreshing = false }
        
        do {
            let fresh = try await service.fetchUsers()
            if fresh.isEmpty {
                self.errorMessage = "No users found."
            } else {
                try storage.saveUsers(fresh)
                self.users = fresh
                self.errorMessage = nil
            }
        } catch {
            self.errorMessage = "Failed to fetch users: \(error.localizedDescription)"
        }
    }
}
