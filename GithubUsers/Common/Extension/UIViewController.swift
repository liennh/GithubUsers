//
//  UIViewController.swift
//  GithubUsers
//
//  Created by Ngo Lien on 2/7/20.
//  Copyright © 2020 Alex Ngo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func present(viewController:UIViewController) {
        let navgation = UINavigationController(rootViewController: viewController)
        navgation.isNavigationBarHidden = true
        navgation.modalPresentationStyle = .overCurrentContext
        navgation.modalTransitionStyle = .crossDissolve
        navgation.modalPresentationCapturesStatusBarAppearance = true
        self.tabBarController!.present(navgation, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, action: (()->())? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in action?()}
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func confirmAlert(title: String, message: String, action: (()->())? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in action?()}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

