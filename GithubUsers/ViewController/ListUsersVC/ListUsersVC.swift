//
//  ListUsersVC.swift
//  GithubUsers
//
//  Created by Ngo Lien on 2/7/20.
//  Copyright © 2020 Alex Ngo. All rights reserved.
//

import UIKit

let kUserCell = "UserCell"

class ListUsersVC: BaseVC {
    @IBOutlet weak var tbView:UITableView!
    @IBOutlet weak var line:UIView!
    @IBOutlet weak var vNoData:UIView!
    
    var logicHandler:ListUsersLogic!
     
     class func make(logicHandler: ListUsersLogic) -> ListUsersVC {
         let vc = ListUsersVC()
         vc.logicHandler = logicHandler
         return vc
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        
        logicHandler.updateGUI = {[weak self] in
            guard let _self = self else {return}
            _self.hideLoading()
            _self.tbView.reloadData()
            _self.vNoData.isHidden = true
        }
        
        logicHandler.showErrorMessage = {[weak self] errorMsg in
            guard let _self = self else {return}
            DispatchQueue.main.async {
               _self.hideLoading()
               _self.showAlert(title: "Error Occurred", message: errorMsg)
            }
        }
        
        logicHandler.updateWithEmptyGUI = {[weak self] in
            guard let _self = self else {return}
            _self.hideLoading()
            _self.vNoData.isHidden = false
        }
        
        loadData()

    }
    
    func loadData() {
        showLoading()
        logicHandler.getListUsers()
    }
    
    override func adjustGUI() {
        super.adjustGUI()
        var frame = line.frame
        frame.size.height = 0.5
        line.frame = frame
    }
    
    func registerNibs() {
        tbView.register(UINib.init(nibName: kUserCell, bundle: nil), forCellReuseIdentifier: kUserCell)
    }
    
    fileprivate func showDetails(user:User) {
        if let url = URL(string: user.html_url) {
            APP_DELEGATE.openWeb(url)
        }
    }
    
    @IBAction func ibaTryAgain() {
        loadData()
    }

}


extension ListUsersVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logicHandler.listUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 193
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kUserCell) as! UserCell
        let user = logicHandler.listUsers[indexPath.row]
        cell.configureCell(user:user)
        cell.selectionStyle = .none
        
        cell.favoriteAction = {[weak self] user in
            guard let _self = self else {return}
            _self.logicHandler.addToFavorites(user: user)
        }
        
        cell.unfavoriteAction = {[weak self] user in
            guard let _self = self else {return}
            _self.logicHandler.removeFromFavorites(user: user)
        }
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let user = logicHandler.listUsers[indexPath.row]
        showDetails(user:user)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == (logicHandler.listUsers.count - 2)) && !logicHandler.waiting  {
            logicHandler.waiting = true
            // Load more data
            logicHandler.getListUsers()
        }
    }
}

