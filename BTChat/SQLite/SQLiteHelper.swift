//
//  SQLiteHelper.swift
//  BTChat
//
//  Created by Kim David Hauser on 02.09.21.
//  Copyright © 2021 sycf_ios. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteHelper {
    
    var db:OpaquePointer?
    let dbName:String = "BTChatDB.db"
    
    init(){
        self.db = self.openDatabase()
//        self.createTable()
//        self.insert()
    }

    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        if sqlite3_open(dbName, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbName)")
            return db
        } else {
            print("Unable to open database.")
        }
        return nil
    }
    
    let createTableString = """
    CREATE TABLE IF NOT EXISTS Contact(
    Id INT PRIMARY KEY NOT NULL,
    Name CHAR(255));
    """

    func createTable() {
      // 1
      var createTableStatement: OpaquePointer?
      // 2
      if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
        // 3
        if sqlite3_step(createTableStatement) == SQLITE_DONE {
          print("\nContact table created.")
        } else {
          print("\nContact table could not be created.")
        }
      } else {
        print("\nCREATE TABLE statement could not be prepared.")
      }
      // 4
      sqlite3_finalize(createTableStatement)
    }
    
    let insertStatementString = "INSERT INTO Contact (Id, Name) VALUES (?, ?);"
    func insert() {
      var insertStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
        let id: Int32 = 3
        let name: NSString = "DaVe"
        // 2
        sqlite3_bind_int(insertStatement, 1, id)
        // 3
        sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
        // 4
        if sqlite3_step(insertStatement) == SQLITE_DONE {
          print("\nSuccessfully inserted row.")
        } else {
          print("\nCould not insert row.")
        }
      } else {
        print("\nINSERT statement could not be prepared.")
      }
      // 5
      sqlite3_finalize(insertStatement)
    }
    
    func insert(name:String, uuid:String, mac:String) {
        let insertStatementString = "INSERT INTO Contacts (Contact, Uuid, MacAddress) VALUES (?, ?, ?) WHERE NOT EXISTS (SELECT * FROM Contacts WHERE Contact = ? AND Uuid = ? AND MacAddress = ?);"
        var insertStatement: OpaquePointer?
        
        print(insertStatementString)
        // 1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, NSString(string: name).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string: uuid).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, NSString(string: mac).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, NSString(string: name).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, NSString(string: uuid).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, NSString(string: mac).utf8String, -1, nil)
                
            print(insertStatement)
            print(insertStatementString)
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
              print("\nSuccessfully inserted row.")
            } else {
              print("\nCould not insert row.")
                print(String(cString: sqlite3_errmsg(db)))
                print("ERROR: %s: %s\n", sqlite3_errstr(sqlite3_extended_errcode(db)), sqlite3_errmsg(db));
            }
      } else {
          print("ERROR: %s: %s\n", sqlite3_errstr(sqlite3_extended_errcode(db)), sqlite3_errmsg(db));
//          print("ERROR: \(sqlite3_errmsg(db))")
//          sqlite3_errstr(sqlite3_errmsg(insertStatement))
        print("\nINSERT statement could not be prepared.")
      }
      // 5
      sqlite3_finalize(insertStatement)
    }
    
    func close(){
        sqlite3_close(self.db)
    }
}
