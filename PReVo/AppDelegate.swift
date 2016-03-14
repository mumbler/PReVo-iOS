//
//  AppDelegate.swift
//  PReVo
//
//  Created by Robin Hill on 12/28/15.
//  Copyright © 2015 NormalSoft. All rights reserved.
//

import UIKit
import CoreData
import iOS_Slide_Menu

let datumbazNomo = "PReVoDatumbazo"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var fenestro: UIWindow?
    var kreiDatumbazon = false
    var konteksto: NSManagedObjectContext?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        TrieRegilo.konteksto = self.managedObjectContext
        DatumLegilo.konteksto = self.managedObjectContext
        
        if kreiDatumbazon {
            DatumLegilo.fariDatumbazon()
        }
        
        SeancDatumaro.starigi()
        UzantDatumaro.starigi()
        
        let navilo = ChefaNavigationController()
        
        fenestro = UIWindow(frame: UIScreen.mainScreen().bounds)
        fenestro?.rootViewController = navilo
        fenestro?.makeKeyAndVisible()
        
        Stiloj.efektivigiStilon(UzantDatumaro.stilo)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("PReVoDatumoj", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(datumbazNomo + ".sqlite")
        

        var fileMgr = NSFileManager.defaultManager()
        if let fonto = NSBundle.mainBundle().pathForResource(datumbazNomo, ofType: "sqlite"),
           let destino = url.path {
            do {
                try fileMgr.copyItemAtPath(fonto, toPath: destino)
            } catch let error as NSError {
                NSLog("Kopiis datumbazon")
            }
        }
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Malsukcesis sharghante je datumoj"
            dict[NSLocalizedFailureReasonErrorKey] = "Eraro sharghante je datumoj"
            dict[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                abort()
            }
        }
    }

}

