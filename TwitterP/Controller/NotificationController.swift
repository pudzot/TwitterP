//
//  NotificationController.swift
//  TwitterP
//
//  Created by Damian Piszcz on 22/01/2023.
//

import UIKit

class NotificationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    }

}
