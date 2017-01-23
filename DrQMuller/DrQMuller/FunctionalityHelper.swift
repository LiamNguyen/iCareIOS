//
//  FunctionalityHelper.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /23/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import SystemConfiguration

struct Functionality {
    
//CONVERT OBJ TO JSON STRING - PROJECT PUBLIC FUNC
    
    static func jsonStringify(obj: AnyObject) -> String {
        let data = try! JSONSerialization.data(withJSONObject: obj, options: [])
        let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
        
        return jsonString
    }
    
//SORT DICTIONARY KEYS OR VALUES AND RETURN ARRAY
    
    static func sortDictionary(dictionary: [String: String]) -> [String] {
        var sortedArr = [String]()
        
        for key in dictionary.values {
            let convertedKeyStr = key.replacingOccurrences(of: ":", with: "")
            let convertedKey = Int(convertedKeyStr)!
            if sortedArr.isEmpty {
                sortedArr.append(key)
                continue
            }
            for item in sortedArr {
                if convertedKey < Int(item.replacingOccurrences(of: ":", with: ""))! {
                    sortedArr.insert(key, at: sortedArr.index(of: item)!)
                    break
                }
                
                if sortedArr.index(of: item) == sortedArr.count - 1 {
                    sortedArr.insert(key, at: sortedArr.count)
                }
            }
        }
        
        return sortedArr
    }
    
//TRANSLATE DAYS OF WEEK
    
    static func translateDaysOfWeek(en: String) -> String {
        var daysOfWeek = ["Monday":"Thứ hai",
                          "Tuesday":"Thứ ba",
                          "Wednesday":"Thứ tư",
                          "Thursday":"Thứ năm",
                          "Friday":"Thứ sáu",
                          "Saturday":"Thứ bảy",
                          "Sunday":"Chủ nhật"]
        return daysOfWeek[en]!
    }
    
//RETURN ARRAY FROM DICTIONARY

    static func returnArrayFromDictionary(dictionary: [String: String]!, isReturnValue: Bool) -> [String] {
        var resultArray = [String]()

        if let _ = dictionary {
            if isReturnValue {
                for values in dictionary.values {
                    resultArray.insert(values, at: resultArray.count)
                }
            } else {
                for keys in dictionary.keys {
                    resultArray.insert(keys, at: resultArray.count)
                }
            }
        }

        return resultArray
    }
    
//GET KEY FROM VALUE
    
    static func findKeyFromValue(dictionary: [String: String], value: String) -> String {
        var returnKey = String()
        
        for (dictKey, dictValue) in dictionary {
            if dictValue == value {
                returnKey = dictKey
                break
            }
        }
        
        return returnKey
    }
    
//CONVERT DATE FORMAT FROM A DATE TYPE OF STRING
    
    static func convertDateFormatFromStringToDate(str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let formattedDate = dateFormatter.date(from: str)!
        return formattedDate
    }
}

struct Network {
    //CHECK NETWORK CONNECTIVITY
    
    static func hasNetworkConnection() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
