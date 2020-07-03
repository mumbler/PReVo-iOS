//
//  FakoTestoj.swift
//  PoshReVoUnuopTestoj
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import XCTest

@testable import ReVoModeloj

final class FakoTestoj: XCTestCase {
    
    func testKreiFakon() {
        let kir = Fako("KIR", "kirurgio")
        XCTAssertEqual(kir.kodo, "KIR")
        XCTAssertEqual(kir.nomo, "kirurgio")
        
        let her = Fako("HER", "heraldiko")
        XCTAssertEqual(her.kodo, "HER")
        XCTAssertEqual(her.nomo, "heraldiko")
        
        let ship = Fako("ŜIP", "ŝipkonstruado, navigado")
        XCTAssertEqual(ship.kodo, "ŜIP")
        XCTAssertEqual(ship.nomo, "ŝipkonstruado, navigado")
    }
}
