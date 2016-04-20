//
//  SerchPaghoViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let serchChelIdent = "serchRezultoChelo"
let serchLimo = 32

/*
    Pagho por serchi vortojn en la vortaro
*/
class SerchPaghoViewController : UIViewController, Chefpagho, Stilplena {
    
    @IBOutlet var serchTabulo: UISearchBar?
    @IBOutlet var trovTabelo: UITableView?
    var lastaSercho: (Lingvo, String)? = nil
    var serchRezultoj = [(String, [NSManagedObject])]()
    
    init() {
        super.init(nibName: "SerchPaghoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        serchTabulo?.delegate = self
        serchTabulo?.placeholder = NSLocalizedString("serchi tabulo teksto", comment: "")
        serchTabulo?.isAccessibilityElement = true
        serchTabulo?.accessibilityLabel = serchTabulo?.placeholder
        
        trovTabelo?.delegate = self
        trovTabelo?.dataSource = self
        trovTabelo?.registerClass(UITableViewCell.self, forCellReuseIdentifier: serchChelIdent)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didChangePreferredContentSize(_:)), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        efektivigiStilon()
    }

    func aranghiNavigaciilo() {
        
        ghisdatigiTitolon()
        prepariNavigaciajnButonojn()
    }
    
    func efektivigiStilon() {
        
        serchTabulo?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        serchTabulo?.barStyle = UzantDatumaro.stilo.serchTabuloKoloro
        serchTabulo?.keyboardAppearance = UzantDatumaro.stilo.klavaroKoloro
        serchTabulo?.tintColor = UzantDatumaro.stilo.tintKoloro
        
        trovTabelo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        trovTabelo?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        trovTabelo?.separatorColor = UzantDatumaro.stilo.apartigiloKoloro
        trovTabelo?.reloadData()
    }
    
    func ghisdatigiTitolon() {
        
        if UzantDatumaro.serchLingvo.kodo.characters.count > 0 {
            parentViewController?.title = String(format: NSLocalizedString("serchi lingva titolo", comment: ""), arguments: [UzantDatumaro.serchLingvo.nomo])
        } else {
            parentViewController?.title = NSLocalizedString("serchi baza titolo", comment: "")
        }
    }
    
    func prepariNavigaciajnButonojn() {
        
        let butonujo = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))

        let elektiloButono = UIButton()
        elektiloButono.setImage(UIImage(named: "pikto_traduko")?.imageWithRenderingMode(.AlwaysTemplate), forState: UIControlState.Normal)
        elektiloButono.tintColor = UzantDatumaro.stilo.navTintKoloro
        elektiloButono.addTarget(self, action: #selector(elektiLingvon), forControlEvents: .TouchUpInside)
        
        let lastaButono = UIButton(type: UIButtonType.System)
        if UzantDatumaro.oftajSerchLingvoj.count > 1 {
            let lastaKodo = UzantDatumaro.oftajSerchLingvoj[1].kodo ?? ""
            lastaButono.setTitle(lastaKodo, forState: UIControlState.Normal)
            lastaButono.titleLabel?.textColor = UzantDatumaro.stilo.navTintKoloro
            lastaButono.titleLabel?.font = UIFont.boldSystemFontOfSize(18.0)
            lastaButono.tintColor = UzantDatumaro.stilo.navTintKoloro
            lastaButono.addTarget(self, action: #selector(uziLastanLingvon), forControlEvents: .TouchUpInside)
        }
        
        butonujo.addSubview(lastaButono)
        butonujo.addSubview(elektiloButono)
        elektiloButono.frame = CGRect(x: 40, y: 0, width: 30, height: 30)
        lastaButono.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        parentViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: butonujo)
    }
    
    func elektiLingvon() {
        
        let navigaciilo = HelpaNavigationController()
        let elektilo = SerchLingvoElektiloViewController()
        elektilo.delegate = self
        navigaciilo.viewControllers.append(elektilo)
        self.navigationController?.presentViewController(navigaciilo, animated: true, completion: nil)
    }
    
    func uziLastanLingvon() {
        if UzantDatumaro.oftajSerchLingvoj.count > 1 {
            let lasta = UzantDatumaro.oftajSerchLingvoj[1]
            UzantDatumaro.elektisSerchLingvon(lasta)
            elektisSerchLingvon()
        }
    }
    
    func fariSerchon(teksto: String) {
        if UzantDatumaro.serchLingvo != lastaSercho?.0 || teksto != lastaSercho?.1 {
            serchRezultoj = TrieRegilo.serchi(UzantDatumaro.serchLingvo.kodo, teksto: teksto, limo: serchLimo)
            trovTabelo?.reloadData()
            lastaSercho = (UzantDatumaro.serchLingvo, teksto)
        }
    }
}

extension SerchPaghoViewController : UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        var teksto = searchBar.text
        if UzantDatumaro.serchLingvo == SeancDatumaro.esperantaLingvo() && text == "x" && teksto?.characters.count > 0 {
            
            let lasta = teksto?[teksto!.endIndex.advancedBy(-1)]
            if let chapeligita = Iloj.chapeligi(lasta!) {
                teksto = teksto!.substringToIndex(teksto!.endIndex.advancedBy(-1)) + String(chapeligita)
            }
            
            searchBar.text = teksto!
            self.searchBar(searchBar, textDidChange: teksto!)
            return false
        }
        
        // Chi tiu abomenajho necesas char japanaj klavaroj ne kauzas textDidChange, kaj la fina teksto ne disponeblas chi tie
        // Espereble Apple riparos tion estontece
        if teksto != nil {
            weak var malforta = self
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                if let vera = malforta {
                    vera.fariSerchon(vera.serchTabulo?.text! ?? "")
                }
            });
        }
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.text = searchBar.text?.lowercaseString
        if let teksto = searchBar.text {
            
            if !teksto.isEmpty {
                fariSerchon(teksto)
            } else {
                serchRezultoj.removeAll()
                trovTabelo?.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
}

// Trakti tabelon
extension SerchPaghoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return serchRezultoj.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let novaChelo = UITableViewCell(style: .Value1, reuseIdentifier: serchChelIdent)
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        novaChelo.textLabel?.text = serchRezultoj[indexPath.row].0
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text

        if UzantDatumaro.serchLingvo != SeancDatumaro.esperantaLingvo() {
            novaChelo.detailTextLabel?.text = tekstoPorDestinoj(serchRezultoj[indexPath.row].1)
        }
        
        return novaChelo
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if serchRezultoj[indexPath.row].1.count == 1 {
            if let artikolObjekto = serchRezultoj[indexPath.row].1.first?.valueForKey("artikolo") as? NSManagedObject {
                if let artikolo = Artikolo(objekto: artikolObjekto) {
                    
                    parentViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("serchi baza titolo", comment: ""), style: .Plain, target: nil, action: nil)
                    if let marko = serchRezultoj[indexPath.row].1.first?.valueForKey("marko") as? String where !marko.isEmpty {
                        (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo, marko: marko)
                    } else {
                        (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo)
                    }
                }
            }
        } else {
            let disigilo = VortoDisigiloViewController(endestinoj: serchRezultoj[indexPath.row].1)
            navigationController?.pushViewController(disigilo, animated: true)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// Trakti lingvo-elektadon
extension SerchPaghoViewController : SerchLingvoElektiloDelegate {
    
    func elektisSerchLingvon() {
        ghisdatigiTitolon()
        prepariNavigaciajnButonojn()
        fariSerchon(serchTabulo?.text ?? "")
    }
}

// Helpaj aferoj
extension SerchPaghoViewController {
    
    func tekstoPorDestinoj(destinoj: [NSManagedObject]) -> String {
        
        var bonaNomo: String = ""
        if destinoj.count == 1 {
            bonaNomo = (destinoj.first?.valueForKey("nomo") as? String)?.componentsSeparatedByString(", ").first ?? ""
            if let senco = destinoj.first?.valueForKey("senco") as? String where senco != "0" {
                bonaNomo += " (" + senco + ")"
            }
            return bonaNomo
        } else {
            return String(destinoj.count) + " trovoj"
        }
    }
}

// Respondi al mediaj shanghoj
extension SerchPaghoViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        trovTabelo?.reloadData()
    }
}
