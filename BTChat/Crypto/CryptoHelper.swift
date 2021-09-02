//
//  CryptoHelper.swift
//  BTChat
//
//  Created by Kim David Hauser on 02.09.21.
//  Copyright © 2021 sycf_ios. All rights reserved.
//

import Foundation
import CryptoSwift
//import XCTest

class CryptoHelper {
    
    static let password: [UInt8] = Array("Jn3TD0R".utf8)
    static let salt: [UInt8] = Array("nacllcan".utf8)
    
    static let key = Array<UInt8>(hex: "0xfeffe9928665731c6d6a8f9467308308")
    static let iv = Array<UInt8>(hex: "0xcafebabefacedbaddecaf888")
    
    static func testAESGCMTestCase3Combined() {
      // Test Case 3
      let key = Array<UInt8>(hex: "0xfeffe9928665731c6d6a8f9467308308")
      let plaintext = "Kims enc test"
      let iv = Array<UInt8>(hex: "0xcafebabefacedbaddecaf888")

      let encGCM = GCM(iv: iv, mode: .combined)
      let aes = try! AES(key: key, blockMode: encGCM, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext.data(using: .utf8)!.bytes)

//      XCTAssertNotNil(encGCM.authenticationTag)
//      XCTAssertEqual(Array(encrypted), [UInt8](hex: "0x42831ec2217774244b7221b784d0d49ce3aa212f2c02a4e035c17e2329aca12e21d514b25466931c7d8f6a5aac84aa051ba30b396a0aac973d58e091473f59854d5c2af327cd64a62cf35abd2ba6fab4")) // C
//      XCTAssertEqual(encGCM.authenticationTag, [UInt8](hex: "0x4d5c2af327cd64a62cf35abd2ba6fab4")) // T (128-bit)

      // decrypt
      func decrypt(_ encrypted: Array<UInt8>) -> Array<UInt8> {
        let decGCM = GCM(iv: iv, mode: .combined)
        let aes = try! AES(key: key, blockMode: decGCM, padding: .noPadding)
        return try! aes.decrypt(encrypted)
      }

      let decrypted = decrypt(encrypted)
//      XCTAssertEqual(decrypted, plaintext)
        print("Decripted OK \(decrypted == plaintext.data(using: .utf8)!.bytes)")
    }
    
    static func encrypt(str:String) throws -> Data{
        let encGCM = GCM(iv: iv, mode: .combined)
        let aes = try! AES(key: key, blockMode: encGCM, padding: .noPadding)
        let encrypted = try! aes.encrypt(str.data(using: .utf8)!.bytes)
        return Data(bytes: encrypted)
    }
    
    static func decrypt(_ encrypted: Array<UInt8>) -> String {
        let decGCM = GCM(iv: iv, mode: .combined)
        let aes = try! AES(key: key, blockMode: decGCM, padding: .noPadding)
        return try! String(data: Data(bytes: aes.decrypt(encrypted)), encoding: .utf8)!
    }
    
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
