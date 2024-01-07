//
//  FeedViewController.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 06/01/24.
//

import UIKit

final class FeedViewController: UIViewController {

    static func build() -> FeedViewController {
        let interactor = FeedDefaultInteractor()
        let router = DefaultFeedRouter()
        let presenter = FeedDefaultPresenter(interactor: interactor, router: router)
        let viewController = FeedViewController(presenter: presenter)

        interactor.output = presenter
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }

    // MARK: - Views

    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "TEst"
        textField.inputView = userPickerView
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var userPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: Private Properties

    private let presenter: FeedPresenter

    // MARK: - Initializer

    init(presenter: FeedPresenter) {
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
        setupNavigationBar()
        setupViews()
        setupConstraints()

        presenter.onViewDidLoad()
    }

    // MARK: - Private Properties

    private func setupNavigationBar() {
        let action = UIAction { [weak self] (_: UIAction) in
            self?.presenter.onCreatePostTapped()
        }
        let createPostButton = UIBarButtonItem(
            systemItem: .add,
            primaryAction: action
        )
        navigationItem.rightBarButtonItem = createPostButton
        navigationItem.titleView = titleTextField

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDoneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        titleTextField.inputAccessoryView = toolBar
    }

    @objc private func onDoneClicked() {
        titleTextField.resignFirstResponder()
    }

    private func setupViews() {
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension FeedViewController: FeedView {

    func onPostsUpdated() {
        self.tableView.reloadData()
    }

    func onUsersUpdated() {
        self.userPickerView.reloadAllComponents()
    }

    func onSelectedUserUpdated(at row: Int) {
        self.userPickerView.selectRow(row, inComponent: 0, animated: false)
        self.titleTextField.text = presenter.users[row].username
    }

    func showEmptyFeed() {

    }

}

// MARK: - Picker View Related

extension FeedViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        presenter.users.count
    }

}

extension FeedViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        presenter.users[row].username
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter.onUserSelected(at: row)
    }

}

// MARK: - Table view related

extension FeedViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        FeedCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

}

extension FeedViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let post = presenter.posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifer, for: indexPath) as? FeedCell
        cell?.set(post: post)

        return cell ?? UITableViewCell()
    }

}
