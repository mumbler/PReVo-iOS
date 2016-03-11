//
//  ArtikoloViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

let artikolChelIdent = "artikolaChelo"

class ArtikoloViewController : UIViewController {
    
    @IBOutlet var vortTabelo: UITableView?
    var artikolo: Artikolo? = nil
    var tradukListo: [Traduko]? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init?(enartikolo: Artikolo?) {
    
        super.init(nibName: nil, bundle: nil)
        
        if enartikolo == nil {
            return nil
        }
        artikolo = enartikolo
    }
    
    override func viewDidLoad() {

        prepariTradukListon()
        
        vortTabelo?.delegate = self
        vortTabelo?.dataSource = self
        vortTabelo?.registerNib(UINib(nibName: "ArtikoloTableViewCell", bundle: nil), forCellReuseIdentifier: artikolChelIdent)
        //vortTabelo?.registerClass(ArtikoloTableViewCell.self, forCellReuseIdentifier:  artikolChelIdent)
        vortTabelo?.reloadData()
    }
    
    func prepariTradukListon() {
        
        tradukListo = artikolo?.tradukoj
    }
    
}

extension ArtikoloViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let tradukSumo = artikolo?.tradukoj.count ?? 0, videblaSumo = tradukListo?.count ?? 0
        return 1 + ((videblaSumo > 0 || tradukSumo - videblaSumo > 0) ? 1 : 0)
        //return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rez = 0
        if section == 0 {
            
            for grupo in artikolo!.grupoj {
                if artikolo?.grupoj.count > 1 { rez += 1 }
                rez += grupo.vortoj.count
            }
            return rez
        } else if section == 1 {
            
            //let tradukSumo = artikolo?.tradukoj.count ?? 0, videblaSumo = tradukListo?.count ?? 0
            //rez = ((videblaSumo > 0 || tradukSumo - videblaSumo > 0) ? 1 : 0)
            rez = tradukListo?.count ?? 0
        }

        return rez
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let novaChelo: ArtikoloTableViewCell
        if let trovChelo = vortTabelo?.dequeueReusableCellWithIdentifier(artikolChelIdent) as? ArtikoloTableViewCell {
            novaChelo = trovChelo
        } else {
            novaChelo = ArtikoloTableViewCell()
        }
        
        if indexPath.section == 0 {
            var vorto: Vorto? = nil
            var loko = indexPath.row
            for grupo in artikolo!.grupoj {
                if loko > grupo.vortoj.count {
                    loko -= grupo.vortoj.count
                    if artikolo?.grupoj.count > 1 { loko -= 1 }
                } else {
                    vorto = grupo.vortoj[loko]
                    break
                }
            }
            if vorto != nil {
                novaChelo.prepari(titolo: vorto!.titolo, teksto: vorto!.teksto)
            }
        } else if indexPath.section == 1 {
            
        }
        
        return novaChelo
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}
