//
//  FlankMenuoViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

let flankMenuoChelIdent = "flankMenuoChelo"

protocol FlankMenuoDelegate {
    
    func elektisPaghon(novaPagho: Pagho)
}

class FlankMenuoViewController : UIViewController {

    @IBOutlet var tabelo: UITableView?
    @IBOutlet var navAlteco: NSLayoutConstraint?
    var delegate: FlankMenuoDelegate?
    
    override func viewDidLoad() {
        
        navAlteco?.constant =  UIApplication.sharedApplication().statusBarFrame.size.height + (navigationController?.navigationBar.frame.size.height ?? 40)
        
        tabelo?.delegate = self
        tabelo?.dataSource = self
        tabelo?.registerNib(UINib(nibName: "FlankMenuoTableViewCell", bundle: nil), forCellReuseIdentifier: flankMenuoChelIdent)
        tabelo?.reloadData()
    }
    
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
            novaChelo.etikedo?.text = pagho.nomo
            novaChelo.bildo?.image = UIImage(named: pagho.bildoNomo)
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
