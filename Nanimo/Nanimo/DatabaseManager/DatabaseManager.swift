//
//  RealmManager.swift
//  Nanimo
//
//  Created by Lena on 2023/08/17.
//

import Foundation
import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    private let realm: Realm
    
    let config = Realm.Configuration(schemaVersion: 1)
    
    private init() {
        do {
            realm = try Realm(configuration: config)
            
        } catch {
            fatalError("Error initializing new realm \(error)")
        }
    }

    
    // MARK: - Create
    func createSoundData(_ sound: SoundData) {
        /*
        let db = SoundData()
        db.name = sound.name
        db.location = sound.location
        db.time = sound.time
        db.count = sound.count
        db.name = sound.name
         */
        do {
            try realm.write {
                realm.add(sound)
                print("created")
            }
        } catch {
            print("error save \(error)")
        }
    }
    
    // MARK: - Read
    
    
    
    
    // MARK: = Update
    
    
    // MARK: = Delete
}
