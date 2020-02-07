//
//  APIService.swift
//  GithubUsers
//
//  Created by Alex Ngo on 1/16/20.
//  Copyright © 2020 Alex Ngo. All rights reserved.
//

class APIService: NSObject {
    
    func performTask(with request:URLRequest, completionHandler:@escaping DataBlock) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                let msg = "Network is broken. Check your internet connection.";
                DispatchQueue.main.async {
                    APP_DELEGATE.showError(message:msg)
                }
                completionHandler(nil)
                return
            }
            
            guard let data = data else {
                let msg = "No response. Try again later."
                DispatchQueue.main.async {
                    APP_DELEGATE.showError(message:msg)
                }
                completionHandler(nil)
                return
            }

            let validStatusCodes = 200..<300

            guard let httpResponse = response as? HTTPURLResponse,
                validStatusCodes.contains(httpResponse.statusCode) else {
                    let msg = "Server is busy. Try again later.";
                    DispatchQueue.main.async {
                        APP_DELEGATE.showError(message:msg)
                    }
                    completionHandler(nil)
                    return
            }
            
            // If everything is OK. Passing data for processing at next step
            completionHandler(data)
            
        }.resume()
    }
    
    
}
