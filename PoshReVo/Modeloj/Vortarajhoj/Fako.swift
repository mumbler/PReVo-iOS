//
//  Fako.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Sinuous Rill. All rights reserved.
//

import Foundation

/*
    Reprezentas fakon al kiu apartenas vorto aŭ frazaĵo. Uzataj en kelkaj difinoj.
 */
struct Fako {
    
    let kodo: String, nomo: String
    
    init(_ enkodo: String, _ ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
}
