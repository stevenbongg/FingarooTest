//
//  FeedInteractor.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 06/01/24.
//

import Combine
import Foundation

protocol FeedInteractor {
    var output: FeedInteractorOutput? { get set }
    func subscribePostList()
    func fetchUsers()
    func fetchSelectedUser()
    func onUserSelected(_ user: User)
}

protocol FeedInteractorOutput: AnyObject {
    func onPostsUpdated(_ posts: [Post])
    func onUsersFetched(_ users: [User])
    func onSelectedUserUpdated(_ selectedUser: User)
}

final class FeedDefaultInteractor: FeedInteractor {

    weak var output: FeedInteractorOutput?

    private var anyCancellables = Set<AnyCancellable>()

    private let repository: Repository

    init(repository: Repository = DefaultRepository()) {
        self.repository = repository
    }

    func subscribePostList() {
        repository.postsPublisher()
            .sink(receiveValue: { [weak self] (posts: [Post]) in
                self?.output?.onPostsUpdated(posts)
            })
            .store(in: &anyCancellables)
    }

    func fetchUsers() {
        let users = repository.fetchUsers()
        output?.onUsersFetched(users)
    }

    func fetchSelectedUser() {
        output?.onSelectedUserUpdated(repository.fetchSelectedUser())
    }

    func onUserSelected(_ user: User) {
        repository.save(selectedUser: user)
        output?.onSelectedUserUpdated(user)
    }

}
