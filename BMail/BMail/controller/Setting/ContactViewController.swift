//
//  ContactViewController.swift
//  BMail
//
//  Created by hyperorchid on 2020/5/18.
//  Copyright © 2020 NBS. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
        
        var curViewType:MailActionType = .Contact
        var delegate:CenterViewControllerDelegate?
        @IBOutlet weak var contactTableView: UITableView!
        
        var contacts:[BmailContact] = []
        override func viewDidLoad() {
                super.viewDidLoad()
                contactTableView.rowHeight = 94
        }
    
        override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                contacts = Array(BmailContact.ContactsCache.values)
                contactTableView.reloadData()
        }
        @IBAction func showMenu(_ sender: UIBarButtonItem) {
                delegate?.toggleLeftPanel()
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                backItem.tintColor = UIColor.init(hexColorCode: "#222220")
                navigationItem.backBarButtonItem = backItem
        }
}

extension ContactViewController: CenterViewController{
        func changeContext(viewType: MailActionType) {
        }
        
        func setDelegate(delegate: CenterViewControllerDelegate) {
                self.delegate = delegate
        }
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return self.contacts.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactItemTableViewCell", for: indexPath) as! ContactItemTableViewCell
                let c = contacts[indexPath.row]
                cell.populate(contact:c)
                return cell
        }
        
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                
                if editingStyle == .delete{
                        tableView.beginUpdates()
                        let c = contacts[indexPath.row]
                        BmailContact.removeContact(mailName: c.MailName)
                        contacts = Array(BmailContact.ContactsCache.values)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        tableView.endUpdates()
                }
        }
        
        func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
                return "Delete".locStr
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
                return true
        }
}
