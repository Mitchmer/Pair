//
//  PersonListTableViewController.swift
//  Pair
//
//  Created by Mitch Merrell on 9/6/19.
//  Copyright © 2019 Mitch Merrell. All rights reserved.
//

import UIKit

class PersonListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PersonController.shared.loadFromPersistentStore()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if PersonController.shared.persons.count < 2 {
            return PersonController.shared.persons.count
        } else {
            return PersonController.shared.groups.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section + 1)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if PersonController.shared.persons.count == 0 {
            return 0
        } else {
            return PersonController.shared.groups[section].count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        let section = PersonController.shared.groups[indexPath.section]
        
        cell.textLabel?.text = section[indexPath.row].name
    
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let section = PersonController.shared.groups[indexPath.section]
            PersonController.shared.deleteGroup(group: section)
            
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet as IndexSet, with: .automatic)
            
            tableView.reloadData()
            
        }
    }
    
    // Actions
    
    @IBAction func addPersonButtonTapped(_ sender: Any) {
        addPersonAlert()
    }

    @IBAction func randomizeButtonTapped(_ sender: Any) {
        PersonController.shared.persons.shuffle()
        PersonController.shared.saveToPersistentStore()
        self.tableView.reloadData()
    }
    
    // Custom Methods
    
    func addPersonAlert() {
        let alert = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Person's name..."
        }
        let addPersonAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let personText = alert.textFields?[0].text else { return }
            if personText != "" {
                PersonController.shared.createPerson(name: personText)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(addPersonAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
