import Foundation
@testable import MVVM_Demo

class MockUserStorage: UserStorageProtocol {
    var loadUsersCalled = false
    var saveUsersCalled = false
    var usersInStorage: [User] = []

    func loadUsers() throws -> [User] {
        loadUsersCalled = true
        return usersInStorage
    }

    func saveUsers(_ users: [User]) throws {
        saveUsersCalled = true
        usersInStorage = users
    }
}
