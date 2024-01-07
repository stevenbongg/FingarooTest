//
//  Repository.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 07/01/24.
//

import Combine
import Foundation

protocol Repository {
    func postsPublisher() -> AnyPublisher<[Post], Never>
    func fetchPosts() -> [Post]
    func fetchUsers() -> [User]
    func fetchSelectedUser() -> User
    func save(users: [User])
    func save(post: Post)
    func save(selectedUser: User)
}

final class DefaultRepository: Repository {

    private let postsKey = "posts"
    private let usersKey = "users"
    private let selectedUserKey = "selectedUser"
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults()) {
        self.userDefaults = userDefaults
    }

    func postsPublisher() -> AnyPublisher<[Post], Never> {
        userDefaults
            .publisher(for: \.posts)
            .map({ (data: Data?) -> [Post] in
                guard let data = data else {
                    return []
                }
                do {
                    let posts = try PropertyListDecoder().decode([Post].self, from: data)
                    return posts
                } catch {
                    return []
                }
            })
            .eraseToAnyPublisher()
    }

    func fetchPosts() -> [Post] {
        if let data = userDefaults.data(forKey: postsKey),
           let users = try? PropertyListDecoder().decode([Post].self, from: data) {
            return users
        } else {
            return []
        }
    }

    func fetchUsers() -> [User] {
        if let data = userDefaults.data(forKey: usersKey),
           let users = try? PropertyListDecoder().decode([User].self, from: data) {
            return users
        } else {
            return []
        }
    }

    func fetchSelectedUser() -> User {
        if let data = userDefaults.data(forKey: selectedUserKey),
           let user = try? jsonDecoder.decode(User.self, from: data) {
            return user
        } else {
            let users = fetchUsers()
            let firstUser = users.first!
            save(selectedUser: firstUser)
            return firstUser
        }
    }

    func save(users: [User]) {
        if let data = try? PropertyListEncoder().encode(users) {
            userDefaults.setValue(data, forKey: usersKey)
         }
    }

    func save(post: Post) {
        var posts = fetchPosts()
        posts.insert(post, at: 0)
        if let data = try? PropertyListEncoder().encode(posts) {
            userDefaults.setValue(data, forKey: postsKey)
         }
    }

    func save(selectedUser: User) {
        if let data = try? jsonEncoder.encode(selectedUser) {
            userDefaults.setValue(data, forKey: selectedUserKey)
        }
    }

}
