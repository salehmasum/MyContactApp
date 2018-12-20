//
//  ViewController.swift
//  MyContactApp
//
//  Created by Saleh Masum on 20/12/18.
//  Copyright © 2018 Saleh Masum. All rights reserved.
//

import UIKit
import Contacts

class ContactController: UITableViewController {

    let cellID = "cellID"
    
    fileprivate var filteredContacts = [Contact]()
    fileprivate var filtering = false
    
    var contacts = [Contact]()
    var contactsWithSections = [[Contact]]()
    let collation = UILocalizedIndexedCollation.current() // create a locale collation object, by which we can get section index titles of current locale. (locale = local contry/language)
    var sectionTitles = [String]()
    
    private func fetchContacts(){
        
        let store = CNContactStore()
        
        store.requestAccess(for: (.contacts)) { (granted, err) in
            if let err = err{
                print("Failed to request access",err)
                return
            }
            
            if granted {
                print("Access granted")
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                fetchRequest.sortOrder = CNContactSortOrder.userDefault
                
                do {
                    try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, error) -> Void in
                        
                        guard let phoneNumber = contact.phoneNumbers.first?.value.stringValue else {return}
                        
                        guard let contactObject = Contact(givenName: contact.givenName, familyName: contact.familyName, mobile: phoneNumber, isFavorite: false) else { return }
                        
                        self.contacts.append(contactObject)
                        
                    })
                    
                    for index in self.contacts.indices{
                        
                        print(self.contacts[index].givenName)
                        print(self.contacts[index].familyName)
                        print(self.contacts[index].mobile)
                    }
                    
                    self.setUpCollation()
                    
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
                
                
            }else{
                print("Access denied")
            }
        }
        
    }
    
    let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.definesPresentationContext = true
        search.dimsBackgroundDuringPresentation = false
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //add search controller
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        //Changing section index color
        self.tableView.sectionIndexColor = UIColor.red
        
        // need to register a custom cell
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellID)
        
        fetchContacts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func setUpCollation(){
        let (arrayContacts, arrayTitles) = collation.partitionObjects(array: self.contacts, collationStringSelector: #selector(getter: Contact.givenName))
        self.contactsWithSections = arrayContacts as! [[Contact]]
        self.sectionTitles = arrayTitles
        
        print(contactsWithSections.count)
        print(sectionTitles.count)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if filtering == true {
            return 1
        }
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filtering == true {
            return filteredContacts.count
        }
        return contactsWithSections[section].count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
        
        let contact = filtering ? filteredContacts[indexPath.row] : contactsWithSections[indexPath.section][indexPath.row]
        cell.selectionStyle = .default
        cell.textLabel?.text = contact.givenName + " " + contact.familyName
        
        cell.textLabel?.font = contact.isFavorite ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //Changing color for the Letters in the section titles
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.red
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchController.dismiss(animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
        
        var selectedContact: Contact!
        
        if filtering == true {
            selectedContact = filteredContacts[indexPath.row]
        }else {
            selectedContact = contactsWithSections[indexPath.section][indexPath.row]
        }
    
        navigateToDetailController(selectedContact: selectedContact)
    }
    
    func navigateToDetailController(selectedContact: Contact) {
        
        let destinationController = ContactDetail()
        destinationController.selectedContact = selectedContact
        destinationController.delegate = self
        self.navigationController?.pushViewController(destinationController, animated: true)
    }

}

extension UILocalizedIndexedCollation {
    //func for partition array in sections
    func partitionObjects(array:[AnyObject], collationStringSelector:Selector) -> ([AnyObject], [String]) {
        var unsortedSections = [[AnyObject]]()
        
        //1. Create a array to hold the data for each section
        for _ in self.sectionTitles {
            unsortedSections.append([]) //appending an empty array
        }
        //2. Put each objects into a section
        for item in array {
            let index:Int = self.section(for: item, collationStringSelector:collationStringSelector)
            unsortedSections[index].append(item)
        }
        //3. sorting the array of each sections
        var sectionTitles = [String]()
        var sections = [AnyObject]()
        for index in 0 ..< unsortedSections.count { if unsortedSections[index].count > 0 {
            sectionTitles.append(self.sectionTitles[index])
            sections.append(self.sortedArray(from: unsortedSections[index], collationStringSelector: collationStringSelector) as AnyObject)
            }
        }
        return (sections, sectionTitles)
    }
}

extension ContactController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
         //when text is not empty
         if let text = searchController.searchBar.text, !text.isEmpty {
            print(text)
            
            self.filteredContacts = self.contacts.filter { (contact) -> Bool in
                return contact.givenName.lowercased().contains(text.lowercased())
                || contact.familyName.lowercased().contains(text.lowercased())
            }
            self.filtering = true
            
         }else {
            self.filtering = false
        }
        self.tableView.reloadData()
    }
    
}

extension ContactController: ContactFavoriteDelegate {
    
    func makeContactFavorite() {
        self.tableView.reloadData()
    }

}
