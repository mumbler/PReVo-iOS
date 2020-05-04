//
//  Vorto.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Sinuous Rill. All rights reserved.
//

import Foundation

/*
    Vorto reprezentas unu au pli vortoj kun sama difino.
    Ili estas la bazaj eroj de artikoloj
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
