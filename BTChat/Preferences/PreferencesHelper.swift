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

extension Preferences.PaneIdentifier {
    static let general = Self("general")
    static let advanced = Self("advanced")
    static let communication = Self("communication")
}

final class GeneralPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = Preferences.PaneIdentifier.general
    let preferencePaneTitle = "General"
    
//    #if compiler(>=5.3)
//    if @available(macOS 11.0, *) {
    let toolbarItemIcon = NSImage(systemSymbolName: "gear", accessibilityDescription: "General preferences")!// NSImage(named: .Image)//
//    }else{
//    let toolbarItemIcon = NSImage(named: .Image)// NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General preferences")!
//    }
//    #endif

    override var nibName: NSNib.Name? { NSNib.Name(rawValue: "GeneralPreferenceViewController") }

    override func viewDidLoad() {
        super.viewDidLoad()

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
