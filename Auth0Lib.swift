//
//  Auth0Lib.swift
//  MimoiOSCodingChallenge
//
//  Created by Andre Neris on 08/04/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation

struct Auth0Lib {
    let clientId: String?
    let domain: String?
    let urlString: String?

    
     init(){
        if let url = Bundle.main.url(forResource:"Auth0", withExtension: "plist"),
        let dict = NSDictionary(contentsOf: url) as? [String:Any] {
            self.clientId = dict["ClientId"] as? String
            self.domain = dict["Domain"] as? String
            self.urlString = "https://\(self.domain!)"
        } else {
            self.clientId = "undifined cliend id"
            self.domain = "undefined domain"
            self.urlString = " "
        }
    }
    
    func auth0Send(urlString: String, data: [String: Any], completitionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void) ) {
        var jsonObject: Data?
        do {
            jsonObject = try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            
        }
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonObject
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: completitionHandler)
            task.resume()
        
        }
    }
        
        
    func signIn(username: String, password: String, onCompletion: ((Result<Credentials>) -> ())!){
        //parameters
        let data = ["client_id": self.clientId!,
                    "username": username,
                    "password": password,
                    "connection": "Username-Password-Authentication",
                    "scope": "openid"]  as [String: Any]
        
        //get results
        var completitionHandler: ((Data?, URLResponse?, Error?) -> Void)
        completitionHandler = {data, response, error in
            if error == nil && data != nil {
                
                var jsonObject: [String: Any]?
                do {
                    jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                } catch {
                    
                }
                
                guard let json = jsonObject else {
                    return
                }
                
                if let access_token = json["access_token"] as? String {
                    let id_Token = json["id_token"] as! String
                    var credential = Credentials(accessToken: access_token, idToken: id_Token)
                    onCompletion(.success(result: credential))
                    
                } else {
                    
                    guard let errorDescription = json["error_description"] as? String else {
                        return
                    }
                    onCompletion(.failure(error: errorDescription))
                }
                
                
            } else {
                onCompletion(.failure(error: error.debugDescription))
                print(error.debugDescription)
            }
        }
        
        let urlString = self.urlString!+"/oauth/ro"
        auth0Send(urlString: urlString, data: data, completitionHandler: completitionHandler)
        
    }
    
    func userInfo(access_token: String, onCompletion: ((Result<UserInfo>) -> ())! ) {
        //parameters
        let data = ["id_token": access_token]  as [String: Any]
        //get results
        var completitionHandler: ((Data?, URLResponse?, Error?) -> Void)
        completitionHandler = {data, response, error in
            if error == nil && data != nil {
                
                
                
                var jsonObject: [String: Any]?
                do {
                    jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                } catch {
                    
                    var strData = String(data: data!, encoding: .utf8)
                    print (strData!)
                    onCompletion(.failure(error: "unauthorized"))
                }
                
                guard let json = jsonObject else {
                    return
                }
                
                if let access_token = json["email"] as? String {
                    let email = json["email"] as? String
                    let picture = json["picture"] as? String
                    
                    var userInfo = UserInfo(email: email!, picture: picture!)
                    onCompletion(.success(result: userInfo))
                    
                } else {
                    
                    if let errorDescription = json["error"] as? String  {
                        onCompletion(.failure(error: errorDescription))
                    }
                    
                    if let errorDescription = json["description"] as? String  {
                        onCompletion(.failure(error: errorDescription))
                    }
                }
                
                
            } else {
                onCompletion(.failure(error: error.debugDescription))
                print(error.debugDescription)
            }
        }
        let urlString = self.urlString!+"/tokeninfo"
        auth0Send(urlString: urlString, data: data, completitionHandler: completitionHandler)
    }

    
    func signUp(email: String, password: String, onCompletion: ((Result<Credentials>) -> ())!) {
        //parameters
        let data = ["client_id": self.clientId!,
                    "email": email,
                    "password": password,
                    "connection": "Username-Password-Authentication"]  as [String: Any]
        //get results
        var completitionHandler: ((Data?, URLResponse?, Error?) -> Void)
        completitionHandler = {data, response, error in
            if error == nil && data != nil {
                
                var jsonObject: [String: Any]?
                do {
                    jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                } catch {
                    
                }
                
                guard let json = jsonObject else {
                    return
                }
                
                if let access_token = json["_id"] as? String {
                    
                    self.signIn(username: email,password: password,onCompletion: onCompletion)

                    
                } else {
                    
                    if let errorDescription = json["error"] as? String  {
                      onCompletion(.failure(error: errorDescription))
                    }
                    
                    if let errorDescription = json["description"] as? String  {
                        onCompletion(.failure(error: errorDescription))
                    }
                }
                
                
            } else {
                onCompletion(.failure(error: error.debugDescription))
                print(error.debugDescription)
            }
        }
        let urlString = self.urlString!+"/dbconnections/signup"
        auth0Send(urlString: urlString, data: data, completitionHandler: completitionHandler)
    }
    
}

