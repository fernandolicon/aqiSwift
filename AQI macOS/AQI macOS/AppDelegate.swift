//
//  AppDelegate.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/23/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var manageCitiesWindow: NSWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        AQIUpdateManager.shared.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func addNew(_ sender: Any) {
        guard manageCitiesWindow == nil else {
            manageCitiesWindow?.window?.orderFront(nil)
            manageCitiesWindow?.window?.makeKey()
            return
        }
        
        manageCitiesWindow = NSStoryboard.main?.instantiateController(withIdentifier: AppWindows.ManageCitiesWindow.rawValue) as? NSWindowController
        manageCitiesWindow?.showWindow(nil)
        manageCitiesWindow?.window?.makeKey()
    }
    
    @IBAction func deleteEntry(_ sender: Any) {
        guard let manageCitiesViewController = manageCitiesWindow?.contentViewController as? ManageCitiesViewController else {
            return
        }
        
        manageCitiesViewController.didDeleteSelected()
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            NSApp.windows.filter({ $0.identifier?.rawValue == AppWindows.MainWindow.rawValue }).first?.makeKeyAndOrderFront(self)
        }
        return !flag
    }
    
    @IBAction func reload(_ sender: Any) {
        AQIUpdateManager.shared.reloadData()
    }
}

extension AppDelegate: NSUserInterfaceValidations {
    func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        switch item.action {
        case #selector(deleteEntry(_:)):
            guard NSApplication.shared.keyWindow == manageCitiesWindow?.window,
                  let manageCitiesViewController = manageCitiesWindow?.contentViewController as? ManageCitiesViewController else {
                return false
            }
            return manageCitiesViewController.shouldEnableDelete
        default:
            return true
        }
    }
}

