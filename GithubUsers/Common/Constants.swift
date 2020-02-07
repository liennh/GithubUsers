//
//  Constants.swift
//  Alex Ngo
//
//  Created by Alex Ngo on 5/8/19.
//  Copyright © 2019 Alex Ngo. All rights reserved.
//

import UIKit

/***************  Closure  ***************/
public typealias  VoidBlock = () -> Void
public typealias  StringBlock = (String) -> Void
public typealias  ErrorBlock = (String) -> Void
public typealias  DataBlock = (Data?) -> Void
public typealias  UserBlock = (User) -> Void

// keys
struct Keys {
    static let favorites = "Favorites"
}

let SCREEN_SIZE = UIScreen.main.bounds
let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
