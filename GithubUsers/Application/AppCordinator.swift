//
//  AppCordinator.swift
//  GithubUsers
//
//  Created by Alex Ngo on 1/13/20.
//  Copyright © 2020 Alex Ngo. All rights reserved.
//

import UIKit
import SafariServices

extension AppDelegate:SFSafariViewControllerDelegate {
    func openWeb(_ url:URL) {
        let vc = SFSafariViewController(url: url)
        vc.delegate = self
        
        // Present here
        if let nav = self.window?.rootViewController as? UINavigationController {
            nav.dismiss(animated: false, completion: nil)
            nav.present(vc, animated: false, completion: nil)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AppDelegate {
    
    func showHome() {
        if self.window == nil {
            self.window = UIWindow.init(frame: UIScreen.main.bounds)
        }
        let logicHandler = ListUsersLogic()
        let vc = ListUsersVC.make(logicHandler:logicHandler)
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func showError(message:String) {
        var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        topWindow?.rootViewController = UIViewController()
        topWindow?.windowLevel = UIWindow.Level.alert + 1

        let alert = UIAlertController(title: "Error Occurred", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            // continue your work

            // important to hide the window after work completed.
            // this also keeps a reference to the window until the action is invoked.
            topWindow?.isHidden = true // if you want to hide the topwindow then use this
            topWindow = nil // if you want to hide the topwindow then use this
         })

        topWindow?.makeKeyAndVisible()
        topWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

}
