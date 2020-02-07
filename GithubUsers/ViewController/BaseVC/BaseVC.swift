//
//  BaseVC.swift
//  GithubUsers
//
//  Created by Ngo Lien on 2/7/20.
//  Copyright © 2020 Alex Ngo. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    @IBOutlet weak var navBar:UIView!
    @IBOutlet weak var vContent:UIView!
    
    var loadingSquare:AASquaresLoading?
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func ibaBack() {
        if let _ = self.navigationController?.popViewController(animated: true) {
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
        adjustGUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setBar(title: String, textColor: UIColor, background: UIColor) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
        self.title = title
        self.navigationController?.navigationBar.barTintColor = background
    }
    
    
    
    // MARK: Handle GUI on different devices
    func adjustGUI() {
        //self.navBar.backgroundColor = UIColor.white
        let screenSize = UIScreen.main.bounds.size
        var frame = self.view.frame
        frame.size.width = screenSize.width
        frame.size.height = screenSize.height
        self.view.frame = frame
        
        if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            //self.adjustOnPhone6()
        } else if UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus {
            // self.adjustOnPhone6Plus()
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            //self.adjustOnPhone5S()
        } else  {
            self.adjustOnPhoneX()
        }
    }
    
    func adjustOnPhoneX() {
        if let navi = self.navBar {
            self.navBar.increaseHeight(value: 24)
        }
        
        if let content = self.vContent {
            let screenSize = UIScreen.main.bounds
            var frame = self.vContent.frame
            frame.origin.y = self.navBar.frame.origin.y + self.navBar.frame.size.height
            frame.size.height = screenSize.height - navBar.frame.size.height -  navBar.frame.origin.y
            
            self.vContent.frame = frame
        }
    }
    
    // MARK: Loading animation
    func showLoading() {
        //self.progressHUD = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        if self.loadingSquare == nil {
            self.loadingSquare = AASquaresLoading(target: UIApplication.shared.keyWindow!, size: 40)
        }
        // Customize background
        self.loadingSquare?.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        // Customize color
        self.loadingSquare?.color = UIColor("#F65831")
        // Start loading
        self.loadingSquare?.start()
        
        //Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(hideLoading), userInfo: nil, repeats: false)
    }
    
    @objc func hideLoading() {
        //self.progressHUD.hide(animated: true)
        self.loadingSquare?.stop()
    }
    
   

}

