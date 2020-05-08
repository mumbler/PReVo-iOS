//
//  FlankMenuoViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit

let flankMenuoChelIdent = "flankMenuoChelo"

protocol FlankMenuoDelegate {
    
    func elektisPaghon(novaPagho: Pagho)
}

/*
    Flanka menuo per kiu la uzanto povos elekti kiun paghon ri volas vidi
*/
class FlankMenuoViewController : UIViewController, Stilplena {

    @IBOutlet var tabelo: UITableView?
    @IBOutlet var navAlteco: NSLayoutConstraint?
    @IBOutlet var supraRegiono: UIView?
    
    var delegate: FlankMenuoDelegate?
    
    init() {
        super.init(nibName: "FlankMenuoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        tabelo?.delegate = self
        tabelo?.dataSource = self
        tabelo?.register(UINib(nibName: "FlankMenuoTableViewCell", bundle: nil), forCellReuseIdentifier: flankMenuoChelIdent)
        
        efektivigiStilon()
    }
    
    // MARK: - UI agordoj
    
    func navAltecoShanghis(alteco: CGFloat) {
        navAlteco?.constant = alteco + ((UIApplication.shared.isStatusBarHidden) ? 0 : UIApplication.shared.statusBarFrame.size.height)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Stilplena
    
    func efektivigiStilon() {
        
        supraRegiono?.backgroundColor = UzantDatumaro.stilo.flankFonKoloro
        tabelo?.backgroundColor = UzantDatumaro.stilo.flankFonKoloro
        tabelo?.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension FlankMenuoViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Pagho.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let novaChelo : FlankMenuoTableViewCell
        if let trovChelo = tabelo?.dequeueReusableCell(withIdentifier: flankMenuoChelIdent) as? FlankMenuoTableViewCell {
            novaChelo = trovChelo
        } else {
            novaChelo = FlankMenuoTableViewCell()
        }
        
        if let pagho = Pagho(rawValue: indexPath.row) {
            novaChelo.prepari(teksto: pagho.nomo, bildo: pagho.bildo)
        }
        
        return novaChelo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let novaPagho = Pagho(rawValue: indexPath.row) {
            delegate?.elektisPaghon(novaPagho: novaPagho)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
