//
//  AutoGrowingTextField.swift
//  BTChat
//
//  Created by Kim David Hauser on 02.09.21.
//  Copyright © 2021 sycf_ios. All rights reserved.
//

import Foundation
import Cocoa

class AutoGrowingTextField: NSTextField {
    private var placeholderWidth: CGFloat? = 0

    /// Field editor inset; experimental value
    private let rightMargin: CGFloat = 5

    private var lastSize: NSSize?
    private var isEditing = false
    
    private var origSize:NSSize!
    private var origPos:NSPoint!
    private var growDiff:CGFloat = 0.0

    public func resetOrigSize(){
        self.setFrameSize(self.origSize)
        var newPos:NSPoint = self.origPos
        newPos.y += self.growDiff
        self.setFrameOrigin(newPos)
        var szV:NSSize = (self.window?.contentView!.frame.size)!
        szV.height -= self.growDiff
        self.window?.contentView!.setFrameSize(szV)
        self.window?.setContentSize(szV)
        self.growDiff = 0.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.origSize = self.frame.size
        self.origPos = self.frame.origin

        if let placeholderString = self.placeholderString {
            self.placeholderWidth = sizeForProgrammaticText(placeholderString).width
        }
    }

    override var placeholderString: String? {
        didSet {
            guard let placeholderString = self.placeholderString else { return }
            self.placeholderWidth = sizeForProgrammaticText(placeholderString).width
        }
    }

    override var stringValue: String {
        didSet {
            guard !isEditing else { return }
            self.lastSize = sizeForProgrammaticText(stringValue)
        }
    }

    public func sizeForProgrammaticText(_ string: String) -> NSSize {
        let font = self.font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        let stringWidth = NSAttributedString(
            string: string,
            attributes: [ .font : font ])
            .size().width

        // Don't use `self` to avoid cycles
        var size = super.intrinsicContentSize
        size.width = stringWidth
        return size
    }

    override func textDidBeginEditing(_ notification: Notification) {
        super.textDidBeginEditing(notification)
        isEditing = true
    }

    override func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        isEditing = false
    }

    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        self.invalidateIntrinsicContentSize()
        self.growTextFieldIfNeeded()
    }
    
    public func growTextFieldIfNeeded(alt:Bool = false){
        var sz:NSSize = self.sizeForProgrammaticText(self.stringValue)
        if(sz.height >= 150 && !alt){ return }
        sz.width = self.frame.width
        let diff = sz.height - self.frame.height
        
        var orig = self.frame.origin
        orig.y -= diff
        if(sz.height < 150 && !alt){
            self.growDiff += diff
            self.setFrameOrigin(orig)
            self.setFrameSize(sz)
        }
        
        self.superview?.needsLayout = true
        self.superview?.layoutSubtreeIfNeeded()
        var szV:NSSize = (self.window?.contentView as! NSView).frame.size
        if(alt){
            szV.height += self.growDiff
        }else{
            szV.height += diff
        }
        (self.window?.contentView as! NSView).setFrameSize(szV)
        self.window?.setContentSize(szV)
    }

    override var intrinsicContentSize: NSSize {
        var minSize: NSSize {
            var size = super.intrinsicContentSize
            size.width = self.placeholderWidth ?? 0
            return size
        }

        // Use cached value when not editing
        guard isEditing,
            let fieldEditor = self.window?.fieldEditor(false, for: self) as? NSTextView
            else { return self.lastSize ?? minSize }

        // Make room for the placeholder when the text field is empty
        guard !fieldEditor.string.isEmpty else {
            self.lastSize = minSize
            return minSize
        }

        // Use the field editor's computed width when possible
        guard let container = fieldEditor.textContainer,
            let newWidth = container.layoutManager?.usedRect(for: container).width
            else { return self.lastSize ?? minSize }

        var newSize = super.intrinsicContentSize
        newSize.width = newWidth + rightMargin

        self.lastSize = newSize

        return newSize
    }
}
