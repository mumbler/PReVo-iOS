//
//  PoshReVoEkranKopiilo.swift
//  PoshReVoEkranKopiilo
//
//  Created by Robin Hill on 5/1/20.
//  Copyright © 2020 Sinuous Rill. All rights reserved.
//

import XCTest

class PoshReVoEkranKopiilo: XCTestCase {

    var unuaFojo = true
    
    override func setUp() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {}
    
    // Ekrankopiado
    
    func testSerchEkranon() {
        let app = XCUIApplication()
        app.searchFields["serchTabulaTekstejo"].tap()
        app.searchFields["serchTabulaTekstejo"].typeText("vort")
        app.buttons["done"].tap()
        snapshot("sercho")
    }
    
    func testArtikolon() {
        let app = XCUIApplication()
        app.searchFields["serchTabulaTekstejo"].tap()
        app.searchFields["serchTabulaTekstejo"].typeText("esperanto")
        app.staticTexts["Esperanto"].tap()
        snapshot("artikolo")
    }
    
    func testTradukojn() {
        let app = XCUIApplication()
        app.searchFields["serchTabulaTekstejo"].tap()
        app.searchFields["serchTabulaTekstejo"].typeText("unu")
        app.staticTexts["unu"].tap()
        
        let window = app.windows.element(boundBy: 0)
        let butono = app.tables.element.cells["japana,<a href=\"unu.0\">~</a>: 一 [いち]."]
        while butono.frame.maxY > window.frame.height /*!butono.exists*/ {
            app.swipeUp()
        }
        snapshot("tradukoj")
    }
    
    func testElektiSerchLingvon() {
        let app = XCUIApplication()
        app.buttons["elekti lingvon"].tap()
        snapshot("lingvoelektilo")
    }
}
