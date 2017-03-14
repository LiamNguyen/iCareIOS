//
//  HTTPClient.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation

protocol HTTPClientDelegate {
    func onReceiveRequestResponse(data: AnyObject) -> Void
    func onReceivePostRequestResponse(data: AnyObject, statusCode: Int) -> Void
}

public class HTTPClient {
    private var serviceURL = ServiceURL(environment: .LOCAL)
    private var returnArray = [AnyObject]()
    var delegate: HTTPClientDelegate?
    
    func getRequest(url: String, parameter: String? = "") {
        if !Reachability.isConnectedToNetwork() {
            print("No network connection")
            return
        }
        
        let nsUrl: NSURL!
        if parameter!.isEmpty {
            nsUrl = NSURL(string: serviceURL.getServiceURL(serviceURL: url) + parameter!)
        } else {
            nsUrl = NSURL(string: serviceURL.getServiceURL(serviceURL: url) + "/\(parameter!)")
        }
        var request = URLRequest(url: nsUrl as URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error = \n\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                print("Status code: \(httpStatus.statusCode)")
                
                if httpStatus.statusCode >= 400 {
                    print("response = \n\(response)")
                }
            }
            
            if data.count != 0 {
                let JSONResponse = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                print("\nGET: \(nsUrl!)\n")
                print("Response from server: \n\(JSONResponse)")
                self.delegate?.onReceiveRequestResponse(data: JSONResponse!)
            }
        }
        
        task.resume()
    }
    
    func postRequest(url: String, body: String, sessionToken: String? = "") {
        if !Reachability.isConnectedToNetwork() {
            print("No network connection")
            return
        }
        
        let nsUrl = NSURL(string: serviceURL.getServiceURL(serviceURL: url))
        var request = URLRequest(url: nsUrl as! URL)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(sessionToken!, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var statusCode = HttpStatusCode.noContent
            
            guard let data = data, error == nil else {
                print("error =\n\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                print("Status code: \(httpStatus.statusCode)")
                
                if httpStatus.statusCode >= 400 {
                    print("response = \n\(response)")
                }
                statusCode = httpStatus.statusCode
                
                if statusCode == HttpStatusCode.methodNotAllowed {
                    print("Try different http method ;)")
                    return
                }
            }
            
            if data.count != 0 {
                let JSONResponse = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                print("\nPOST: \(nsUrl!)\n")
                print("Response from server: \n\(JSONResponse)")
                self.delegate?.onReceiveRequestResponse(data: JSONResponse)
                
                self.delegate?.onReceivePostRequestResponse(data: JSONResponse, statusCode: statusCode)
            }
        }
        
        task.resume()
    }
    
    func putRequest(url: String, body: String? = "", sessionToken: String? = "") {
        if !Reachability.isConnectedToNetwork() {
            print("No network connection")
            return
        }
        
        let nsUrl = NSURL(string: serviceURL.getServiceURL(serviceURL: url))
        var request = URLRequest(url: nsUrl as! URL)
        request.httpMethod = "PUT"
        request.httpBody = body?.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(sessionToken!, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var statusCode = HttpStatusCode.noContent
            
            guard let data = data, error == nil else {
                print("error =\n\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                print("Status code: \(httpStatus.statusCode)")
                
                if httpStatus.statusCode >= 400 {
                    print("response = \n\(response)")
                }
                statusCode = httpStatus.statusCode
            }
            
            if data.count != 0 {
                let JSONResponse = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                print("\nPUT: \(nsUrl!)\n")
                print("Response from server: \n\(JSONResponse)")
                self.delegate?.onReceiveRequestResponse(data: JSONResponse)
                
                self.delegate?.onReceivePostRequestResponse(data: JSONResponse, statusCode: statusCode)
            }
        }
        
        task.resume()
    }
}

