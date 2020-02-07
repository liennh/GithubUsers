//
//  AppLogic.swift
//  GithubUsers
//
//  Created by Alex Ngo on 1/16/20.
//  Copyright © 2020 Alex Ngo. All rights reserved.
//

import Foundation

class AppLogic: NSObject {
    var apiService = APIService()
    
    public static let shared: AppLogic = {
        return AppLogic()
    }()


    override init() {
        super.init()
       
    }
    
    

}// class
