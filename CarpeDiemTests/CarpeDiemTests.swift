//
//  CarpeDiemTests.swift
//  CarpeDiemTests
//
//  Created by Eric Mao on 1/21/17.
//  Copyright © 2017 Eric Mao. All rights reserved.
//

import XCTest
@testable import CarpeDiem

class CarpeDiemTests: XCTestCase {
    
    //MARK: Quote Class Tests
    
    // Confirm that the Quote initializer returns a Quote object when passed valid parameters.
    func testMealInitializationSucceeds() {
        
        // Quote with author and body
        let authorAndBodyQuote = Quote.init(author: "Gandhi", body: "Be the change you wish to see in the world.")
        XCTAssertNotNil(authorAndBodyQuote)
        
        // Missing author
        let missingAuthorQuote = Quote.init(author: "", body: "A year from now, you'll wish you had started today")
        XCTAssertNotNil(missingAuthorQuote)
        XCTAssert(missingAuthorQuote?.author == "Anonymous")
    }
    
    func testMealInitializationFails(){
        // Missing body
        let missingBody = Quote.init(author: "Gandhi", body: "")
        XCTAssertNil(missingBody)
        
        // Missing body and author
        let missingBodyAndAuthor = Quote.init(author: "", body: "")
        XCTAssertNil(missingBodyAndAuthor)
        
    }
    
    
}
