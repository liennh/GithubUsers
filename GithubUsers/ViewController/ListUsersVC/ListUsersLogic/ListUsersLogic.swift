//
//  ListUsersLogic.swift
//  GithubUsers
//
//  Created by Ngo Lien on 2/7/20.
//  Copyright © 2020 Alex Ngo. All rights reserved.
//


class ListUsersLogic: NSObject {
    var apiService = APIService()
    var listUsers = [User]()
    var myFavorites = [User]()
    
    var since:Int64 = 0
    var waiting = false
    
    var updateWithEmptyGUI:VoidBlock?
    var updateGUI:VoidBlock?
    var showErrorMessage:ErrorBlock?
    
    override init() {
        super.init()
        myFavorites = getMyFavorites()
    }
    
    // MARK: Rest API
    func getListUsers() {
        let url = SERVER_BASE_URL + API.users + "?since=\(since)"
        
        guard let serviceURL = URL(string: url) else {
            let msg = "Invalid URL: \n\(url)"
            showErrorMessage?(msg)
            return
        }
        
        var request = URLRequest(url: serviceURL)
        request.httpMethod = "GET"
        
        apiService.performTask(with:request) {[weak self] data in // data may be nil
            guard let _self = self else {return}
            _self.waiting = false
            guard data != nil else {
                if _self.since == 0 {
                    _self.updateWithEmptyGUI?()
                }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String:Any]]
                DispatchQueue.main.async {
                    _self.prepareListUsers(json:json)
                    _self.updateGUI?()
                }
            } catch {
                let msg = "Cannot parse Github users data."
                DispatchQueue.main.async {
                    _self.showErrorMessage?(msg)
                }
            }
        }
    }
    
    fileprivate func prepareListUsers(json:[[String:Any]]) {
        for item in json {
            let user = User(data: item)
            user.isFavorite = isFavorite(user: user)
            listUsers.append(user)
        }
        since = listUsers.last!.id
    }
    
    
    // MARK: Favorites
    fileprivate func getMyFavorites() -> [User] {
        let df = UserDefaults()
        if let decoded = df.object(forKey: Keys.favorites) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [User]
        } else {
            return [User]()
        }

    }
    
    func isFavorite(user:User) -> Bool {
        for object in myFavorites {
            if object.id == user.id {
                return true
            }
        }
        return false
    }
    
    func addToFavorites(user:User) {
        addToCache(user:user)
        addToDisk(user:user)
    }
    
    func removeFromFavorites(user:User) {
        removeFromCache(user:user)
        removeFromDisk(user:user)
    }
    
    fileprivate func addToCache(user:User) {
        myFavorites.insert(user, at: 0)
    }
    
    fileprivate func removeFromCache(user:User) {
        var index = -1
        for object in myFavorites {
            index += 1
            if object.id == user.id {
                break
            }
        }
        
        guard index >= 0 else {return}
        myFavorites.remove(at: index)
    }
    
    fileprivate func addToDisk(user:User) {
        let df = UserDefaults()
        if let decoded = df.object(forKey: Keys.favorites) as? Data {
            var decodedData = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [User]
            for obj in decodedData {
                if obj.id == user.id {
                    return
                }
            }

            decodedData.insert(user, at: 0)
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedData)
            df.set(encodedData, forKey: Keys.favorites)

        } else {
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: [user])
            df.set(encodedData, forKey: Keys.favorites)
        }
    }
    
    fileprivate func removeFromDisk(user:User) {
        let df = UserDefaults()
        if let decoded = df.object(forKey: Keys.favorites) as? Data {
            var decodedData = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [User]
            var index = -1
            for obj in decodedData {
                index += 1
                if obj.id == user.id {
                    break
                }
            }
            
            guard index >= 0 else {return}

            decodedData.remove(at: index)
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedData)
            df.set(encodedData, forKey: Keys.favorites)
        }
    }
    
}
