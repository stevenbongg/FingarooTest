//
//  CreatePostRouter.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 07/01/24.
//

import UIKit

protocol CreatePostRouter {
    func showImagePicker(_ vc: UIViewController)
    func popToFeedsScreen()
}

final class CreatePostDefaultRouter: CreatePostRouter {

    weak var viewController: CreatePostViewController?

    func showImagePicker(_ vc: UIViewController) {
        viewController?.present(vc, animated: true)
    }

    func popToFeedsScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("DEinit")
    }

}
