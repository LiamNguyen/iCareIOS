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
}

public class HTTPClient {
    private var serviceURL = ServiceURL(environment: .UAT)
    private var returnArray = [AnyObject]()
    var delegate: HTTPClientDelegate?
    
    func getRequest(url: String, parameter: String) {
        if !Network.hasNetworkConnection() {
            return
        }
        let URL = NSURL(string: serviceURL.getServiceURL(serviceURL: url) + parameter)
        var request = URLRequest(url: URL as! URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if data?.count != 0 && data != nil {
                let JSONResponse = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                print("GET: \(URL!)")
                self.delegate?.onReceiveRequestResponse(data: JSONResponse!)
            } else {
                print("Check server connectivity")
            }
        
        }
        
        task.resume()
    }
    
    func postRequest(url: String, body: String) {//, postCompleted: @escaping (_ success: Bool, _ msg: String) -> ()) {
        if !Network.hasNetworkConnection() {
            return
        }
        
        let URL = NSURL(string: serviceURL.getServiceURL(serviceURL: url))
        var request = URLRequest(url: URL as! URL)
        request.httpMethod = "POST"
        let postString = body
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
//                postCompleted(false, "JSON data receives error: \(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
//                postCompleted(false, "http status receives error: \(error)_Status code: \(httpStatus.statusCode)")
            }
            
            if data.count != 0 {
                let JSONResponse = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                print("Response from server: \(JSONResponse)")
                print("POST: \(URL!)")
                self.delegate?.onReceiveRequestResponse(data: JSONResponse)
            }
        }
        
        task.resume()
    }
}





//        let request = NSMutableURLRequest(url: URL as! URL)
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
//            guard error == nil && data != nil else
//            {
//                print("Error:",error!)
//                return
//            }
//            if data?.count != 0
//            {
//                let JSONResponse = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary //because JSON data started with dictionary. Not an array
//
//                if let dataArray = JSONResponse["Select_AllTime"] as? [AnyObject] // posts started with array
//                {
////                    for arrayItem in dataArray
////                    {
////                        //let voucher = arrayItem["VOUCHER"] as! String //specify as String
////                        print(arrayItem)
////                        DispatchQueue.main.sync
////                        {
////                            //reload table
////                        }
////                    }
//                    DispatchQueue.main.sync
//                    {
//                        self.returnArray = dataArray
//                    }
//                }
//                else
//                {
//                    print("No data can be found in dataArray")
//                }
//
//            } else {
//                print("No data can be found in this url")
//            }
//        }
//        task.resume()
