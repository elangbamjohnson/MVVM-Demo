import Foundation
import Combine

@MainActor
final class UserRepository: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var isRefreshing: Bool = false
    @Published var errorMessage: String? = nil
    @Published var favorites: Set<String> = []

    private let service: UserServiceProtocol
    private let storage: UserStorageProtocol
    private let favoritesKey = "com.mvvm-demo.favorites"

    init(service: UserServiceProtocol, storage: UserStorageProtocol) {
        self.service = service
        self.storage = storage
        self.favorites = loadFavorites()
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

    func toggleFavorite(userName: String) {
        if favorites.contains(userName) {
            favorites.remove(userName)
        } else {
            favorites.insert(userName)
        }
        saveFavorites()
    }

    func isFavorite(userName: String) -> Bool {
        favorites.contains(userName)
    }

    private func saveFavorites() {
        let array = Array(favorites)
        UserDefaults.standard.set(array, forKey: favoritesKey)
    }

    private func loadFavorites() -> Set<String> {
        let array = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        return Set(array)
    }
}
