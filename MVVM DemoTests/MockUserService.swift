//
//  MockUserService.swift
//  MVVM Demo
//
//  Created by Johnson on 01/04/26.
//

import Foundation
@testable import MVVM_Demo

class MockUserService: UserServiceProtocol {
    var fetchUsersCalled = false
    
    var usersToReturn :[User] = [
        User(name: "Test1"),
        User(name: "Test2")
    ]
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        fetchUsersCalled = true
        completion(usersToReturn)
    }
}
