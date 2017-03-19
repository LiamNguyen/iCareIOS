//
//  BundleExtension.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /19/03/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
