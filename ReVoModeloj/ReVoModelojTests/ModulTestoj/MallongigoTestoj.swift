//
//  MallongigoTestoj.swift
//  PoshReVoUnuopTestoj
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import XCTest

@testable import ReVoModeloj

final class MallongigoTestoj: XCTestCase {
    
    func testKreiMallongigon() {
        let n = Mallongigo("N", "Bennemann")
        XCTAssertEqual(n.kodo, "N")
        XCTAssertEqual(n.nomo, "Bennemann")
        
        let adv = Mallongigo("adv.", "adverbo")
        XCTAssertEqual(adv.kodo, "adv.")
        XCTAssertEqual(adv.nomo, "adverbo")
        
        let te = Mallongigo("t.e.", "tio estas")
        XCTAssertEqual(te.kodo, "t.e.")
        XCTAssertEqual(te.nomo, "tio estas")
    }
}
