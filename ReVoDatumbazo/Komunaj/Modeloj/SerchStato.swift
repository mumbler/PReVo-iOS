//
//  SerchStato.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

#if os(iOS)
import ReVoModeloj
#elseif os(macOS)
import ReVoModelojOSX
#endif

public struct SerchStato {
    internal var iterator: TrieIterator
    public var rezultoj: [(String, [Destino])]
    public var peto: String
    public var atingisFinon: Bool
}
