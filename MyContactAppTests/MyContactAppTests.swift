//
//  MyContactAppTests.swift
//  MyContactAppTests
//
//  Created by Saleh Masum on 20/12/18.
//  Copyright © 2018 Saleh Masum. All rights reserved.
//

import XCTest
@testable import MyContactApp

class MyContactAppTests: XCTestCase {

    //MARK: Contact class tests
    // Confirm that the Contact initializer returns a Contact object when passed valid parameters.
    func testContactInitializationSucceeds() {
        
        //full name and mobile contact
        let fullCredentialContact = Contact.init(givenName: "Saleh", familyName: "Masum", mobile: "0451950721", isFavorite: false)
        XCTAssertNotNil(fullCredentialContact)
        
        let favoriteContact = Contact.init(givenName: "Arif", familyName: "Rabbani", mobile: "0451950721", isFavorite: true)
        XCTAssertNotNil(favoriteContact)
        
    }
    
    func testContactInitializationFails() {
        
        //empty given name
        let noGivenNameContact = Contact.init(givenName: "", familyName: "Saleh", mobile: "0451950721", isFavorite: false)
        XCTAssertNil(noGivenNameContact)
        
        let noFamilyNameContact = Contact.init(givenName: "Saleh", familyName: "", mobile: "0451950721", isFavorite: false)
        XCTAssertNil(noFamilyNameContact)
        
        let emptyMobileContact = Contact.init(givenName: "Saleh", familyName: "Masum", mobile: "", isFavorite: false)
        XCTAssertNil(emptyMobileContact)
        
    }
    
}
