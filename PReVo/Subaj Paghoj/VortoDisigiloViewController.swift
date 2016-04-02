//
//  VortoDisigiloViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/31/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let disigiloChelIdent = "vortoDisigiloChelo"

class VortoDisigiloTableViewCell : UITableViewCell {
    
}

class VortoDisigiloViewController : UIViewController, Stilplena {

    var destinoj: [NSManagedObject]
    @IBOutlet var vortoTabelo: UITableView?
    
    init(endestinoj: [NSManagedObject]) {
        destinoj = endestinoj
        super.init(nibName: "VortoDisigiloViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        destinoj = [NSManagedObject]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        title = (destinoj.first?.valueForKey("teksto") as? String) ?? "disigilo"
        vortoTabelo?.delegate = self
        vortoTabelo?.dataSource = self
        vortoTabelo?.registerClass(VortoDisigiloTableViewCell.self, forCellReuseIdentifier: disigiloChelIdent)
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        vortoTabelo?.reloadData()
    }
    
    func devasMontriSencon(indexPath: NSIndexPath) -> Bool {
        
        if (destinoj[indexPath.row].valueForKey("senco") as? String) == "0" {
            return false
        }
        
        return true
    }
    
}

extension VortoDisigiloViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return destinoj.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let chelo = UITableViewCell(style: .Value1, reuseIdentifier: disigiloChelIdent)
        
        chelo.textLabel?.text = (destinoj[indexPath.row].valueForKey("teksto") as? String) ?? ""
        chelo.detailTextLabel?.text = (destinoj[indexPath.row].valueForKey("nomo") as? String) ?? ""
        if devasMontriSencon(indexPath), let senco = destinoj[indexPath.row].valueForKey("senco") as? String {
            chelo.detailTextLabel?.text = (chelo.detailTextLabel?.text ?? "") + " " + senco
        }
        
        return chelo
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let artikolObjekto = destinoj[indexPath.row].valueForKey("artikolo") as? NSManagedObject {
            if let artikolo = Artikolo(objekto: artikolObjekto) {
                
                if let marko = destinoj[indexPath.row].valueForKey("marko") as? String where !marko.isEmpty {
                    (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo, marko: marko)
                } else {
                    (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo)
                }
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
