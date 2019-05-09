//
//  TradukLingvojElektiloViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit

let tradukLingvojElektiloChelIdent = "tradukLingvoElektiloChelo"

/*
    Protocol por ke aliaj paghoj povos reagi al la elekto de traduk-lingvoj
*/
protocol TradukLingvojElektiloDelegate {
    
    func elektisTradukLingvojn()
}

/*
    Pagho por elekti lingvojn en kiu tradukoj por vortoj montrighos. La unua sekcio
    ebligas samtemple elekti chiun lingvon au malshalti chiujn.
*/
class TradukLingvojElektiloViewController : UIViewController, Stilplena {
    
    @IBOutlet var lingvoTabelo: UITableView?
    var eoIndekso: Int = 0
    var delegate: TradukLingvojElektiloDelegate?
    var shanghisLingvojn: Bool = false
    
    init() {
        super.init(nibName: "TradukLingvojElektiloViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        eoIndekso = SeancDatumaro.lingvoj.firstIndex(where: { (nuna: Lingvo) -> Bool in
            nuna.kodo == "eo"
        }) ?? 0
        
        title = NSLocalizedString("traduk-elektilo titolo", comment: "")
        lingvoTabelo?.delegate = self
        lingvoTabelo?.dataSource = self
        lingvoTabelo?.register(UINib(nibName: "TradukLingvoElektiloTableViewCell", bundle: nil), forCellReuseIdentifier: tradukLingvojElektiloChelIdent)
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeDidChange(forChildContentContainer:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        efektivigiStilon()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if shanghisLingvojn {
            delegate?.elektisTradukLingvojn()
            UzantDatumaro.elektisTradukLingvojn()
        }
    }
    
    func efektivigiStilon() {

        lingvoTabelo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        lingvoTabelo?.backgroundColor = UzantDatumaro.stilo.fonKoloro
        lingvoTabelo?.separatorColor = UzantDatumaro.stilo.apartigiloKoloro
        lingvoTabelo?.reloadData()
    }
}

extension TradukLingvojElektiloViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return SeancDatumaro.lingvoj.count - 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let novaChelo: TradukLingvojElektiloTableViewCell
        if let trovChelo = lingvoTabelo?.dequeueReusableCell(withIdentifier: tradukLingvojElektiloChelIdent) as? TradukLingvojElektiloTableViewCell {
            novaChelo = trovChelo
        } else {
            novaChelo = TradukLingvojElektiloTableViewCell()
        }
        
        novaChelo.prepari()
        novaChelo.shaltilo?.tag = indexPath.row + ((indexPath.row >= eoIndekso) ? 1 : 0)
        novaChelo.shaltilo?.addTarget(self, action: #selector(TradukLingvojElektiloViewController.shaltisLingvon(shaltilo:)), for: .valueChanged)
        
        if indexPath.section == 0 {
            
            novaChelo.shaltilo?.isHidden = true
            switch indexPath.row {
            case 0:
                novaChelo.etikedo?.text = NSLocalizedString("traduk-elektilo chiuj etikedo", comment: "")
                break
            case 1:
                novaChelo.etikedo?.text = NSLocalizedString("traduk-elektilo neniuj etikedo", comment: "")
                break
            default:
                break
            }
        }
        else if indexPath.section == 1 {

            let lingvo = SeancDatumaro.lingvoj[indexPath.row + ((indexPath.row >= eoIndekso) ? 1 : 0)]
            novaChelo.shaltilo?.isHidden = false
            novaChelo.shaltilo?.isOn = UzantDatumaro.tradukLingvoj.contains(lingvo)
            novaChelo.etikedo?.text = lingvo.nomo
            
        }
        
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text
        
        return novaChelo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                for lingvo in SeancDatumaro.lingvoj {
                    if lingvo != SeancDatumaro.esperantaLingvo() {
                        UzantDatumaro.tradukLingvoj.insert(lingvo)
                    }
                }
                break;
            case 1:
                UzantDatumaro.tradukLingvoj.removeAll()
                break;
            default:
                break;
            }
            
            shanghisLingvojn = true
            for chelo in lingvoTabelo?.visibleCells as? [TradukLingvojElektiloTableViewCell] ?? [] {
                chelo.shaltilo?.setOn(indexPath.row == 0, animated: true)
            }
        }
        else if indexPath.section == 1 {
            
            if let chelo = tableView.cellForRow(at: indexPath) as? TradukLingvojElektiloTableViewCell,
               let shaltilo = chelo.shaltilo {
                
                shaltilo.setOn(!shaltilo.isOn, animated: true)
                shaltisLingvon(shaltilo: shaltilo)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }    
}

// Shaltilo reagado
extension TradukLingvojElektiloViewController {
    
    @objc func shaltisLingvon(shaltilo: UISwitch) {
        
        if shaltilo.isOn {
            UzantDatumaro.tradukLingvoj.insert(SeancDatumaro.lingvoj[shaltilo.tag])
        } else {
            UzantDatumaro.tradukLingvoj.remove(SeancDatumaro.lingvoj[shaltilo.tag])
        }
        
        shanghisLingvojn = true
    }
}

// Respondi al mediaj shanghoj
extension TradukLingvojElektiloViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        lingvoTabelo?.reloadData()
    }
}
