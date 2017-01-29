//
//  StringExtension.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /25/01/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

extension String {
    func localized(lang: String) -> String {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
