//
//  RealmManger.swift
//  Realm数据库
//
//  Created by 李桂盛 on 2020/2/13.
//  Copyright © 2020 LeeSin. All rights reserved.
//

import Foundation
import RealmSwift

 public class RealmManger: NSObject {
    
    private static var configuration: Realm.Configuration!
//    private static var results: Results<Element: RealmCollectionValue>!
    //Create
    public static func createOrSwitchRealmWith(_ name: String) {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(name).realm")
        configuration = config
        Realm.Configuration.defaultConfiguration = config
    }

    //Write
   public static func doWriteHandle(_ block: @escaping () -> Void) {
        try! Realm(configuration: configuration).write {
            block()
        }
    }
    
   public static func doWriteHandleInBG(_ block: @escaping () -> Void) {
        try! Realm(configuration: configuration).write {
            block()
        }
    }
    //Create
    public static func createData<T: Object>(_ object: T.Type,_ data: Data, hasPrimaryKey: Bool) {
        try! Realm(configuration: configuration).write {
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            try! Realm(configuration: configuration).create(object.self, value: json, update: hasPrimaryKey == true ? Realm.UpdatePolicy.all : Realm.UpdatePolicy.error)
        }        
    }
    //Add an Object. What to do if an object with the same primary key alredy exists. Must be .error for objects without a primary key.
    public static func addCanUpdate<T: Object>(_ object: T, hasPrimaryKey: Bool) {
        try! Realm(configuration: configuration).write {
            try! Realm(configuration: configuration).add(object, update: hasPrimaryKey == true ? Realm.UpdatePolicy.all : Realm.UpdatePolicy.error)
        }
    }
    //Add sequence in background. What to do if an object with the same primary key alredy exists. Must be .error for objects without a primary key.
   public static func addSequenceBG<T: Object>(_ sequence: [T], hasPrimaryKey: Bool) {
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            autoreleasepool{
                let realm = try! Realm(configuration: configuration)
                realm.beginWrite()
                
                for item in sequence {
                    realm.add(item, update: hasPrimaryKey == true ? Realm.UpdatePolicy.all : Realm.UpdatePolicy.error)
                }
                
                try! realm.commitWrite()
            }
        }
    }
    
    //Add sequence in main
    public static func addSequence<T: Object>(_ sequence: [T], hasPrimaryKey: Bool) {
        autoreleasepool{
            let realm = try! Realm(configuration: configuration)
            realm.beginWrite()
            
            for item in sequence {
                realm.add(item, update: hasPrimaryKey == true ? Realm.UpdatePolicy.all : Realm.UpdatePolicy.error)
            }
            
            try! realm.commitWrite()
        }
    }
    
    //Delete an object
    public static func delete<T: Object>(_ object: T) {
        try! Realm(configuration: configuration).write {
            try! Realm(configuration: configuration).delete(object)
        }
    }
    
    //Delete objects
    public static func deleteObjects<T: Object>(_ sequence: [T]) {
        try! Realm(configuration: configuration).write {
            try! Realm(configuration: configuration).delete(sequence)
        }
    }
    
    public static func deleteObjects<T: Object>(_ sequence: List<T>) {
        try! Realm(configuration: configuration).write {
            try! Realm(configuration: configuration).delete(sequence)
        }
    }
    
    public static func deleteObjects<T: Object>(_ sequence: Results<T>) {
        try! Realm(configuration: configuration).write {
            try! Realm(configuration: configuration).delete(sequence)
        }
    }
    
    public static func deleteObjects<T: Object>(_ sequence: LinkingObjects<T>) {
        try! Realm(configuration: configuration).write {
            try! Realm(configuration: configuration).delete(sequence)
        }
    }
    
    //Delete All
    public static func deleteAll() {
        try! Realm(configuration: configuration).write {
            try! Realm(configuration: configuration).deleteAll()
        }
    }
    //query All
    public static func queryAll<T: Object>(_: T.Type) -> Results<T>{
        return try! Realm(configuration: configuration).objects(T.self)
     }
    //query
    public static func queryByNSPredicate<T: Object>(_: T.Type, predicate: NSPredicate) -> Results<T> {
        return  try! Realm(configuration: configuration).objects(T.self).filter(predicate)
    }
    //query in background
    public static func queryByNSPredicateInBG<T: Object>(_: T.Type, predicate: NSPredicate) -> Results<T> {
        return  try! Realm(configuration: configuration).objects(T.self).filter(predicate)
    }
    //query and sort
    public static func queryAndSort<T: Object>(_:T.Type, key: String, isAscending: Bool) -> Results<T> {
        return try! Realm(configuration: configuration).objects(T.self).sorted(byKeyPath: key, ascending: isAscending)
    }
}
