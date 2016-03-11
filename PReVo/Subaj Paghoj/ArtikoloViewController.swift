//
//  ArtikoloViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

class ArtikoloViewController : UIViewController {
    
    @IBOutlet var vortTabelo: UITableView?
    var artikolo: Artikolo? = nil
    
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

        vortTabelo?.delegate = self
        vortTabelo?.dataSource = self
        vortTabelo?.reloadData()
    }
    
}

extension ArtikoloViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
