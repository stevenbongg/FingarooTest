//
//  FeedView.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 06/01/24.
//

import Foundation

protocol FeedView: AnyObject {
    func onPostsUpdated()
    func onUsersUpdated()
    func onSelectedUserUpdated(at row: Int)
}

