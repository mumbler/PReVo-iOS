//
//  TradukoTestoj.swift
//  PoshReVoUnuopTestoj
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import XCTest
@testable import PoshReVo

final class TradukoTestoj: XCTestCase {
    
    func testKreiTradukon() {
        let angla = Lingvo("en", "angla")
        let hebrea = Lingvo("he", "hebrea")

        let anglen = Traduko(lingvo: angla, teksto: "dog")
        XCTAssertEqual(anglen.lingvo, angla)
        XCTAssertEqual(anglen.teksto, "dog")
        
        let hebreen = Traduko(lingvo: hebrea, teksto: "כלב")
        XCTAssertEqual(hebreen.lingvo, hebrea)
        XCTAssertEqual(hebreen.teksto, "כלב")
        
    }
}
