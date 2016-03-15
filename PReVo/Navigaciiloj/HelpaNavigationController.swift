//
//  HelpaNavigationController.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit

/*
    UINavigationController por montri subajn paghojn kiuj aperas el la suba flanko de la ekrano.
    Chi tiu Navigation Controller pretigas sian propran navigacia tabulo kun X butono, ktp.
*/
class HelpaNavigationController : UINavigationController, Stilplena {

    var subLinio: UIView?
    
    override func viewDidLoad() {
        
        navigationBar.translucent = false
        
        let maldekstraButono: UIBarButtonItem
        
        if (UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeLeft ||
            UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeRight) &&
            navigationBar.frame.height < 42 {
            maldekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_ikso_eta"), style: UIBarButtonItemStyle.Plain, target: self, action: "forigiSin")
        } else {
            maldekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_ikso"), style: UIBarButtonItemStyle.Plain, target: self, action: "forigiSin")
            maldekstraButono.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        }
        topViewController?.navigationItem.leftBarButtonItem = maldekstraButono
        
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        navigationBar.barTintColor = UzantDatumaro.stilo.navFonKoloro
        navigationBar.tintColor = UzantDatumaro.stilo.navTintKoloro
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UzantDatumaro.stilo.navTekstoKoloro]
        
        if subLinio == nil {
            subLinio = UIView()
            navigationBar.addSubview(subLinio!)
        }
        // Por ke la suba linio staru bone post rotacio
        subLinio?.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: navigationBar, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: navigationBar, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: navigationBar, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        subLinio?.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 1.0))
        subLinio?.backgroundColor = UzantDatumaro.stilo.SubLinioKoloro
        
        for filo in childViewControllers {
            if let konforma = filo as? Stilplena {
                konforma.efektivigiStilon()
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        subLinio?.hidden = true
        weak var malforta = self
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            malforta?.subLinio?.hidden = false
        });
    }
    
    func forigiSin() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
