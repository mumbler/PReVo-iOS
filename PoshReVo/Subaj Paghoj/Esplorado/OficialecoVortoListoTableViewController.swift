//
//  OficialecoVortoListoTableViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/10/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import ReVoModeloj
import ReVoDatumbazo

final class OficialecoVortoListoTableViewController: BazStilaTableViewController {
    
    private let chelIdentigilo = "oficialecoVortoChelo"
    
    private let oficialeco: String
    private let vortoj: [Artikolo]
    
    init(_ oficialeco: String) {
        self.oficialeco = oficialeco
        vortoj = VortaroDatumbazo.komuna.vortoj(oficialeco: oficialeco)
        super.init(style: .plain)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Ne kreu OficialecoVortoListoTableViewController tiel")
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension OficialecoVortoListoTableViewController {

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
        let artikolo = vortoj[indexPath.row]
        
        let nomo = artikolo.titolo
        chelo.textLabel?.text = nomo
        
        chelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        chelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        return chelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let artikolo = vortoj[indexPath.row]
        
        parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: oficialeco, style: .plain, target: nil, action: nil)
        (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo)
    }
}
