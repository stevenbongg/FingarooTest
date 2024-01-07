//
//  FeedPresenter.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 06/01/24.
//

import Foundation

protocol FeedPresenter {
    var posts: [Post] { get }
    var users: [User] { get }
    func onViewDidLoad()
    func onUserSelected(at row: Int)
    func onCreatePostTapped()
}

final class FeedDefaultPresenter {

    weak var view: FeedView?

    private(set) var posts: [Post] = []
    private(set) var users: [User] = []
    private(set) var selectedUser: User?

    private let interactor: FeedInteractor
    private let router: FeedRouter

    init(interactor: FeedInteractor, router: FeedRouter) {
        self.interactor = interactor
        self.router = router
    }

}

extension FeedDefaultPresenter: FeedPresenter {

    func onViewDidLoad() {
        interactor.fetchUsers()
        interactor.fetchSelectedUser()
        interactor.subscribePostList()
    }

    func onUserSelected(at row: Int) {
        interactor.onUserSelected(users[row])
    }

    func onCreatePostTapped() {
        guard let user = selectedUser else {
            return
        }
        router.showCreatePost(for: user)
    }

}

extension FeedDefaultPresenter: FeedInteractorOutput {

    func onPostsUpdated(_ posts: [Post]) {
        self.posts = posts
        view?.onPostsUpdated()
    }

    func onUsersFetched(_ users: [User]) {
        self.users = users
        view?.onUsersUpdated()
    }

    func onSelectedUserUpdated(_ selectedUser: User) {
        self.selectedUser = selectedUser

        if let index = users.firstIndex(where: { $0.id == selectedUser.id }) {
            view?.onSelectedUserUpdated(at: index)
        }
    }

}
