//
//  BTChatDefaults.swift
//  BTChat
//
//  Created by Kim David Hauser on 02.09.21.
//  Copyright © 2021 sycf_ios. All rights reserved.
//

import Foundation
import Cocoa
import Defaults

extension Defaults.Keys {
    static let launchAtStartup = Key<Bool>("launchAtStartup", default: false)
    static let encryptDataTransfer = Key<Bool>("encryptDataTransfer", default: false)
    static let saveChatsToDB = Key<Bool>("saveChatsToDB", default: false)
    static let encryptDB = Key<Bool>("encryptDB", default: false)
    static let dbEncryptionAlgorithm = Key<DBEncryptionKeys>("defaultDuration", default: .SEE)
    
    static let autoScan = Key<Bool>("autoScan", default: true)
    static let scanTimeout = Key<Int>("scanTimeout", default: 120)
}

enum DBEncryptionKeys: String, Defaults.Serializable {
    case SEE = "SEE"
    case wxSQLite = "wxSQLite"
    case SQLCipher = "SQLCipher"
    case SQLiteCrypt = "SQLiteCrypt"
    case botansqlite3 = "botansqlite3"
    case sqleet = "sqleet"
}

