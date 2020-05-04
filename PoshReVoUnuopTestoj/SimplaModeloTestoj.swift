//
//  SimplaModeloTestoj.swift
//  PoshReVoUnuopTestoj
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Sinuous Rill. All rights reserved.
//

import XCTest
@testable import PoshReVo

class SimplaModeloTestoj: XCTestCase {
    
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
    
    func testKreiStilon() {
        let fig = Stilo("FIG", "figure")
        XCTAssertEqual(fig.kodo, "FIG")
        XCTAssertEqual(fig.nomo, "figure")
        
        let fraz = Stilo("FRAZ", "frazaĵo")
        XCTAssertEqual(fraz.kodo, "FRAZ")
        XCTAssertEqual(fraz.nomo, "frazaĵo")
    }
}
