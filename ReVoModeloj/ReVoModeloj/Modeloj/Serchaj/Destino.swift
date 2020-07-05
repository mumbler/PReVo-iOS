//
//  Destino.swift
//  ReVoModeloj
//
//  Created by Robin Hill on 7/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

public struct Destino {
    public let indekso: String
    public let marko: String?
    public let nomo: String
    public let senco: String?
    public let teksto: String
    
    public init(indekso: String,
                marko: String?,
                nomo: String,
                senco: String?,
                teksto: String) {
        self.indekso = indekso
        self.marko = marko
        self.nomo = nomo
        self.senco = senco
        self.teksto = teksto
    }
}
