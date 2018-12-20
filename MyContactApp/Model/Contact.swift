//
//  Contact.swift
//  MyContactApp
//
//  Created by Saleh Masum on 20/12/18.
//  Copyright © 2018 Saleh Masum. All rights reserved.
//

import Foundation

@objc class Contact : NSObject {
    @objc var givenName: String
    @objc var familyName: String
    @objc var mobile: String
    var isFavorite: Bool


    init?(givenName: String, familyName: String, mobile: String, isFavorite: Bool) {
        
        
        if givenName.isEmpty || familyName.isEmpty || mobile.isEmpty {
            return nil
        }
        
        self.givenName = givenName
        self.familyName = familyName
        self.mobile = mobile
        self.isFavorite = isFavorite
    }
    
    
    
}
