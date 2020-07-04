//
//  DatumbazAlirilo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 8/18/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

import ReVoModeloj

public final class VortaroDatumbazo {

    let alirilo: DatumbazAlirilo

    public init(konteksto: NSManagedObjectContext) {
        alirilo = DatumbazAlirilo(konteksto: konteksto)
    }
    
    // MARK: - Modeloserĉado
    
    public func lingvo(porKodo kodo: String) -> Lingvo? {
        if let objekto = alirilo.lingvo(porKodo: kodo) {
            return Lingvo.elDatumbazObjekto(objekto)
        }
        return nil
    }
    
    public func fako(porKodo kodo: String) -> Fako? {
        if let objekto = alirilo.fako(porKodo: kodo) {
            return Fako.elDatumbazObjekto(objekto)
        }
        return nil
    }
    
    public func artikolo(porIndekso indekso: String) -> Artikolo? {
        if let objekto = alirilo.artikolo(porIndekso: indekso) {
            return Artikolo.elDatumbazObjekto(objekto: objekto, datumbazo: self)
        }
        
        return nil
    }

    public func iuAjnArtikolo() -> Artikolo? {
        if let objekto = alirilo.iuAjnArtikolo() {
            return Artikolo.elDatumbazObjekto(objekto: objekto, datumbazo: self)
        }
        
        return nil
    }
    
    // MARK: - Klasoj de modeloj
    
    public func fakVortoj(porFako kodo: String) -> [Destino] {
        alirilo.fakVortoj(porFako: kodo)?.compactMap { objekto in
            Destino.elDatumbazObjekto(objekto, datumbazo: self)
        } ?? []
    }
    
    // MARK: - Chiuj modeloj
    
    public func chiujLingvoj() -> [Lingvo] {
        alirilo.chiujLingvoj().compactMap { objekto in
            Lingvo.elDatumbazObjekto(objekto)
        }
    }
    
    public func chiujFakoj() -> [Fako] {
        alirilo.chiujFakoj().compactMap { objekto in
            Fako.elDatumbazObjekto(objekto)
        }
    }
    
    public func chiujStiloj() -> [Stilo]? {
        alirilo.chiujStiloj().compactMap { objekto in
            Stilo.elDatumbazObjekto(objekto)
        }
    }
    
    public func chiujMallongigoj() -> [Mallongigo]? {
        alirilo.chiujMallongigoj().compactMap { objekto in
            Mallongigo.elDatumbazObjekto(objekto)
        }
    }
    
    // MARK: - Trie-serĉado
    
    public func serchi(lingvoKodo: String, teksto: String, komenco: Int? = 0, limo: Int) -> SerchStato {
        let internaStato = alirilo.serchi(lingvoKodo: lingvoKodo, teksto: teksto, komenco: komenco, limo: limo)
        return SerchStato(internaStato: internaStato, datumbazo: self)
    }
    
    public func serchi(komencaStato stato: SerchStato, limo: Int) -> SerchStato {
        let komencaInternaStato = SerchStatoInterna(peto: stato.peto,
                                                    iterator: stato.iterator,
                                                    rezultoj: [],
                                                    atingisFinon: stato.atingisFinon)
        let novaInternaStato = alirilo.serchi(komencaStato: komencaInternaStato, limo: limo)
        let novajDestinoj = novaInternaStato.rezultoj.map { rezulto in
           (
               rezulto.0,
               rezulto.1.compactMap {
                   Destino.elDatumbazObjekto($0, datumbazo: self)
               }
           )
        }
        var novaEksteraStato = SerchStato(internaStato: novaInternaStato, datumbazo: self)
        novaEksteraStato.rezultoj.append(contentsOf: novajDestinoj)
        return novaEksteraStato
    }
}
