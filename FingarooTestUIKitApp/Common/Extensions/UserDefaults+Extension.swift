//
//  UserDefaults+Extension.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 07/01/24.
//

import Foundation

extension UserDefaults {

    @objc dynamic var posts: Data? {
        return data(forKey: "posts")
    }

    @objc dynamic var users: [Any]? {
        return array(forKey: "users")
    }

}
