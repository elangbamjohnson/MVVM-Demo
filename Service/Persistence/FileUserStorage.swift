import Foundation

/// A simple JSON file-based storage for caching users.
final class FileUserStorage: UserStorageProtocol {
    private let fileURL: URL
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init(filename: String = "users.json") {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.fileURL = dir.appendingPathComponent(filename)
        encoder.outputFormatting = [.prettyPrinted]
    }

    func loadUsers() throws -> [User] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        let dtos = try decoder.decode([UserDTO].self, from: data)
        return dtos.map { $0.asUser }
    }

    func saveUsers(_ users: [User]) throws {
        let dtos = users.map { UserDTO(from: $0) }
        let data = try encoder.encode(dtos)
        try data.write(to: fileURL)
    }
}

// MARK: - DTO used only for persistence
private struct UserDTO: Codable {
    let name: String

    init(from user: User) {
        self.name = user.name
    }

    var asUser: User { User(name: name) }
}
