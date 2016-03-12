//
//  ArtikoloViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

let artikolChelIdent = "artikolaChelo"
let artikolKapIdent  = "artikolaKapo"
let artikolPiedIdent = "artikolaPiedo"

class ArtikoloViewController : UIViewController {
    
    @IBOutlet var vortTabelo: UITableView?
    var artikolo: Artikolo? = nil
    var tradukListo: [Traduko]? = nil
    var konservitaMarko: String? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init?(enartikolo: Artikolo) {
    
        super.init(nibName: nil, bundle: nil)
        artikolo = enartikolo
    }
    
    init?(enartikolo: Artikolo, enmarko: String) {
        super.init(nibName: nil, bundle: nil)
        artikolo = enartikolo
        konservitaMarko = enmarko
    }
    
    override func viewDidLoad() {

        prepariTradukListon()
        if let veraArtikolo = artikolo {
            UzantDatumaro.visitisPaghon(Listero(veraArtikolo.titolo, veraArtikolo.indekso))
        }
        
        title = artikolo?.titolo
        
        vortTabelo?.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        vortTabelo?.delegate = self
        vortTabelo?.dataSource = self
        vortTabelo?.registerNib(UINib(nibName: "ArtikoloTableViewCell", bundle: nil), forCellReuseIdentifier: artikolChelIdent)
        vortTabelo?.registerNib(UINib(nibName: "ArtikoloKapoTableViewHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: artikolKapIdent)
        vortTabelo?.registerNib(UINib(nibName: "ArtikoloPiedButonoTableViewHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: artikolPiedIdent)
        vortTabelo?.reloadData()
        
        if konservitaMarko != nil {
            iriAlMarko(konservitaMarko!, animacii: false)
        }
    }
    
    func prepariTradukListon() {

        tradukListo = [Traduko]()
        
        for traduko in artikolo?.tradukoj ?? [] {
            if UzantDatumaro.tradukLingvoj.contains(traduko.lingvo) {
                tradukListo?.append(traduko)
            }
        }
        
        tradukListo?.sortInPlace({ (unua: Traduko, dua: Traduko) -> Bool in
            return unua.lingvo.nomo < dua.lingvo.nomo
        })
    }
    
    func iriAlMarko(marko: String, animacii: Bool) {
        
        var sumo = 0
        for grupo in artikolo?.grupoj ?? [] {
            
            if artikolo?.grupoj.count > 1 { sumo += 1 }
            
            for vorto in grupo.vortoj {
                
                if vorto.marko == marko {
                    
                    vortTabelo?.scrollToRowAtIndexPath(NSIndexPath(forRow: sumo, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: animacii)
                    return
                }
                
                sumo += 1
            }
        }
    }
    
    func premisPliajnTradukojnButonon() {
        
        let navigaciilo = HelpaNavigationController()
        let elektilo = TradukLingvojElektiloViewController()
        elektilo.delegate = self
        navigaciilo.viewControllers.append(elektilo)
        navigationController?.presentViewController(navigaciilo, animated: true, completion: nil)
    }
}

extension ArtikoloViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        let tradukSumo = artikolo?.tradukoj.count ?? 0, videblaSumo = tradukListo?.count ?? 0
        return 1 + ((videblaSumo > 0 || tradukSumo - videblaSumo > 0) ? 1 : 0)
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
            
            if artikolo?.grupoj.count == 1 {
                if let vorto = artikolo?.grupoj.first?.vortoj[indexPath.row] {
                    novaChelo.prepari(titolo: vorto.titolo, teksto: vorto.teksto)
                }
            } else {
                
                var sumo = 0
                for grupo in artikolo!.grupoj {
                    
                    if sumo == indexPath.row {
                        novaChelo.prepari(titolo: "", teksto: grupo.teksto)
                        break
                    }
                    else if indexPath.row < sumo + grupo.vortoj.count + 1 {
                        let vorto = grupo.vortoj[indexPath.row - sumo - 1]
                        novaChelo.prepari(titolo: vorto.titolo, teksto: vorto.teksto)
                        break
                    }
                    
                    sumo += grupo.vortoj.count + 1
                }
            }
        } else if indexPath.section == 1 {
            
            if let traduko = tradukListo?[indexPath.row] {
                
                novaChelo.prepari(titolo: traduko.lingvo.nomo, teksto: traduko.teksto)
            }
        }
        
        novaChelo.chefaEtikedo?.delegate = self
        
        return novaChelo
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }
        
        let novaKapo: ArtikoloKapoTableViewHeaderFooterView
        if let trovKapo = vortTabelo?.dequeueReusableHeaderFooterViewWithIdentifier(artikolKapIdent) as? ArtikoloKapoTableViewHeaderFooterView {
            novaKapo = trovKapo
        } else {
            novaKapo = ArtikoloKapoTableViewHeaderFooterView()
        }
        
        if section == 1 {
            novaKapo.etikedo?.text = "Tradukoj"
        }
        
        return novaKapo
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 1 && artikolo?.tradukoj.count > 0 {
            
            let novaPiedo: ArtikoloPiedButonoTableViewHeaderFooterView
            if let trovPiedo = vortTabelo?.dequeueReusableHeaderFooterViewWithIdentifier(artikolPiedIdent) as? ArtikoloPiedButonoTableViewHeaderFooterView {
                novaPiedo = trovPiedo
            } else {
                novaPiedo = ArtikoloPiedButonoTableViewHeaderFooterView()
            }
            
            novaPiedo.prepari()
            novaPiedo.butono?.addTarget(self, action: "premisPliajnTradukojnButonon", forControlEvents: UIControlEvents.PrimaryActionTriggered)
            
            return novaPiedo
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            return NSLocalizedString("artikolo tradukoj etikedo", comment: "")
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 1
        }
    
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return 50
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
}

extension ArtikoloViewController : TradukLingvojElektiloDelegate {
    
    func elektisTradukLingvojn() {
        
        prepariTradukListon()
        vortTabelo?.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Fade)
        vortTabelo?.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
}

extension ArtikoloViewController : TTTAttributedLabelDelegate {
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        
        let marko = url.absoluteString
        let partoj = marko.componentsSeparatedByString(".")
        
        if partoj.count == 0 {
            return
        }
        
        if partoj[0] == artikolo?.indekso {
            if partoj.count >= 2 {
                iriAlMarko(partoj[0] + "." + partoj[1], animacii: true)
            }
        } else {
            if let novaArtikolo = SeancDatumaro.artikoloPorIndekso(partoj[0]),
               let novaPagho = ArtikoloViewController(enartikolo: novaArtikolo) {
                navigationController?.pushViewController(novaPagho, animated: true)
            }
        }
    }
}
