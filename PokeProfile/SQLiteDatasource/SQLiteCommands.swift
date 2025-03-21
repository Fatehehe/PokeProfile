//
//  SQLiteCommands.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 19/03/25.
//

import Foundation
import SQLite

class SQLiteCommands {
    static var table = Table("user")
    
    static let id = Expression<Int>("id")
    static let username = Expression<String>("username")
    static let password = Expression<String>("password")
    
    static func createTable(){
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("datastore connection error")
            return
        }
        
        do{
            try database.run(table.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(username, unique: true)
                table.column(password)
            })
        }catch{
            print("Table already exist \(error)")
        }
    }
    
    static func saveUser(_ user: User) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("datastore connect error")
            return nil
        }
        
        do{
            try database.run(table.insert(username<-user.username, password<-user.password))
            return true
        }catch{
            print("insertion failed \(error)")
            return false
        }
    }
    
    static func authenticateUser(username: String, password: String) -> Bool {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return false
        }
        
        let query = table.filter(self.username == username && self.password == password)
        do {
            if let _ = try database.pluck(query) {
                print("User authenticated successfully")
                return true
            } else {
                print("Invalid username or password")
                return false
            }
        } catch {
            print("Error during authentication: \(error)")
            return false
        }
    }
}
