//
//  UserCell.swift
//  GithubUsers
//
//  Created by Ngo Lien on 2/7/20.
//  Copyright © 2020 Alex Ngo. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    @IBOutlet weak var lbLogin:UILabel!
    @IBOutlet weak var lbGithubURL:UILabel!
    @IBOutlet weak var lbAccountType:UILabel!
    @IBOutlet weak var lbSiteAdmin:UILabel!
    
    @IBOutlet weak var avatar:UIImageView!
    @IBOutlet weak var iconLove:UIImageView!
    @IBOutlet weak var line:UIView!
    
    var user:User!
    var favoriteAction:UserBlock?
    var unfavoriteAction:UserBlock?

    override func awakeFromNib() {
        super.awakeFromNib()
        adjustGUI()
    }
    
    func adjustGUI() {
        var frame = line.frame
        frame.size.height = 0.5
        line.frame = frame
        
        iconLove.image = iconLove.image?.tint(UIColor.gray)
    }

    func configureCell(user:User) {
        self.user = user
        // Load user avatar
        let url = URL(string: user.avatar_url)
        avatar.sd_setImage(with: url, placeholderImage: UIImage(named: "user"))
        
        lbLogin.text = user.login
        lbGithubURL.text = user.html_url
        lbAccountType.text = user.type
        lbSiteAdmin.text = "\(user.site_admin)"
        
        // Favorite or not
        let tintColor = (user.isFavorite) ? UIColor.red : UIColor.gray
        iconLove.image = iconLove.image?.tint(tintColor)
    }
    
    @IBAction func ibaToggleFavorite() {
        // Take action
        if user!.isFavorite {
            // Remove from Favorites
            unfavoriteAction?(user)
        } else {
            // Add to Favorites
            favoriteAction?(user)
        }
        
        // Update model
        user!.isFavorite = !user!.isFavorite
        
        // Update GUI
        let tintColor = (user!.isFavorite) ? UIColor.red : UIColor.gray
        iconLove.image = iconLove.image?.tint(tintColor)
    }
    
}
