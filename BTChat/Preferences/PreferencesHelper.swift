//
//  PreferencesHelper.swift
//  BTChat
//
//  Created by Kim David Hauser on 02.09.21.
//  Copyright © 2021 sycf_ios. All rights reserved.
//

import Foundation
import Cocoa
import Preferences
import Defaults
import LaunchAtLogin

extension Preferences.PaneIdentifier {
    static let general = Self("general")
    static let advanced = Self("advanced")
    static let communication = Self("communication")
}

final class GeneralPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = Preferences.PaneIdentifier.general
    let preferencePaneTitle = "General"
    
    let toolbarItemIcon = NSImage(systemSymbolName: "gear", accessibilityDescription: "General preferences")!// NSImage(named: .Image)//
    
    override var nibName: NSNib.Name? { NSNib.Name(rawValue: "GeneralPreferenceViewController") }
    
    @IBOutlet var chkLaunchAtStartup:NSButton!
    @IBAction func setLaunchAtStartup(_ sender:Any?){
        LaunchAtLogin.isEnabled = (self.chkLaunchAtStartup.state == .on)
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.chkLaunchAtStartup.state = (Defaults[.launchAtStartup] ? .on : .off)
        // Setup stuff here
    }
}


final class AdvancedPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = Preferences.PaneIdentifier.advanced
    let preferencePaneTitle = "Advanced"
    let toolbarItemIcon = NSImage(systemSymbolName: "antenna.radiowaves.left.and.right", accessibilityDescription: "Advanced preferences")!

    override var nibName: NSNib.Name? { NSNib.Name(rawValue: "AdvancedPreferenceViewController") }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup stuff here
    }
}


final class CommunicationPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = Preferences.PaneIdentifier.communication
    let preferencePaneTitle = "Communication"
    let toolbarItemIcon = NSImage(systemSymbolName: "text.bubble.fill", accessibilityDescription: "Communication preferences")!

    override var nibName: NSNib.Name? { NSNib.Name(rawValue: "CommunicationPreferenceViewController") }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup stuff here
    }
}
