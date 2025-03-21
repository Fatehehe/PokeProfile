//
//  UserModel.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 19/03/25.
//

import SQLite

struct User {
    var username: String
    var password: String
}

class UserDatabase {
    private var db: Connection!
    private let usersTable = Table("users")
    
    // Columns
    private let id = Expression<Int64>("id")
    private let username = Expression<String>("username")
    private let password = Expression<String>("password")
    
    init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dbPath = documentDirectory.appendingPathComponent("user.db").path
            db = try Connection(dbPath)
            print("SQLite database path: \(dbPath)")
        } catch {
            print("Unable to open database: \(error)")
        }
    }
    
    func createTable() {
        // Create table
        do {
            try db.run(usersTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(username, unique: true)
                t.column(password)
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }
    
    func saveUser(user: User) throws {
        let insert = usersTable.insert(username <- user.username, password <- user.password)
        try db.run(insert)
    }
    
    func authenticateUser(username: String, password: String) -> Bool {
        let query = usersTable.filter(self.username == username && self.password == password)
        do {
            if try db.pluck(query) != nil {
                return true
            }
        } catch {
            print("Query failed: \(error)")
        }
        return false
    }
    
}
