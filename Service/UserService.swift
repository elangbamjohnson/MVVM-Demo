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
    
    // MARK: - Async/Await implementation fetching real data
    func fetchUsers() async throws -> [User] {
        // Example public API with user data
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        // Decode only the fields we need and map to your local User model
        do {
            let remote = try JSONDecoder().decode([User].self, from: data)
            return remote.map { User(name: $0.name) }
        } catch {
            throw NetworkError.decodingError
        }
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
