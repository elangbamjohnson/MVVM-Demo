import Foundation

protocol UserServiceProtocol {
    // New async/await API
    func fetchUsers() async throws -> [User]

    // Temporary compatibility wrapper for older call sites
    @available(*, deprecated, message: "Use async/await version: fetchUsers() async throws -> [User]")
    func fetchUsers(completion: @escaping ([User]) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

// final class: This means the class cannot be subclassed. It's a performance optimization and a way to clearly signal that this class is not meant to be inherited from.
final class UserService: UserServiceProtocol {
    
    private let network: NetworkManagerProtocol
    private let storage: UserStorageProtocol

    init(network: NetworkManagerProtocol = NetworkManager(), storage: UserStorageProtocol = FileUserStorage()) {
        self.network = network
        self.storage = storage
    }
    
    // MARK: - Async/Await implementation fetching real data
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Decode remote users and map to local model if needed
        let remote = try await network.request(request, decode: [User].self)
        let users = remote.map { User(name: $0.name) }
        
        // Save to storage after successful fetch
        try? storage.saveUsers(users)
        
        return users
    }
    
    // MARK: - Deprecated completion-based API
    @available(*, deprecated, message: "Use async/await version: fetchUsers() async throws -> [User]")
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        Task {
            do {
                let users = try await fetchUsers()
                await MainActor.run { completion(users) }
            } catch {
                // In the legacy API we can't surface errors; return empty on failure.
                await MainActor.run { completion([]) }
            }
        }
    }
}

