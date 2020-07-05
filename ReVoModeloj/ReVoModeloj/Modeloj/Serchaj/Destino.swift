//
//  Destino.swift
//  ReVoModeloj
//
//  Created by Robin Hill on 7/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation

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

// MARK: - Equatable

extension Destino: Equatable {
    public static func ==(lhs: Destino, rhs: Destino) -> Bool {
        return lhs.indekso == rhs.indekso &&
            lhs.marko == rhs.marko &&
            lhs.nomo == rhs.nomo &&
            lhs.senco == rhs.senco &&
            lhs.teksto == rhs.teksto
    }
}

// MARK: - Comparable

extension Destino: Comparable {
    public static func < (lhs: Destino, rhs: Destino) -> Bool {
        return lhs.nomo.compare(rhs.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
    }
}
