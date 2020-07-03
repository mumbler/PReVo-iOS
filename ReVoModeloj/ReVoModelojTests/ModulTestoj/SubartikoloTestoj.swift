//
//  SubartikoloTestoj.swift
//  PoshReVoUnuopTestoj
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import XCTest

@testable import ReVoModeloj

final class SubartikoloTestoj: XCTestCase {
    
    func testKreiSubartikolon() {
        let ranoTeksto = "1. (komune) Iu el <a href=\"raned.0oj\">ranedoj</a>; <a href=\"amfibi.0o\">amfibio</a>, senvostulo kun horizontalaj pupiloj kaj dentoj: <i>kie ajn rano iras, ĝi ĉiam marĉon sopiras;</i> <i>eksvarmos la rivero per ranoj;</i> <i>la rano kvakis tiel timeme, kvazaŭ ĝi volus elpetegi de ŝi kompaton.</i> ➞ <a href=\"buf.0o\">bufo</a>\n\n2. [ZOO] <a href=\"genr.0o.BIO\">Genro</a> el la familio <a href=\"raned.0oj\">ranedoj</a> (<i>Rana</i>): <i>la eŭropa hilo estas la plej rara rano en Litovio.</i>"
        let ranaTeksto = "Rilata al rano: <i>rana haŭto;</i> <i>ŝi konforme al sia rana naturo subakviĝadis kaj poste leviĝadis returne supren.</i>"

        let rano = Vorto(titolo: "ran/o", teksto: ranoTeksto, marko: "ran.0o", ofc: "*")
        let rana = Vorto(titolo: "ran/a", teksto: ranaTeksto, marko: "ran.0a", ofc: nil)
        
        let subartikolo = Subartikolo(teksto: "", vortoj: [rano, rana])
        XCTAssertEqual(subartikolo.teksto, "")
        XCTAssertEqual(subartikolo.vortoj, [rano, rana])
    }
}

extension Vorto: Equatable {
    public static func ==(lhs: Vorto, rhs: Vorto) -> Bool {
        return lhs.titolo == rhs.titolo
            && lhs.teksto == rhs.teksto
            && lhs.marko == rhs.marko
            && lhs.ofc == rhs.ofc
    }
}
