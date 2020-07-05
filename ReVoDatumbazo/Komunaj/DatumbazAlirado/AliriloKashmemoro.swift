//
//  AliriloKashMemoro.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/3/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import ReVoModeloj

struct AliriloKashMemorero<K> {
    var kompleta: Bool
    var enhavoj: [K]
    
    init() {
        kompleta = false
        enhavoj = []
    }
}

struct AliriloKashMemoro {
    static var lingvoj = AliriloKashMemorero<Lingvo>()
    static var fakoj = AliriloKashMemorero<Fako>()
    static var stiloj = AliriloKashMemorero<Stilo>()
    static var mallongigoj = AliriloKashMemorero<Mallongigo>()
}
