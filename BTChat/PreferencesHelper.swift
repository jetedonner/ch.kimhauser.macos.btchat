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
}

final class GeneralPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = Preferences.PaneIdentifier.general
    let preferencePaneTitle = "General"
    let toolbarItemIcon = NSImage(named: .Image)// NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General preferences")!

    override var nibName: NSNib.Name? { NSNib.Name(rawValue: "GeneralPreferenceViewController") }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup stuff here
    }
}


final class AdvancedPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = Preferences.PaneIdentifier.advanced
    let preferencePaneTitle = "Advanced"
    let toolbarItemIcon = NSImage(named: .Image)// NSImage(systemSymbolName: "gearshape.2", accessibilityDescription: "Advanced preferences")!

    override var nibName: NSNib.Name? { NSNib.Name(rawValue: "AdvancedPreferenceViewController") }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup stuff here
    }
}
