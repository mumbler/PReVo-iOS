//
//  ModelObjekto.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation

class Artikolo {
    
}

class Grupo {
    
}

class Vorto {
    
}

class Lingvo {
    
    let kodo: String, nomo: String
    
    init(enkodo: String, ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
}

func ==(lhs: Lingvo, rhs: Lingvo) -> Bool {
    
    return lhs.kodo == rhs.kodo
}

class Fako {
    
    let kodo: String, nomo: String
    
    init(enkodo: String, ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
}

class Uzo {
    
    let kodo: String, nomo: String
    
    init(enkodo: String, ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
}
