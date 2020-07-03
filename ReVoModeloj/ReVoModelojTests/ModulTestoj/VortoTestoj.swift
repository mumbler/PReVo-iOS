//
//  VortoTestoj.swift
//  PoshReVoUnuopTestoj
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import XCTest

@testable import ReVoModeloj

final class VortoTestoj: XCTestCase {
    
    func testKreiVorton() {
        let ofertiTeksto = "tr \n\n[EKON] <a href=\"propon.0i\">Proponi</a> al iu varon aŭ servon aĉetotan: <i>Vobis unua kuraĝis, ekde ĉi marto, oferti komputilojn kun la nova Superdisk-aparato anstataŭ la diskingo por tradiciaj disketoj</i>"
        let oferti = Vorto(titolo: "ofert/i", teksto: ofertiTeksto, marko: "ofert.0i", ofc: "8")
        
        XCTAssertEqual(oferti.titolo, "ofert/i")
        XCTAssertEqual(oferti.teksto, ofertiTeksto)
        XCTAssertEqual(oferti.marko, "ofert.0i")
        XCTAssertEqual(oferti.ofc, "8")

        let kveriTeksto = "ntr \n\n1. (pri turtoj kaj kolomboj) <a href=\"blek.0o\">Bleki</a> per milda murmuro. ➞ <a href=\"kurre.0.ZOO\">kurre</a>\n\n2. (figure) Ame interparoli: <i>... kaj kverantaj voĉoj de ridetantaj junulinoj... Junaj voĉoj kveradas kaj flustradas,....</i>"
        let kveri = Vorto(titolo: "kver/i", teksto: kveriTeksto, marko: "kver.0i", ofc: nil)
        
        XCTAssertEqual(kveri.titolo, "kver/i")
        XCTAssertEqual(kveri.teksto, kveriTeksto)
        XCTAssertEqual(kveri.marko, "kver.0i")
        XCTAssertEqual(kveri.ofc, nil)
    }
}
