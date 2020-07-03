//
//  Vorto+Helpiloj.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/3/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import ReVoModeloj

extension Vorto {
    
    // Titolo de vorto, havanta indikilon de oficialeco
    var kunaTitolo: String {
        if let verOfc = ofc {
            return titolo + Iloj.superLit(verOfc)
        } else {
            return titolo
        }
    }
}
