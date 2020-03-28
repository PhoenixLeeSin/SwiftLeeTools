//
//  RealmDBViewController.swift
//  topsiOSPro_Example
//
//  Created by 李桂盛 on 2020/2/13.
//  Copyright © 2020 李桂盛. All rights reserved.
//

import UIKit
import SwiftLeeTools
import RealmSwift

class DemoObject:  Object{
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    @objc dynamic var bf: String? = nil
    @objc dynamic var id: Int64 = 0
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
}

class Cell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}

class RealmDBViewController: BaseUIViewViewController {

    var results: Results<DemoObject>!
    
    var tableView: UITableView!
    
    var notificationToken: NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RealmManger.createOrSwitchRealmWith("iosRealm")
        results = RealmManger.queryAll(DemoObject.self)
        
        addTableView()
        
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
        
    }
    
    func addTableView() {
        var rightBarButtonItem1: UIBarButtonItem!
        var rightBarButtonItem2: UIBarButtonItem!        
        var rightBarButtonItem3: UIBarButtonItem!
        rightBarButtonItem1 = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self, action: #selector(add))
        if #available(iOS 13.0, *) {
            rightBarButtonItem2 = UIBarButtonItem(image: UIImage(systemName: "arrow.2.circlepath.circle"), style: .done, target: self, action: #selector(switchRealm))
        } else {
            rightBarButtonItem2 = UIBarButtonItem(title: "switch", style: .done, target: self, action: #selector(switchRealm))
        }
        
        rightBarButtonItem3 = UIBarButtonItem(barButtonSystemItem: .action,
                                                                 target: self, action: #selector(push))
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem1, rightBarButtonItem2,rightBarButtonItem3]
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        baseView.addSubview(tableView)
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func add() {
        RealmManger.addSequence([DemoObject(value: ["title-\(arc4random())",arc4random()])], hasPrimaryKey: false)
    }
    @objc func push() {
        let viewcontroller = RealmDBWirhJSONViewController()
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        
    }
    @objc func switchRealm() {
        RealmManger.createOrSwitchRealmWith("topsiOSProDB")
        results = RealmManger.queryAll(DemoObject.self)
        tableView.reloadData()
                
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
        
        
    }
    
}

extension RealmDBViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Cell
        
        cell.textLabel?.text = results[indexPath.row].name
        cell.detailTextLabel?.text = "\(results[indexPath.row].age)"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RealmManger.delete(results[indexPath.row])
        }
    }
    
}
