//
//  FeedRouter.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 07/01/24.
//

import UIKit

protocol FeedRouter {

    func showCreatePost(for user: User)

}

final class DefaultFeedRouter: FeedRouter {

    weak var viewController: UIViewController?

    func showCreatePost(for user: User) {
        let createPostViewController = CreatePostViewController.build(user: user)
        viewController?.navigationController?.pushViewController(createPostViewController, animated: true)
    }

}
