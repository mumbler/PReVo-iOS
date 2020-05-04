//
//  LingvoTestoj.swift
//  PoshReVoUnuopTestoj
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Sinuous Rill. All rights reserved.
//

import XCTest
@testable import PoshReVo

class LingvoTestoj: XCTestCase {

    func testKreiLingvon() {
        let esperanto = Lingvo("eo", "esperanto")
        XCTAssert(esperanto.kodo == "eo")
        XCTAssert(esperanto.nomo == "esperanto")
        
        let franca = Lingvo("fr", "franca")
        XCTAssert(franca.kodo == "fr")
        XCTAssert(franca.nomo == "franca")
        
        let germana = Lingvo("de", "germana")
        XCTAssert(germana.kodo == "de")
        XCTAssert(germana.nomo == "germana")
    }
    
    func testLingvoEgaleco() {
        let esperanto = Lingvo("eo", "esperanto")
        let esperanto2 = Lingvo("eo", "esperanto")
        let franca = Lingvo("fr", "franca")
        let franca2 = Lingvo("fr", "franca")
        
        XCTAssertEqual(esperanto, esperanto2)
        XCTAssertEqual(franca, franca2)
        XCTAssertNotEqual(esperanto, franca)
        
        let francperanto = Lingvo("eo", "franca")
        
        XCTAssertNotEqual(esperanto, francperanto)
        XCTAssertNotEqual(franca, francperanto)
    }
}
