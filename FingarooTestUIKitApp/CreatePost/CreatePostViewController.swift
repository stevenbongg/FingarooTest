//
//  CreatePostViewController.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 07/01/24.
//

import Photos
import PhotosUI
import UIKit

final class CreatePostViewController: UIViewController {

    static func build(user: User) -> CreatePostViewController {
        let interactor = CreatePostDefaultInteractor()
        let router = CreatePostDefaultRouter()
        let presenter = CreatePostDefaultPresenter(user: user, interactor: interactor, router: router)
        let viewController = CreatePostViewController(presenter: presenter)

        interactor.output = presenter
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }

    // MARK: - Views

    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.text = "Write your post here..."
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Image", for: .normal)
        let action = UIAction { [weak self] _ in
            self?.onAddImageTapped()
        }
        button.addAction(action, for: .touchUpInside)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var removeImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove Image", for: .normal)
        let action = UIAction { [weak self] _ in
            self?.onRemoveImageTapped()
        }
        button.addAction(action, for: .touchUpInside)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit Post", for: .normal)
        let action = UIAction { [weak self] _ in
            self?.presenter.onSubmitTapped()
        }
        button.addAction(action, for: .touchUpInside)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Private Properties

    private lazy var imagePicker = UIImagePickerController()

    private let presenter: CreatePostPresenter

    // MARK: - Initializer

    init(presenter: CreatePostPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(contentTextView)
        view.addSubview(buttonsStackView)
        view.addSubview(postImageView)
        buttonsStackView.addArrangedSubview(removeImageButton)
        buttonsStackView.addArrangedSubview(addImageButton)
        buttonsStackView.addArrangedSubview(submitButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentTextView.bottomAnchor.constraint(equalTo: postImageView.topAnchor, constant: -16),

            postImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            postImageView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
            postImageView.widthAnchor.constraint(equalToConstant: 100),
            postImageView.heightAnchor.constraint(equalToConstant: 100),

            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            removeImageButton.heightAnchor.constraint(equalToConstant: 46),
            addImageButton.heightAnchor.constraint(equalToConstant: 46),
            submitButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    private func onAddImageTapped() {
        presenter.onAddImageTapped()
    }

    private func onRemoveImageTapped() {
        presenter.onRemoveImageTapped()
    }

}

extension CreatePostViewController: CreatePostView {

    func showPostContentPlaceholder() {
        contentTextView.text = "Placeholder"
        contentTextView.textColor = .lightGray
    }
    
    func hidePostContentPlaceholder() {
        contentTextView.text = ""
        contentTextView.textColor = .black
    }

    func showPostImage(_ image: UIImage) {
        postImageView.image = image
        postImageView.isHidden = false
        removeImageButton.isHidden = false
        addImageButton.isHidden = true
    }

    func removePostImage() {
        postImageView.image = nil
        postImageView.isHidden = true
        removeImageButton.isHidden = true
        addImageButton.isHidden = false
    }

}

extension CreatePostViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        presenter.onPostContentDidBeginEditing()
    }

    func textViewDidChange(_ textView: UITextView) {
        presenter.onPostContentChanged(text: textView.text)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        presenter.onPostContentDidEndEditing()
    }

}
