//
//  Stiloj.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit
import iOS_Slide_Menu

/*
    La elekteblaj kolor-stiloj
*/
enum KolorStilo : Int {
    case Hela = 0, Malhela
    
    var nomo: String {
        switch self {
        case .Hela:
            return NSLocalizedString("stilo hela nomo", comment: "")
        case .Malhela:
            return NSLocalizedString("stilo malhela nomo", comment: "")
        }
    }
    
    var tekstKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.Nigro.valoro
        case .Malhela:
            return Koloro.HelegaGrizo.valoro
        }
    }
    
    var bazKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.Blanko.valoro
        case .Malhela:
            return Koloro.MalhelaGrizo.valoro
        }
    }
    
    var fonKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.HelegaGrizo.valoro
        case .Malhela:
            return Koloro.MezaGrizo.valoro
        }
    }
    
    var fonTekstKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.HelaGrizo.valoro
        case .Malhela:
            return Koloro.HelegaGrizo.valoro
        }
    }
    
    var tintKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.KlasikaVerdo.valoro
        case .Malhela:
            return Koloro.HelaVerdo.valoro
        }
    }
    
    var navFonKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.Blanko.valoro
        case .Malhela:
            return Koloro.MalhelaGrizo.valoro
        }
    }
    
    var navTekstoKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.Nigro.valoro
        case .Malhela:
            return Koloro.HelegaGrizo.valoro
        }
    }
    
    var navTintKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.KlasikaVerdo.valoro
        case .Malhela:
            return Koloro.HelaVerdo.valoro
        }
    }
    
    var SubLinioKoloro: UIColor {
        switch self {
        case .Hela:
            return UIColor.clear
        case .Malhela:
            return Koloro.HelaGrizo.valoro
        }
    }
    
    var apartigiloKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.KvaraGrizo.valoro
        case .Malhela:
            return Koloro.HelaGrizo.valoro
        }
    }
    
    var flankFonKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.KlasikaVerdo.valoro
        case .Malhela:
            return Koloro.KlasikaVerdo.valoro
        }
    }

    var flankElektitaKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.HelaVerdo.valoro
        case .Malhela:
            return Koloro.HelaVerdo.valoro
        }
    }
    
    var flankTekstKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.Blanko.valoro
        case .Malhela:
            return Koloro.Blanko.valoro
        }
    }
    
    var difinKapFonKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.KlasikaVerdo.valoro
        case .Malhela:
            return Koloro.KlasikaVerdo.valoro
        }
    }

    var difinKapTekstKoloro: UIColor {
        switch self {
        case .Hela:
            return Koloro.Blanko.valoro
        case .Malhela:
            return Koloro.Blanko.valoro
        }
    }
    
    // --------
    
    var scrollKoloro: UIScrollView.IndicatorStyle {
        switch self {
        case .Hela:
            return UIScrollView.IndicatorStyle.black
        case .Malhela:
            return UIScrollView.IndicatorStyle.white
        }
    }
    
     var serchTabuloKoloro: UIBarStyle {
        switch self {
        case .Hela:
            return UIBarStyle.default
        case .Malhela:
            return UIBarStyle.black
        }
    }
    
    var statusKoloro: UIStatusBarStyle {
        switch self {
        case .Hela:
            return UIStatusBarStyle.default
        case .Malhela:
            return UIStatusBarStyle.lightContent
        }
    }
    
    var klavaroKoloro: UIKeyboardAppearance {
        switch self {
        case .Hela:
            return UIKeyboardAppearance.light
        case .Malhela:
            return UIKeyboardAppearance.dark
        }
    }
    
    // ----------
    
    static var count: Int {
        return Malhela.rawValue + 1
    }
}

/*
    La Stilplena protocol ebligas ke la Stiloj klaso igas la vidblajn ekranojn
    intershanghi siajn kolojn kiam la stilo shanghighas
*/
protocol Stilplena {
    
    func efektivigiStilon() // Shanghi kolorojn laubezono
}

class Stiloj {
    
    /*
        Chi tiu funkcio shanghas plurajn gheneralajn kolor-agordojn, kaj igas ke la prezentitaj ekranoj
        faru same.
    */
    static func efektivigiStilon(_ stilo: KolorStilo) {
        
        UIApplication.shared.statusBarStyle = UzantDatumaro.stilo.statusKoloro
        
        // Ni uzas specialajn versiojn de chi tiuj funkcioj char alie ghi ne estas uzeblaj sub iOS 8.1 per Swift
        UILabel.nia_appearanceWhenContained(in: UITableViewHeaderFooterView.self).textColor = UzantDatumaro.stilo.fonTekstKoloro
        UITextField.nia_appearanceWhenContained(in: UISearchBar.self).textColor = UzantDatumaro.stilo.tekstKoloro
        
        /*UILabel.appearanceWhenContainedInInstancesOfClasses([UITableViewHeaderFooterView.self]).textColor = UzantDatumaro.stilo.fonTekstKoloro
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = UzantDatumaro.stilo.tekstKoloro*/
        
        if let konforma = SlideNavigationController.sharedInstance().leftMenu as? Stilplena {
            
            konforma.efektivigiStilon()
        }
        
        if let nav = UIApplication.shared.keyWindow?.rootViewController {
            
            if let konformaNav = nav as? ChefaNavigationController {
                
                konformaNav.efektivigiStilon()
                
                for filo in konformaNav.children {
                    
                    if let konforma = filo as? Stilplena {
                        
                        konforma.efektivigiStilon()
                    }
                }
            }
        }
        
    }
}
