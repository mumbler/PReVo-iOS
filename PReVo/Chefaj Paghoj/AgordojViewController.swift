//
//  AgordojViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

let agordojChelIdent = "agordaChelo"

/*
    Pagho por agordi la programon
*/
class AgordojViewController : UIViewController, Chefpagho, Stilplena {
    
    @IBOutlet var tabelo: UITableView?
    
    override func viewDidLoad() {
        
        tabelo?.delegate = self
        tabelo?.dataSource = self
        tabelo?.registerClass(UITableViewCell.self, forCellReuseIdentifier: agordojChelIdent)

        efektivigiStilon()
    }
    
    func aranghiNavigaciilo() {
        
        parentViewController?.title = NSLocalizedString("agordoj titolo", comment: "")
        parentViewController?.navigationItem.rightBarButtonItem = nil
    }
    
    func efektivigiStilon() {
        
        tabelo?.backgroundColor = UzantDatumaro.stilo.fonKoloro
        tabelo?.reloadData()
    }
    
    func nuligiHistorion() {
        let mesagho: UIAlertController = UIAlertController(title: NSLocalizedString("agordoj nuligi historion averto", comment: ""), message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        mesagho.addAction( UIAlertAction(title: NSLocalizedString("Jes", comment: ""), style: UIAlertActionStyle.Destructive, handler: { (ago: UIAlertAction) -> Void in
            UzantDatumaro.historio.removeAll()
        }))
        mesagho.addAction( UIAlertAction(title: NSLocalizedString("Ne", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(mesagho, animated: true, completion: nil)
    }
    
    func nuligiKonservitajn() {
        let mesagho: UIAlertController = UIAlertController(title: NSLocalizedString("agordoj nuligi konservitajn averto", comment: ""), message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        mesagho.addAction( UIAlertAction(title: NSLocalizedString("Jes", comment: ""), style: UIAlertActionStyle.Destructive, handler: { (ago: UIAlertAction) -> Void in
            UzantDatumaro.konservitaj.removeAll()
        }))
        mesagho.addAction( UIAlertAction(title: NSLocalizedString("Ne", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(mesagho, animated: true, completion: nil)
    }
}

extension AgordojViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("agordoj datumoj etikedo", comment: "")
        case 1:
            return NSLocalizedString("agordoj lingvoj etikedo", comment: "")
        case 2:
            return NSLocalizedString("agordoj aspekto etikedo", comment: "")
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let novaChelo = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: agordojChelIdent)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                novaChelo.textLabel?.text = NSLocalizedString("agordoj nuligi historion etikedo", comment: "")
            }
            else if indexPath.row == 1 {
                novaChelo.textLabel?.text = NSLocalizedString("agordoj nuligi konservitajn etikedo", comment: "")
            }
            novaChelo.accessoryType = UITableViewCellAccessoryType.None
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                novaChelo.textLabel?.text = NSLocalizedString("agordoj elekti serch-lingvon etikedo", comment: "")
                novaChelo.detailTextLabel?.text = UzantDatumaro.serchLingvo.nomo
            }
            else if indexPath.row == 1 {
                novaChelo.textLabel?.text = NSLocalizedString("agordoj elekti traduk-lingvojn etikedo", comment: "")
                if UzantDatumaro.tradukLingvoj.count == 1 {
                    novaChelo.detailTextLabel?.text = UzantDatumaro.tradukLingvoj.first?.nomo
                } else {
                    novaChelo.detailTextLabel?.text = String(format: NSLocalizedString("agordoj traduk-lingvoj subetikedo", comment: ""), arguments: [String(UzantDatumaro.tradukLingvoj.count)])
                }
            }
            novaChelo.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                novaChelo.textLabel?.text = NSLocalizedString("agordoj elekti stilon etikedo", comment: "")
                novaChelo.detailTextLabel?.text = UzantDatumaro.stilo.nomo
            }
            novaChelo.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text
        if let teksto = novaChelo.detailTextLabel?.text where teksto != "" {
            novaChelo.accessibilityLabel! += ", " + teksto
        }
        
        return novaChelo
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                nuligiHistorion()

            }
            else if indexPath.row == 1 {
                nuligiKonservitajn()
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let elektilo = SerchLingvoElektiloViewController()
                elektilo.delegate = self
                navigationController?.pushViewController(elektilo, animated: true)
            }
            else if indexPath.row == 1{
                let elektilo = TradukLingvojElektiloViewController()
                elektilo.delegate = self
                navigationController?.pushViewController(elektilo, animated: true)
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let elektilo = StiloElektiloViewController()
                navigationController?.pushViewController(elektilo, animated: true)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension AgordojViewController : SerchLingvoElektiloDelegate {
    
    func elektisSerchLingvon() {
        tabelo?.reloadRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.None)
    }
}

extension AgordojViewController : TradukLingvojElektiloDelegate {
    
    func elektisTradukLingvojn() {
        tabelo?.reloadRowsAtIndexPaths([NSIndexPath(forItem: 1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.None)
    }
}
