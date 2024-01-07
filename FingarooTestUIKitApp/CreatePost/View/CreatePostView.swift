//
//  CreatePostView.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 07/01/24.
//

import UIKit

protocol CreatePostView: AnyObject {
    func showPostContentPlaceholder()
    func hidePostContentPlaceholder()
    func showPostImage(_ image: UIImage)
    func removePostImage()
}
