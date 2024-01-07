//
//  FeedsTest.swift
//  FingarooTestUIKitAppTests
//
//  Created by Steven Bong on 07/01/24.
//

import XCTest
@testable import FingarooTestUIKitApp

final class FeedsTest: XCTestCase {

    private var userDefaults: UserDefaults!
    private var repository: Repository!
    private var mockRouter: FeedMockRouter!
    private var interactor: FeedInteractor!
    private var sut: FeedDefaultPresenter!
    private var mockView: FeedMockView!

    override func setUp() {
        userDefaults = UserDefaults(suiteName: "Mock")!
        repository = DefaultRepository(userDefaults: userDefaults)
        mockRouter = FeedMockRouter()
        interactor = FeedDefaultInteractor(repository: repository)
        sut = FeedDefaultPresenter(interactor: interactor, router: mockRouter)
        mockView = FeedMockView()
        interactor.output = sut
        sut.view = mockView
        populateMockUsers()
    }

    override func tearDownWithError() throws {
        userDefaults.removePersistentDomain(forName: "Mock")
        userDefaults = nil
        repository = nil
        mockRouter = nil
        interactor = nil
        mockView = nil
        sut = nil
    }

    func testCreatePostWithUser1() throws {
        sut.onViewDidLoad()
        sut.onUserSelected(at: 0)
        sut.onCreatePostTapped()

        let user = try XCTUnwrap(mockRouter.user)
        XCTAssertEqual(user.username, "User1")
        XCTAssertTrue(mockRouter.isShowingCreatePost)

        XCTAssertTrue(mockView.isPostUpdatedCalled)
    }

    func testCreatePostWithUser2() throws {
        sut.onViewDidLoad()
        sut.onUserSelected(at: 1)
        sut.onCreatePostTapped()

        let user = try XCTUnwrap(mockRouter.user)
        XCTAssertEqual(user.username, "User2")
        XCTAssertTrue(mockRouter.isShowingCreatePost)

        XCTAssertTrue(mockView.isPostUpdatedCalled)
    }

    func testRouterMemoryLeak() {
        let router = DefaultFeedRouter()
        addTeardownBlock { [weak router] in
            XCTAssertNil(router)
        }
    }

    func testInteractorMemoryLeak() {
        let interactor = FeedDefaultInteractor()
        addTeardownBlock { [weak interactor] in
            XCTAssertNil(interactor)
        }
    }

    func testPresenterMemoryLeak() {
        let router = DefaultFeedRouter()
        let interactor = FeedDefaultInteractor()
        let presenter = FeedDefaultPresenter(interactor: interactor, router: router)

        addTeardownBlock { [weak presenter] in
            XCTAssertNil(presenter)
        }
    }

    private func populateMockUsers() {
        let mockUsers = [
            User(
                id: UUID().uuidString,
                username: "User1",
                usertag: "@User1",
                profileImage: UIImage(systemName: "person.crop.circle.fill")
            ),
            User(
                id: UUID().uuidString,
                username: "User2",
                usertag: "@User2",
                profileImage: UIImage(systemName: "person.crop.circle.fill")
            ),
            User(
                id: UUID().uuidString,
                username: "User3",
                usertag: "@User3",
                profileImage: UIImage(systemName: "person.crop.circle.fill")
            )
        ]
        repository.save(users: mockUsers)
    }

}

final class FeedMockRouter: FeedRouter {

    var isShowingCreatePost: Bool = false
    var user: User?

    func showCreatePost(for user: User) {
        self.isShowingCreatePost = true
        self.user = user
    }

}

final class FeedMockView: FeedView {

    var isPostUpdatedCalled: Bool = false
    var isUsersUpdatedCalled: Bool = false
    var isSelectedUserUpdatedCalled: Bool = false

    func onPostsUpdated() {
        isPostUpdatedCalled = true
    }
    
    func onUsersUpdated() {
        isUsersUpdatedCalled = true
    }
    
    func onSelectedUserUpdated(at row: Int) {
        isSelectedUserUpdatedCalled = true
    }

}
