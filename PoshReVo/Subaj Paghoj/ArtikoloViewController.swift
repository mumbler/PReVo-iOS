//
//  ArtikoloViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

let artikolChelIdent = "artikolaChelo"
let artikolKapIdent  = "artikolaKapo"
let artikolPiedIdent = "artikolaPiedo"

/*
    Pagho kiu montras la artikolojn kun difinoj kaj tradukoj
*/
class ArtikoloViewController : UIViewController, Stilplena {
    
    @IBOutlet var vortTabelo: UITableView?
    var artikolo: Artikolo? = nil
    var tradukListo: [Traduko]? = nil
    var konservitaMarko: String? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init?(enartikolo: Artikolo) {
    
        super.init(nibName: "ArtikoloViewController", bundle: nil)
        artikolo = enartikolo
    }
    
    init?(enartikolo: Artikolo, enmarko: String) {
        super.init(nibName: "ArtikoloViewController", bundle: nil)
        artikolo = enartikolo
        konservitaMarko = enmarko
    }
    
    override func viewDidLoad() {

        prepariTradukListon()
        prepariNavigaciajnButonojn()
        
        title = (artikolo?.titolo ?? "") + Iloj.superLit((artikolo?.ofc ?? ""))
        
        vortTabelo?.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        vortTabelo?.delegate = self
        vortTabelo?.dataSource = self
        vortTabelo?.registerNib(UINib(nibName: "ArtikoloTableViewCell", bundle: nil), forCellReuseIdentifier: artikolChelIdent)
        vortTabelo?.registerNib(UINib(nibName: "ArtikoloKapoTableViewHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: artikolKapIdent)
        vortTabelo?.registerNib(UINib(nibName: "ArtikoloPiedButonoTableViewHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: artikolPiedIdent)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didChangePreferredContentSize(_:)), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        efektivigiStilon()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if konservitaMarko != nil {
            weak var malforta = self
            dispatch_async(dispatch_get_main_queue() , {
                malforta?.iriAlMarko(malforta?.konservitaMarko ?? "", animacii: false)
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let veraArtikolo = artikolo {
            UzantDatumaro.visitisPaghon(Listero(veraArtikolo.titolo, veraArtikolo.indekso))
        }
    }
    
    func efektivigiStilon() {
        
        navigationController?.navigationBar.tintColor = UzantDatumaro.stilo.navTintKoloro
        vortTabelo?.backgroundColor = UzantDatumaro.stilo.fonKoloro
        vortTabelo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        vortTabelo?.reloadData()
    }
    
    func prepariNavigaciajnButonojn() {
        
        // Por meti du butonoj malproksime unu al la alia, oni devas krei UIView kiu enhavas
        // du UIButton-ojn, kaj uzi tion kiel la vera rightBarButtonItem
        
        let butonujo = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        
        // Elekti plena stelo se la artikolo estas konservia, alie la malplena
        let bildo = UzantDatumaro.konservitaj.contains { (nuna: Listero) -> Bool in
            return nuna.indekso == artikolo?.indekso
            } ? UIImage(named: "pikto_stelo_plena") : UIImage(named: "pikto_stelo")
        let konservButono = UIButton()
        konservButono.tintColor = UzantDatumaro.stilo.navTintKoloro
        konservButono.setImage(bildo?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        konservButono.addTarget(self, action: #selector(premisKonservButonon), forControlEvents: UIControlEvents.TouchUpInside)
        let serchButono = UIButton()
        serchButono.tintColor = UzantDatumaro.stilo.navTintKoloro
        serchButono.setImage(UIImage(named: "pikto_lenso")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        serchButono.addTarget(self, action: #selector(premisSerchButonon), forControlEvents: UIControlEvents.TouchUpInside)
        
        butonujo.addSubview(konservButono)
        butonujo.addSubview(serchButono)
        serchButono.frame = CGRect(x: 40, y: 0, width: 30, height: 30)
        konservButono.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: butonujo)
    }
    
    // Krei liston de tradukoj por montri - tiuj kiuj estas kaj en la listo de
    // tradukoj por la artikolo kaj la elektitaj traduk-lingvoj
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
    
    // Haste movi la ekranon al la dezirata vorto en la artikolo
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
    
    // Reiri al la ingo pagho kaj igi ghin montri la serch-paghon
    func premisSerchButonon() {
        
        if let ingo = (navigationController as? ChefaNavigationController)?.viewControllers.first as? IngoPaghoViewController {
            ingo.montriPaghon(Pagho.Serchi)
        }
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // Konservi au malkonservi la artikolon
    func premisKonservButonon() {
        
        UzantDatumaro.shanghiKonservitecon(Listero(artikolo!.titolo, artikolo!.indekso))
        prepariNavigaciajnButonojn()
    }
    
    // Montri la traduk-lingvoj elektilon
    func premisPliajnTradukojnButonon() {
        
        let navigaciilo = HelpaNavigationController()
        let elektilo = TradukLingvojElektiloViewController()
        elektilo.delegate = self
        navigaciilo.viewControllers.append(elektilo)
        navigationController?.presentViewController(navigaciilo, animated: true, completion: nil)
    }
    
    func premisChelon(rekonilo: UILongPressGestureRecognizer) {
        
        if let chelo = rekonilo.view as? ArtikoloTableViewCell where rekonilo.state == UIGestureRecognizerState.Began {
            let mesagho: UIAlertController = UIAlertController(title: NSLocalizedString("artikolo chelo agoj titolo", comment: ""), message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            mesagho.addAction( UIAlertAction(title: NSLocalizedString("artikolo chelo ago kopii", comment: ""), style: UIAlertActionStyle.Default, handler: { (ago: UIAlertAction) -> Void in
                let tabulo = UIPasteboard.generalPasteboard()
                tabulo.string = chelo.chefaEtikedo?.text
            }))
            mesagho.addAction( UIAlertAction(title: NSLocalizedString("Nenio", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil))
            
            if let prezentilo = mesagho.popoverPresentationController {
                prezentilo.sourceView = chelo;
                prezentilo.sourceRect = chelo.bounds;
            }
            
            presentViewController(mesagho, animated: true, completion: nil)
        }
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
            // La chelo montros difinon
            
            if artikolo?.grupoj.count == 1 {
                if let vorto = artikolo?.grupoj.first?.vortoj[indexPath.row] {
                    novaChelo.prepari(titolo: vorto.kunaTitolo, teksto: vorto.teksto, subart: false)
                }
            } else {
                
                var sumo = 0
                for grupo in artikolo!.grupoj {
                    
                    if sumo == indexPath.row {
                        novaChelo.prepari(titolo: "", teksto: grupo.teksto, subart: true)
                        break
                    }
                    else if indexPath.row < sumo + grupo.vortoj.count + 1 {
                        let vorto = grupo.vortoj[indexPath.row - sumo - 1]
                        novaChelo.prepari(titolo: vorto.kunaTitolo, teksto: vorto.teksto, subart: false)
                        break
                    }
                    
                    sumo += grupo.vortoj.count + 1
                }
            }
        } else if indexPath.section == 1 {
            // La chelo montros tradukon
            
            if let traduko = tradukListo?[indexPath.row] {
                
                novaChelo.prepari(titolo: traduko.lingvo.nomo, teksto: traduko.teksto, subart: false)
            }
        }
        
        novaChelo.chefaEtikedo?.delegate = self
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = ""
        if let titolo = novaChelo.titolaEtikedo?.text where !titolo.isEmpty {
            novaChelo.accessibilityLabel? += titolo + ", "
        }
        novaChelo.accessibilityLabel? += novaChelo.chefaEtikedo?.text ?? ""
        
        // Gesture Recognizer por kopiado
        
        for afero in novaChelo.gestureRecognizers ?? [] {
            novaChelo.removeGestureRecognizer(afero)
        }
        let rekonilo = UILongPressGestureRecognizer(target: self, action: #selector(premisChelon(_:)))
        novaChelo.addGestureRecognizer(rekonilo)
        
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
            novaKapo.prepari()
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
            novaPiedo.butono?.addTarget(self, action: #selector(premisPliajnTradukojnButonon), forControlEvents: UIControlEvents.TouchUpInside)
            
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
    
        if section == 1 {
            return UITableViewAutomaticDimension
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 1 {
            let desc = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
            return 50 + desc.pointSize - 14
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        
        if section == 1 {
            let desc = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
            return 50 + desc.pointSize - 14
        }
        
        return 0
    }

}

extension ArtikoloViewController : TradukLingvojElektiloDelegate {
    
    // Elektis traduk-lingvojn - reprezenti la tradukan sekcion de la pagho
    func elektisTradukLingvojn() {
        
        prepariTradukListon()
        vortTabelo?.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Fade)
        vortTabelo?.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
}

extension ArtikoloViewController : TTTAttributedLabelDelegate {
    
    // Uzanto premis ligilon - iri al la dezirata sekcio de la artikolo, au montri novan artikolon
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
            if let artikolo =  SeancDatumaro.artikoloPorIndekso(partoj[0]) {
                navigationItem.backBarButtonItem = UIBarButtonItem(title: self.artikolo?.titolo, style: .Plain, target: nil, action: nil)
                (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo, marko: marko)
            }
        }
    }
}

// Respondi al mediaj shanghoj
extension ArtikoloViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        vortTabelo?.reloadData()
    }
}

