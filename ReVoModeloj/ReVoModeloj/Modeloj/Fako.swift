//
//  Fako.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation

/*
    Reprezentas fakon al kiu apartenas vorto aŭ frazaĵo. Uzataj en kelkaj difinoj.
 */
public struct Fako {
    public let kodo: String
    public let nomo: String
    
    public init(kodo: String, nomo: String) {
        self.kodo = kodo
        self.nomo = nomo
    }
}
