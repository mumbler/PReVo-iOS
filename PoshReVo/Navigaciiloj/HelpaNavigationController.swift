//
//  HelpaNavigationController.swift
//  PoshReVo
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
        
        navigationBar.isTranslucent = false
        
        let maldekstraButono: UIBarButtonItem
        
        if (UIApplication.shared.statusBarOrientation == .landscapeLeft ||
            UIApplication.shared.statusBarOrientation == .landscapeRight) &&
            UIApplication.shared.isStatusBarHidden {
            maldekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_ikso_eta"), style: .plain, target: self, action: #selector(HelpaNavigationController.forigiSin))
        } else {
            maldekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_ikso"), style: .plain, target: self, action: #selector(HelpaNavigationController.forigiSin))
            maldekstraButono.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        }
        topViewController?.navigationItem.leftBarButtonItem = maldekstraButono
        
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        navigationBar.barTintColor = UzantDatumaro.stilo.navFonKoloro
        navigationBar.tintColor = UzantDatumaro.stilo.navTintKoloro
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UzantDatumaro.stilo.navTekstoKoloro]
        
        if subLinio == nil {
            subLinio = UIView()
            navigationBar.addSubview(subLinio!)
        }
        // Por ke la suba linio staru bone post rotacio
        subLinio?.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: .left, relatedBy: .equal, toItem: navigationBar, attribute: .left, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: .right, relatedBy: .equal, toItem: navigationBar, attribute: .right, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: .bottom, relatedBy: .equal, toItem: navigationBar, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        subLinio?.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0))
        subLinio?.backgroundColor = UzantDatumaro.stilo.SubLinioKoloro
        
        for filo in children {
            if let konforma = filo as? Stilplena {
                konforma.efektivigiStilon()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        subLinio?.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (0.3 * Double(NSEC_PER_SEC)) ) {
            [weak self] in
            self?.subLinio?.isHidden = false
        }
    }
    
    @objc func forigiSin() {
        dismiss(animated: true, completion: nil)
    }
}
