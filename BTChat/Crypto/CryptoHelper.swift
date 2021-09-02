//
//  CryptoHelper.swift
//  BTChat
//
//  Created by Kim David Hauser on 02.09.21.
//  Copyright © 2021 sycf_ios. All rights reserved.
//

import Foundation
import CryptoSwift

class CryptoHelper {
    
    static let password: [UInt8] = Array("Jn3TD0R".utf8)
    static let salt: [UInt8] = Array("nacllcan".utf8)
    
    static func aesEncrypt(inputData:Data) throws -> Data{
        /* Generate a key from a `password`. Optional if you already have a key */
        let key = try PKCS5.PBKDF2(
            password: password,
            salt: salt,
            iterations: 4096,
            keyLength: 32, /* AES-256 */
            variant: .sha256
        ).calculate()

        /* Generate random IV value. IV is public value. Either need to generate, or get it from elsewhere */
        let iv = AES.randomIV(AES.blockSize)

        /* AES cryptor instance */
        let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)

        /* Encrypt Data */
//        let inputData = Data()
        let encryptedBytes = try aes.encrypt(inputData.bytes)
        let encryptedData = Data(encryptedBytes)
        return encryptedData
    }
    
    static func aesDecrypt(encryptedData:Data) throws -> Data{
        /* Generate a key from a `password`. Optional if you already have a key */
        let key = try PKCS5.PBKDF2(
            password: password,
            salt: salt,
            iterations: 4096,
            keyLength: 32, /* AES-256 */
            variant: .sha256
        ).calculate()

        /* Generate random IV value. IV is public value. Either need to generate, or get it from elsewhere */
        let iv = AES.randomIV(AES.blockSize)

        /* AES cryptor instance */
        let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
        
        /* Decrypt Data */
        let decryptedBytes = try aes.decrypt(encryptedData.bytes)
        let decryptedData = Data(bytes: decryptedBytes)
        
        return decryptedData
    }
//    static func aesEncrypt() throws -> String {
//        let encrypted = try AES(key: KEY, iv: IV, padding: .pkcs7).encrypt([UInt8](self.data(using: .utf8)!))
//        return Data(encrypted).base64EncodedString()
//    }
//
//    static func aesDecrypt() throws -> String {
//        guard let data = Data(base64Encoded: self) else { return "" }
//        let decrypted = try AES(key: KEY, iv: IV, padding: .pkcs7).decrypt([UInt8](data))
//        return String(bytes: decrypted, encoding: .utf8) ?? self
//    }
    
}
