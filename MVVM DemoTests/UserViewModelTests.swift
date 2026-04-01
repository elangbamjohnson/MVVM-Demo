//
//  UserViewModelTests.swift
//  MVVM Demo
//
//  Created by Johnson on 01/04/26.
//

import XCTest
//@testable import: Allows the test target to access internal elements of your main app module (MVVM_Demo).
@testable import MVVM_Demo

class UserViewModelTests: XCTestCase {
//    The object we're testing.
    var viewModel: UserViewModel!
    
//    A fake version of UserService that we control.
    var mockService: MockUserService!
    
//    setUp(): Runs before every test
    override func setUp() {
        super.setUp()
        
        mockService = MockUserService()
        
//        Creates a fresh UserViewModel and injects the mock service into it.
        viewModel = UserViewModel(service: mockService)
    }
    
//    tearDown(): Runs after every test
//    Sets objects to nil to help release memory and avoid test pollution (one test affecting another)
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
//    Test 1: Verify that fetchUsers actually calls the service
//    Purpose: Ensures the ViewModel is correctly calling the service.
    func testFetchUsersCallsService() {
        viewModel.fetchUsers()
        XCTAssertTrue(mockService.fetchUsersCalled)
    }
    
    //Test 2: Check that users array gets updated
    func testFetchUsersUpdatesUsersArray() {
        viewModel.fetchUsers()
        XCTAssertEqual(viewModel.users.count, 2)
    }
    
    //Test 3: Test the numberOfRows() helper
    func testNumberOfRowsReturnsCorrectCount() {
        viewModel.fetchUsers()
        let rows = viewModel.numberOfRows()
        XCTAssertEqual(rows, 2)
        
    }
    
    //Test 4: Test getting user name at specific index
    func testUserNameAtIndexReturnsCorrectName() {
        viewModel.fetchUsers()
        let name = viewModel.userName(at: 0)
        XCTAssertEqual(name, "Test1")
    }
    
//    Test 5 : Verify the reloadTableView closure is called
//    Purpose: Ensures the ViewModel notifies the View to reload the table when data changes.
    func testReloadTableViewClosureIsCalled() {
//        Creates an XCTestExpectation (a way to test asynchronous behavior).
        let expectation = self.expectation(description: "Reload table called")
      
//        Assigns a closure to reloadTableView.
        viewModel.reloadTableView = {
            expectation.fulfill()
        }
//        When fetchUsers() runs and didSet triggers, the closure runs → fulfill() is called.
        viewModel.fetchUsers()
        
//        waitForExpectations waits (up to 1 second) for the closure to be executed.
        waitForExpectations(timeout: 1)
    }
    
//    Test 6:Verify the actual data from the mock
    func testUserDataMatchesMockService() {
        viewModel.fetchUsers()
        
        XCTAssertEqual(viewModel.users[0].name, "Test1")
        XCTAssertEqual(viewModel.users[1].name, "Test2")
    }
}
