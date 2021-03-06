//
//  Paghmotoro.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/6/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

final class PaghMotoro {
    
    public static let komuna = PaghMotoro()
    
    var paghoj = [Pagho: UIViewController]()
    
    public func ViewControllerPorPagho(paghTipo: Pagho) -> UIViewController {

        if let trovitaPagho = paghoj[paghTipo] {
            return trovitaPagho
        }
        else {
            
            let novaPagho: UIViewController
            
            switch paghTipo {
            case .Serchi:
                novaPagho = SerchPaghoViewController()
                break
            case .Esplori:
                novaPagho = EsplorPaghoViewController(style: .grouped)
                break
            case .Historio:
                novaPagho = HistorioViewController()
                break
            case .Konservitaj:
                novaPagho = KonservitajViewController()
                break
            case .Agordoj:
                novaPagho = AgordojViewController()
                break
            case .Informoj:
                novaPagho = InformojTableViewController(style: .grouped)
                break
            }
            
            paghoj[paghTipo] = novaPagho
            return novaPagho
        }
    }
}
