//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Anna on 20.06.2024.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func didUpdateProfile(_ profile: ProfileModel)
}

final class ProfileViewController: UIViewController {

    // MARK: - Private Properties
    
    private var profile: ProfileModel?
    private let sections = ["Мои NFT (112)", "Избранные NFT (11)", "О разработчике"]
    
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = .ypBlack
        return label
    }()
    
    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.caption2
        textView.textColor = .ypBlack
        textView.backgroundColor = .ypWhite
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let urlButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .caption1
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(
        ProfileTableViewCell.self, 
        forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier
        )
        return tableView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profile = MockData.profile
        setupProfile()
        setupUI()
        setupNavigationItem()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProfile()
    }
    
    // MARK: - Private Functions
    private func setupProfile() {
        guard let profile = profile else { return }
        avatarImage.image = UIImage(named: profile.avatar ?? "avatarMockProfile")
        nameLabel.text = profile.name
        bioTextView.text = profile.description
        urlButton.setTitle(profile.website, for: .normal)
    }
    
    @objc func editProfileTapped() {
        guard let profile = profile else { return }
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.delegate = self
        editProfileViewController.configure(profile: profile)
        let navigationController = UINavigationController(rootViewController: editProfileViewController)
        present(navigationController, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        navigationController?.isNavigationBarHidden = false
        
        [avatarImage, nameLabel, bioTextView, urlButton, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),

            nameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            bioTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bioTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bioTextView.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 10),

            urlButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 8),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: urlButton.bottomAnchor, constant: 40),
            tableView.heightAnchor.constraint(equalToConstant: 162)
        ])
    }
    
    private func setupNavigationItem() {
        let editButton = UIBarButtonItem(
            image: UIImage.squarePencilFigma,
            style: .plain,
            target: self,
            action: #selector(editProfileTapped)
        )
        editButton.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = editButton
        navigationController?.navigationBar.isHidden = false
    }
    
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = sections[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            // Переход на экран NFT пользователя
            let userNFTViewController = UserNFTViewController()
            navigationController?.pushViewController(userNFTViewController, animated: true)
        case 1:
            // Переход на экран с избранными NFT
            let favoriteNFTViewController = FavoriteNFTViewController()
            navigationController?.pushViewController(favoriteNFTViewController, animated: true)
        case 2:
            // Переход на экран с информацией о разработчике
            let developerInfoViewController = DeveloperInfoViewController()
            navigationController?.pushViewController(developerInfoViewController, animated: true)
        default:
            break
        }
    }
}

extension ProfileViewController: ProfileViewControllerDelegate {
    func didUpdateProfile(_ profile: ProfileModel) {
        self.profile = profile
        setupProfile()
    }
}