//
//  AppDelegate.swift
//  StatusBar
//
//  Created by sycf_ios on 2017/12/14.
//  Copyright © 2017年 sycf_ios. All rights reserved.
//

import Cocoa
import Preferences

extension NSImage.Name {
    static let Image = NSImage.Name("Image")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    var monitor: Any!
    
//    private lazy var preferencesWindowController = PreferencesWindowController(
//        preferencePanes: [
//            GeneralPreferenceViewController()/*,
//            AdvancedPreferenceViewController()*/
//        ]
//    )
//
////    func applicationDidFinishLaunching(_ notification: Notification) {}
//
//    @IBAction
//    func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
//        preferencesWindowController.show()
//    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:.Image)
            button.action = #selector(togglePopover(_:))
//            self.constructMenu()
        }
        
        popover.contentViewController = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ViewController")) as! ViewController
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender)
        }else {
            startPopover(sender)
        }
    }
    
    func closePopover(_ sender: Any?) {
        popover.performClose(sender)
        if monitor != nil {
            NSEvent.removeMonitor(monitor)
            monitor = nil
        }
    }
    
    func startPopover(_ sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
        monitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown,.rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(event)
            }
        }
        (popover.contentViewController as! ViewController).txtMsg.growTextFieldIfNeeded(alt: true)
        (popover.contentViewController as! ViewController).txtMsg.becomeFirstResponder()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc func printQuote(_ sender: Any?) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }
}

