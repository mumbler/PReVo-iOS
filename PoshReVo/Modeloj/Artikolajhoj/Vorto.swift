//
//  Vorto.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Sinuous Rill. All rights reserved.
//

import Foundation

/*
    Reprezentas unu aŭ pluraj vortoj havanta unu saman difinon.
*/
struct Vorto {
    
    let titolo: String, teksto: String, marko: String?, ofc: String?
    
    var kunaTitolo: String {
        if let verOfc = ofc {
            return titolo + Iloj.superLit(verOfc)
        } else {
            return titolo
        }
    }
}
