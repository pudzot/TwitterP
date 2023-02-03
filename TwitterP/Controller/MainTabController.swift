//
//  MainTabController.swift
//  TwitterP
//
//  Created by Damian Piszcz on 22/01/2023.
//

import UIKit
import Firebase

enum ActionButtonConfiguration {
    case tweet
    case message
}

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    private var buttonConfig: ActionButtonConfiguration = .tweet
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
     
        authenticateUserAndConfigureUI()
        
        
    }
    
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        let controller: UIViewController
        
        switch buttonConfig {
        case .message:
            controller = SearchController(config: .messages)
        case .tweet:
            guard let user = self.user else {return}
            controller = UploadTweetController(user: user, config: .tweet)
        }
            
            let nav = UINavigationController(rootViewController: controller)
             nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        
    }

    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            print("DEBUG: User is NOT logged in...")
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            print("DEBUG: User is logged in...")
            configureViewControllers()
            configureUI()
            customNavigationBar()
            fetchUser()
        }
    }
    
   
    
    // MARK: - Helpers
    
    func configureUI() {
        self.delegate = self
        view.addSubview(actionButton)
//        actionButton.translatesAutoresizingMaskIntoConstraints = false
//        actionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
//        actionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
//        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64).isActive = true
//        actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
//        actionButton.layer.cornerRadius = 56/2
        
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56/2
    }
    
    func configureViewControllers() {
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = SearchController(config: .userSearch)
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notifications = NotificationController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        
        let conversations = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
        
        
        viewControllers = [nav1, nav2, nav3, nav4]
        
    }
    
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
       // nav.navigationBar.barTintColor = .systemBackground
        return nav
    }
    
    func customNavigationBar() {
        let coloredAppearance = UINavigationBarAppearance()
       // coloredAppearance.configureWithTransparentBackground()
       // coloredAppearance.backgroundColor = .systemBackground
//        coloredAppearance.backgroundColor = UIColor(
//            red: 41/255,
//            green: 59/255,
//            blue: 77/255,
//            alpha: 1) //alpha: 0 is Transparent and alpha: 1 is colored
       // coloredAppearance.shadowColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .blue
        
        let appearanceBar = UITabBarAppearance()
        appearanceBar.configureWithOpaqueBackground()
        appearanceBar.backgroundColor = .systemBackground
        tabBar.standardAppearance = appearanceBar
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
    }
    
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        let imageName = index == 3 ? "mail" : "new_tweet"
        self.actionButton.setImage(UIImage(named: imageName), for: .normal)
        buttonConfig = index == 3 ? .message : .tweet
        
    }
}
