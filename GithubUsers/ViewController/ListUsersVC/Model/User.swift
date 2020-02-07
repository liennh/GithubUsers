//
//  User.swift
//  GithubUsers
//
//  Created by Ngo Lien on 2/7/20.
//  Copyright © 2020 Alex Ngo. All rights reserved.
//


public class User: NSObject, NSCoding {
    var login: String = ""
    var id: Int64 = -1
    var node_id: String = ""
    var avatar_url: String = ""
    var url: String = ""
    var html_url: String = ""
    var followers_url: String = ""
    var following_url: String = ""
    var gists_url: String = ""
    var starred_url: String = ""
    var subscriptions_url: String = ""
    var organizations_url: String = ""
    var repos_url: String = ""
    var events_url: String = ""
    var received_events_url: String = ""
    var type: String = ""
    var site_admin: Bool = false
    var isFavorite:Bool = false 
    
    public override init() {
    }
    
    init(data:[String:Any]) {
        super.init()
        id = (data["id"] as? Int64) ?? -1
        login = (data["login"] as? String) ?? ""
        avatar_url = (data["avatar_url"] as? String) ?? ""
        url = (data["url"] as? String) ?? ""
        html_url = (data["html_url"] as? String) ?? ""
        type = (data["type"] as? String) ?? ""
        site_admin = (data["site_admin"] as? Bool) ?? false
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeInt64(forKey: "id")
        self.login = (aDecoder.decodeObject(forKey: "login") as? String) ?? ""
        self.avatar_url = (aDecoder.decodeObject(forKey: "avatar_url") as? String) ?? ""
        self.url = (aDecoder.decodeObject(forKey: "url") as? String) ?? ""
        self.html_url = (aDecoder.decodeObject(forKey: "html_url") as? String) ?? ""
        self.type = (aDecoder.decodeObject(forKey: "type") as? String) ?? ""
        self.site_admin = aDecoder.decodeBool(forKey: "site_admin")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(login, forKey: "login")
        aCoder.encode(avatar_url, forKey: "avatar_url")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(html_url, forKey: "html_url")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(site_admin, forKey: "site_admin")
    }
}

