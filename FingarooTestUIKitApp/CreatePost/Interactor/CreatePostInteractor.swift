//
//  CreatePostInteractor.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 07/01/24.
//

import Foundation

protocol CreatePostInteractor {
    func submitPost(_ post: Post)
}

protocol CreatePostInteractorOutput: AnyObject {
    func onPostSubmittedSuccessfully()
}

final class CreatePostDefaultInteractor {

    weak var output: CreatePostInteractorOutput?

    private let repository: Repository

    init(repository: Repository = DefaultRepository()) {
        self.repository = repository
    }

}

extension CreatePostDefaultInteractor: CreatePostInteractor {

    func submitPost(_ post: Post) {
        repository.save(post: post)
        output?.onPostSubmittedSuccessfully()
    }

}
