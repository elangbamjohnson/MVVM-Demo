import Foundation

protocol UserStorageProtocol {
    func loadUsers() throws -> [User]
    func saveUsers(_ users: [User]) throws
}
