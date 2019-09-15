//
//  InformoTableViewController.swift.swift
//  PoshReVo
//
//  Created by Robin Hill on 8/8/19.
//  Copyright © 2019 Sinuous Rill. All rights reserved.
//

import UIKit

final class InformoTableViewController: BazStilaTableViewController, Chefpagho {
    
    private enum Sekcio{
        case ReVo, PoshReVo
        
        public static func deNumero(_ numero: Int) -> Sekcio {
            switch numero {
            case 0:
                return .ReVo
            case 1:
                return .PoshReVo
            default:
                fatalError("Sekcio ne validas")
            }
        }
        
        public func chelKvanto() -> Int {
            switch self {
            case .ReVo:
                return 3
            case .PoshReVo:
                return 1
            }
        }
        
        public func titolo(numero: Int) -> String {
            
            var titoloj = [String]()
            
            switch self {
            case .ReVo:
                titoloj = [
                    NSLocalizedString("informo revo titolo", comment: ""),
                    NSLocalizedString("informo vortaraj-mallongigoj titolo", comment: ""),
                    NSLocalizedString("informo fakaj-mallongigoj titolo", comment: "")
                ]
            case .PoshReVo:
                titoloj = [NSLocalizedString("informo poshrevo titolo", comment: "")]
            }
            
            return titoloj[numero]
        }
        
        public func teksto(numero: Int) -> String {
            
            var tekstoj = [String]()
            
            switch self {
            case .ReVo:
                tekstoj = [
                    NSLocalizedString("informo revo teksto", comment: ""),
                    Bundle.main.localizedString(forKey: "informo vortaraj-mallongigoj teksto", value: nil, table: "Generataj"),
                    Bundle.main.localizedString(forKey: "informo fakaj-mallongigoj teksto", value: nil, table: "Generataj")
                ]
            case .PoshReVo:
                let versioTeksto = String(format: NSLocalizedString("informo versio", comment: ""), arguments: [ (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "" ])
                tekstoj = [
                    String(format: NSLocalizedString("informo poshrevo teksto", comment: ""), versioTeksto)
                ]
            }
            
            return tekstoj[numero]
        }
        
        public func destino(numero: Int) -> InformoPaghoViewController {
            
            let pagho = InformoPaghoViewController(titolo: titolo(numero: numero), teksto: teksto(numero: numero))
            return pagho
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        efektivigiStilon()
    }
    
    // UITableViewDelegate + UITableViewDatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sekcio = Sekcio.deNumero(section)
        return sekcio.chelKvanto()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chelo = tableView.dequeueReusableCell(withIdentifier: "chelo") ?? UITableViewCell()
        
        let sekcio = Sekcio.deNumero(indexPath.section)
        chelo.textLabel?.text = sekcio.titolo(numero: indexPath.row)
        chelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        chelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        return chelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sekcio = Sekcio.deNumero(indexPath.section)
        let destino = sekcio.destino(numero: indexPath.row)
        
        navigationController?.pushViewController(destino, animated: true)
    }
    
    // MARK: Chefpagho
    
    func aranghiNavigaciilo() {
        parent?.title = NSLocalizedString("informo titolo", comment: "")
        parent?.navigationItem.rightBarButtonItem = nil
    }
}
