//
//  CreatePostPresenterTest.swift
//  FingarooTestUIKitAppTests
//
//  Created by Steven Bong on 07/01/24.
//

import XCTest
@testable import FingarooTestUIKitApp

final class CreatePostTest: XCTestCase {

    private var user: User!
    private var router: CreatePostDefaultRouter!
    private var userDefaults: UserDefaults!
    private var repository: DefaultRepository!
    private var interactor: CreatePostDefaultInteractor!
    private var sut: CreatePostPresenter!

    override func setUp() {
        user = User(id: "1", username: "111", usertag: "222")
        router = CreatePostDefaultRouter()
        userDefaults = UserDefaults(suiteName: "Mock")!
        repository = DefaultRepository(userDefaults: userDefaults)
        interactor = CreatePostDefaultInteractor(repository: repository)
        sut = CreatePostDefaultPresenter(user: user, interactor: interactor, router: router)
    }

    override func tearDown() {
        user = nil
        router = nil
        userDefaults.removePersistentDomain(forName: "Mock")
        userDefaults = nil
        repository = nil
        interactor = nil
        sut = nil
    }

    func testSubmitPost() throws {
        sut.onPostContentChanged(text: "Test")
        sut.onSubmitTapped()

        let posts = repository.fetchPosts()
        let firstPost = try XCTUnwrap(posts.first)
        XCTAssertEqual(firstPost.postContent, "Test")
    }

    func testSecondPostShouldBeOnTop() throws {

        sut.onPostContentChanged(text: "Post 1")
        sut.onSubmitTapped()
        sut.onPostContentChanged(text: "Post 2")
        sut.onSubmitTapped()

        let posts = repository.fetchPosts()
        let firstPost = try XCTUnwrap(posts.first)
        XCTAssertEqual(firstPost.postContent, "Post 2")
    }

    func testRouterMemoryLeak() {
        let router = CreatePostDefaultRouter()
        addTeardownBlock { [weak router] in
            XCTAssertNil(router)
        }
    }

    func testInteractorMemoryLeak() {
        let interactor = CreatePostDefaultInteractor()
        addTeardownBlock { [weak interactor] in
            XCTAssertNil(interactor)
        }
    }

    func testPresenterMemoryLeak() {
        let router = CreatePostDefaultRouter()
        let interactor = CreatePostDefaultInteractor()
        let presenter = CreatePostDefaultPresenter(user: User(id: "", username: "", usertag: ""), interactor: interactor, router: router)
        
        addTeardownBlock { [weak presenter] in
            XCTAssertNil(presenter)
        }
    }

}
