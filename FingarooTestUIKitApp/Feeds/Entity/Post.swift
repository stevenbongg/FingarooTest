//
//  Feed.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 06/01/24.
//

import UIKit

struct Post: Codable {
    let user: User
    let contentImageData: Data?
    let postContent: String
    let contentImage: UIImage?

    enum CodingKeys: String, CodingKey {
        case user
        case contentImageData
        case postContent
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user = try container.decode(User.self, forKey: .user)
        self.contentImageData = try container.decodeIfPresent(Data.self, forKey: .contentImageData)
        self.postContent = try container.decode(String.self, forKey: .postContent)

        if let contentImageData = self.contentImageData, let contentImage = UIImage(data: contentImageData) {
            self.contentImage = contentImage
        } else {
            self.contentImage = nil
        }
    }

    init(user: User, postContent: String, contentImage: UIImage?) {
        self.user = user
        self.postContent = postContent
        self.contentImage = contentImage

        if let contentImage = contentImage {
            self.contentImageData = contentImage.pngData()
        } else {
            self.contentImageData = nil
        }
    }
}
