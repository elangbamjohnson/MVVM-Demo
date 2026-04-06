import Foundation

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
    @available(*, deprecated, message: "Use async/await version")
    func fetchUsers(completion: @escaping ([User]) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

final class UserService: UserServiceProtocol {
    private let network: NetworkManagerProtocol
    private let storage: UserStorageProtocol

    init(network: NetworkManagerProtocol = NetworkManager(), storage: UserStorageProtocol = FileUserStorage()) {
        self.network = network
        self.storage = storage
    }
    
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let remote = try await network.request(request, decode: [User].self)
        let users = remote.map { User(name: $0.name) }
        try? storage.saveUsers(users)
        return users
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        Task {
            do {
                let users = try await fetchUsers()
                await MainActor.run { completion(users) }
            } catch {
                await MainActor.run { completion([]) }
            }
        }
    }
}
