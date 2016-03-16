//
//  FlankMenuoViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
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
    
    override func viewDidLoad() {
        
        tabelo?.delegate = self
        tabelo?.dataSource = self
        tabelo?.registerNib(UINib(nibName: "FlankMenuoTableViewCell", bundle: nil), forCellReuseIdentifier: flankMenuoChelIdent)
        
        //navAltecoShanghis(navigationController?.navigationBar.frame.size.height ?? 0)
        
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        supraRegiono?.backgroundColor = UzantDatumaro.stilo.flankFonKoloro
        tabelo?.backgroundColor = UzantDatumaro.stilo.flankFonKoloro
        tabelo?.reloadData()
    }
    
    func navAltecoShanghis(alteco: CGFloat) {
        navAlteco?.constant = alteco + ((UIApplication.sharedApplication().statusBarHidden) ? 0 : UIApplication.sharedApplication().statusBarFrame.size.height)
        view.setNeedsUpdateConstraints()
    }
    
    /*override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        if (UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeLeft ||
            UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeRight) &&
            prefersStatusBarHidden() {
            navAlteco?.constant = 0.0
        } else {
            navAlteco?.constant = UIApplication.sharedApplication().statusBarFrame.size.height
        }
    }*/
    
}

extension FlankMenuoViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Pagho.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let novaChelo : FlankMenuoTableViewCell
        if let trovChelo = tabelo?.dequeueReusableCellWithIdentifier(flankMenuoChelIdent) as? FlankMenuoTableViewCell {
            novaChelo = trovChelo
        } else {
            novaChelo = FlankMenuoTableViewCell()
        }
        
        if let pagho = Pagho(rawValue: indexPath.row) {
            novaChelo.prepari(pagho.nomo, bildoNomo: pagho.bildoNomo)
        }
        
        return novaChelo
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let novaPagho = Pagho(rawValue: indexPath.row) {
            delegate?.elektisPaghon(novaPagho)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
