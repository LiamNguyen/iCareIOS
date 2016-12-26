//
//  HTTPClient.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /26/12/2016.
//  Copyright © 2016 LetsDev. All rights reserved.
//

import Foundation

public class HTTPClient {
    private var network = NetworkConnectivity()
    private var serviceURL = ServiceURL(isPRD: true)
    private var returnArray = [AnyObject]()
    
    func getRequest(url: String) {
        if !network.isConnected() {
            return
        }

        let URL = NSURL(string: serviceURL.getServiceURL(serviceURL: url))
        let data = NSData(contentsOf: URL as! URL)
        let JSONResponse = try! JSONSerialization.jsonObject(with: data as! Data, options: .allowFragments) as! NSDictionary
        
        returnArray = (JSONResponse[url] as? [AnyObject])!
    }
    
    func postRequest(url: String, body: String) {
        var request = URLRequest(url: URL(string: serviceURL.getServiceURL(serviceURL: url))!)
        request.httpMethod = "POST"
        let postString = body
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("responseString = \(responseString)")
            }
        }
        task.resume()
    }
    
    func returnDataFromGetRequest(url: String) -> [AnyObject] {
        getRequest(url: url)
        return returnArray
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
