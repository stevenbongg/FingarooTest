//
//  CreatePostPresenter.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 07/01/24.
//

import PhotosUI
import UIKit

protocol CreatePostPresenter {
    func onPostContentDidBeginEditing()
    func onPostContentChanged(text: String)
    func onPostContentDidEndEditing()
    func onAddImageTapped()
    func onRemoveImageTapped()
    func onPostImageSelected(image: UIImage)
    func onPostImageRemoved()
    func onSubmitTapped()
}

final class CreatePostDefaultPresenter {

    weak var view: CreatePostView?

    private var postContent: String = ""
    private var postImage: UIImage?
    private lazy var phPickerViewController: PHPickerViewController = {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        return phPickerVC
    }()

    private let user: User
    private let interactor: CreatePostInteractor
    private let router: CreatePostRouter

    init(user: User, interactor: CreatePostInteractor, router: CreatePostRouter) {
        self.user = user
        self.interactor = interactor
        self.router = router
    }

}

extension CreatePostDefaultPresenter: CreatePostPresenter {

    func onPostContentDidBeginEditing() {
        if postContent.isEmpty {
            view?.hidePostContentPlaceholder()
        }
    }

    func onPostContentChanged(text: String) {
        self.postContent = text
    }

    func onPostContentDidEndEditing() {
        if postContent.isEmpty {
            view?.showPostContentPlaceholder()
        }
    }

    func onAddImageTapped() {
        router.showImagePicker(phPickerViewController)
    }

    func onRemoveImageTapped() {
        self.postImage = nil
        view?.removePostImage()
    }

    func onPostImageSelected(image: UIImage) {
        self.postImage = image
    }

    func onPostImageRemoved() {
        self.postImage = nil
    }

    func onSubmitTapped() {
        let post = Post(user: user, postContent: postContent, contentImage: postImage)
        interactor.submitPost(post)
    }

}

extension CreatePostDefaultPresenter: CreatePostInteractorOutput {

    func onPostSubmittedSuccessfully() {
        router.popToFeedsScreen()
    }

}

extension CreatePostDefaultPresenter: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        if let firstResult = results.first {
            firstResult.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.postImage = image
                    self?.view?.showPostImage(image)
                }
            }
        }

    }

}
