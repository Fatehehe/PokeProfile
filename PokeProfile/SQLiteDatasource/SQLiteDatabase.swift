//
//  SQLiteDatabase.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 19/03/25.
//

import Foundation
import SQLite

class SQLiteDatabase {
    static let sharedInstance = SQLiteDatabase()
    var database: Connection?
    
    private init(){
        //create connection to database
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("contactList").appendingPathComponent("sqlite3")
            
            database = try Connection(fileUrl.path)
        }catch{
            print("creating connection to database error: \(error)")
        }
    }
    
    func createTable(){
        SQLiteCommands.createTable()
    }
}
