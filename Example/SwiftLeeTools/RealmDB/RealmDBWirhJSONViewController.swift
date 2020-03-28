//
//  RealmDBWirhJSONViewController.swift
//  topsiOSPro_Example
//
//  Created by 李桂盛 on 2020/2/14.
//  Copyright © 2020 李桂盛. All rights reserved.
//

import UIKit
import SwiftLeeTools
import RealmSwift

class JsonObject: Object {
    @objc dynamic var city = ""
    @objc dynamic var id = 0
}



class RealmDBWirhJSONViewController: BaseUIViewViewController {

    var tableView: UITableView!
    
    var results: Results<JsonObject>!
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RealmManger.createOrSwitchRealmWith("jsonDB")
        results = RealmManger.queryAndSort(JsonObject.self, key: "id", isAscending: true)
        
        self.notificationToken = results.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map {
                    //                    print($0)
                    return IndexPath(row: $0, section: 0)
                    
                }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
            }
        }
        
        addTableView()
    }
    func addTableView() {
        var rightBarButtonItem1: UIBarButtonItem!

        rightBarButtonItem1 = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem1]
        

        
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        baseView.addSubview(tableView)
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func add() {
        let data = "{\"city\": \"San Francisco\", \"id\": \(arc4random())}".data(using: .utf8)!
        RealmManger.createData(JsonObject.self, data,hasPrimaryKey: false)
    }
    
}

extension RealmDBWirhJSONViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Cell
        
        cell.textLabel?.text = results[indexPath.row].city
        cell.detailTextLabel?.text = "\(results[indexPath.row].id)"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RealmManger.delete(results[indexPath.row])
        }
    }
    
}
