//
//  User.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 07/01/24.
//

import UIKit

struct User: Codable {
    let id: String
    let username: String
    let usertag: String
    let profileImageData: Data
    let profileImage: UIImage?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case usertag
        case profileImageData
    }

    init(id: String, username: String, usertag: String, profileImage: UIImage? = UIImage(systemName: "person.crop.circle.fill")) {
        self.id = id
        self.username = username
        self.usertag = usertag
        self.profileImage = profileImage
        self.profileImageData = profileImage?.pngData() ?? Data()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.usertag = try container.decode(String.self, forKey: .usertag)
        self.profileImageData = try container.decode(Data.self, forKey: .profileImageData)
        self.profileImage = UIImage(data: profileImageData) ?? UIImage()
    }
}
