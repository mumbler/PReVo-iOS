//
//  FakVortoListoTableViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 9/1/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import CoreData
import Foundation
import ReVoDatumbazo

final class FakVortoListoTableViewController: BazStilaTableViewController {
    
    private let chelIdentigilo = "fakVortoChelo"
    
    private let fako: Fako
    private let vortoj: [NSManagedObject]
    
    init(_ fako: Fako) {
        self.fako = fako
        vortoj = DatumbazAlirilo.komuna.fakVortojPorFako(fako.kodo) ?? []
        super.init(style: .plain)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Ne kreu FakVortoListoTableViewController tiel")
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension FakVortoListoTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: chelIdentigilo)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vortoj.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chelo = tableView.dequeueReusableCell(withIdentifier: chelIdentigilo) ?? UITableViewCell()
        let vortObjekto = vortoj[indexPath.row]
        
        let nomo = vortObjekto.value(forKey: "nomo") as? String
        chelo.textLabel?.text = nomo
        
        chelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        chelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        return chelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vortObjekto = vortoj[indexPath.row]
        
        if let artikolObjekto = vortObjekto.value(forKey: "artikolo") as? NSManagedObject {
            if let artikolo = Artikolo(objekto: artikolObjekto) {
                
                parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: fako.nomo, style: .plain, target: nil, action: nil)
                if let marko = vortObjekto.value(forKey: "marko") as? String, !marko.isEmpty {
                    (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo, marko: marko)
                } else {
                    (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo)
                }
            }
        }
    }
}
