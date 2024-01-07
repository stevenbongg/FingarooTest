//
//  FeedCell.swift
//  FingarooTestUIKitApp
//
//  Created by Steven Bong on 06/01/24.
//

import UIKit

final class FeedCell: UITableViewCell {

    static let identifer = String(describing: FeedCell.self)
    static let preferredHeight: CGFloat = 100

    // MARK: - Views

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let usertagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        return stackView
    }()

    private let postContentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentImageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Constants

    private let verticalMargin: CGFloat = 16
    private let horizontalMargin: CGFloat = 16

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    func set(post: Post) {
        profileImageView.image = post.user.profileImage
        usernameLabel.text = post.user.username
        usertagLabel.text = post.user.usertag
        postContentLabel.text = post.postContent

        if let contentImage = post.contentImage {
            contentImageContainerView.isHidden = false
            contentImageView.image = contentImage
        } else {
            contentImageContainerView.isHidden = true
            contentImageView.image = nil
        }
    }

    // MARK: - Private Methods

    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(usertagLabel)
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(postContentLabel)
        contentStackView.addArrangedSubview(contentImageContainerView)
        contentImageContainerView.addSubview(contentImageView)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalMargin),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: verticalMargin),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),

            usernameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: horizontalMargin),

            usertagLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            usertagLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: horizontalMargin),
            usertagLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalMargin),

            contentStackView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: verticalMargin),
            contentStackView.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalMargin),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalMargin),

            contentImageView.topAnchor.constraint(equalTo: contentImageContainerView.topAnchor),
            contentImageView.leadingAnchor.constraint(equalTo: contentImageContainerView.leadingAnchor),
            contentImageView.bottomAnchor.constraint(equalTo: contentImageContainerView.bottomAnchor),
            contentImageView.widthAnchor.constraint(equalTo: contentImageContainerView.widthAnchor, multiplier: 0.5),
            contentImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

}
