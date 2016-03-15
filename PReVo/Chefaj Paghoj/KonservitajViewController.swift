//
//  KonservitajViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit

let konservitajChelIdent = "konservitajChelo"

/*
    Pagho por vidi konservitaj artikoloj
*/
class KonservitajViewController : UIViewController, Chefpagho, Stilplena {
    
    @IBOutlet var vortoTabelo: UITableView?
    
    override func viewDidLoad() {
        
        vortoTabelo?.delegate = self
        vortoTabelo?.dataSource = self
        vortoTabelo?.registerClass(UITableViewCell.self, forCellReuseIdentifier: konservitajChelIdent)
    }
    
    override func viewWillAppear(animated: Bool) {
        efektivigiStilon()
    }
    
    func aranghiNavigaciilo() {
        parentViewController?.title = NSLocalizedString("konservitaj titolo", comment: "")
        parentViewController?.navigationItem.rightBarButtonItem = nil
    }
    
    func efektivigiStilon() {
        
        vortoTabelo?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        vortoTabelo?.reloadData()
    }
}

extension KonservitajViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UzantDatumaro.konservitaj.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let novaChelo: UITableViewCell
        if let trovChelo = vortoTabelo?.dequeueReusableCellWithIdentifier(konservitajChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        novaChelo.textLabel?.text = UzantDatumaro.konservitaj[indexPath.row].nomo
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text
        
        return novaChelo
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indekso = UzantDatumaro.konservitaj[indexPath.row].indekso
        if let artikolo = SeancDatumaro.artikoloPorIndekso(indekso) {
            (navigationController as? ChefaNavigationController)?.montriArtikolon( artikolo )
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
