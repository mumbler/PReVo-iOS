//
//  ListeroTestoj.swift
//  PoshReVoUnuopTestoj
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import XCTest
@testable import PoshReVo

final class ListeroTestoj: XCTestCase {
    
    func testKreiListeron() {
        let charniro = Listero("ĉarnir/o", "cxarni")
        XCTAssert(charniro.nomo == "ĉarnir/o")
        XCTAssert(charniro.indekso == "cxarni")
        
        let avanci = Listero("avanc/i", "avanc")
        XCTAssert(avanci.nomo == "avanc/i")
        XCTAssert(avanci.indekso == "avanc")
    }
    
    func testListeroChifradon() {

        let listero = Listero("ĉarnir/o", "cxarni")

        do {
            let chifrita = try NSKeyedArchiver.archivedData(withRootObject: listero,
                                                            requiringSecureCoding: true)
            guard let malchifrita =
                try NSKeyedUnarchiver.unarchivedObject(ofClass: Listero.self,
                                                       from: chifrita) else {
                XCTFail("Malsukcesis malchifri listeron")
                return
            }
            
            XCTAssertEqual(malchifrita.nomo, "ĉarnir/o")
            XCTAssertEqual(malchifrita.indekso, "cxarni")
        } catch {
            XCTFail("Eraris en chifrado de listero")
        }
    }
}
