//
//  ViewController.swift
//  PruebaFirebase
//
//  Created by Carlos Pava on 9/01/17.
//  Copyright © 2017 Sundevs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class ViewController: UIViewController {

    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var txtText: UITextField!
    @IBOutlet weak var labRead: UILabel!
    
    let ref = FIRDatabase.database().reference(withPath: "padre")
    var array = [NSDictionary]()
    var text = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterContentType:"cont" as NSObject,
            kFIRParameterItemID:"1" as NSObject
            ])
        
    }

    @IBAction func onSave(_ sender: Any) {
        
        self.ref.child("hijo").child(self.txtNumber.text!).setValue(self.txtText.text, withCompletionBlock: { (error, FIRDatabaseReference) in
            print(FIRDatabaseReference)
        })
    
    }
    
    func readData(){
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as! [String : AnyObject]
            self.text.removeAll()
           for text in (postDict["hijo"] as! NSArray){
            let str = String(describing: text)
            
            print(str)
                self.text.append(str)
            }
            self.tableview.reloadData()
        })
    }

    @IBAction func onRead(_ sender: Any) {
       self.readData()
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.text.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.text[indexPath.row]
        return cell!
    }
}
