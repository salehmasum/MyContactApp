//
//  ContactDetail.swift
//  MyContactApp
//
//  Created by Saleh Masum on 20/12/18.
//  Copyright © 2018 Saleh Masum. All rights reserved.
//

import UIKit

protocol ContactFavoriteDelegate {
    func makeContactFavorite()
}

class ContactDetail: UIViewController {
    
    var selectedContact: Contact?
    var delegate: ContactFavoriteDelegate?
    
    let givenNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let familyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let mobileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    
    let favoriteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let favButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(makeThisContactFavorite), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func makeThisContactFavorite() {
        self.selectedContact!.isFavorite = !self.selectedContact!.isFavorite
        favButton.tintColor = self.selectedContact!.isFavorite ? .red : .lightGray
        self.delegate?.makeContactFavorite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //set button tit color based on model
        favButton.tintColor = self.selectedContact!.isFavorite ? .red : .lightGray
        
        navigationItem.title = "Contact Detail"
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        
        guard let choosenContact = selectedContact else {  return }
        
        let attributedGivenName = NSMutableAttributedString(string: "Given Name:  ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        attributedGivenName.append(NSAttributedString(string: choosenContact.givenName, attributes: [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 18)]))
        
        let attributedFamilyName = NSMutableAttributedString(string: "Family Name:  ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        attributedFamilyName.append(NSAttributedString(string: choosenContact.familyName, attributes: [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 18)]))
        
        let attributedMobileText = NSMutableAttributedString(string: "Mobile Number:  ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        attributedMobileText.append(NSAttributedString(string: choosenContact.mobile, attributes: [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 18)]))
        
        let attributedFavoriteText = NSMutableAttributedString(string: "Make Favorite:  ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        
        givenNameLabel.attributedText = attributedGivenName
        familyNameLabel.attributedText = attributedFamilyName
        mobileLabel.attributedText  = attributedMobileText
        favoriteLabel.attributedText = attributedFavoriteText
        
        view.addSubview(givenNameLabel)
        view.addSubview(familyNameLabel)
        view.addSubview(mobileLabel)
        view.addSubview(favoriteLabel)
        view.addSubview(favButton)
        
        givenNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive  = true
        givenNameLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        givenNameLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 12).isActive = true
        givenNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        familyNameLabel.topAnchor.constraint(equalTo: givenNameLabel.bottomAnchor, constant: 12).isActive  = true
        familyNameLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        familyNameLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 12).isActive = true
        familyNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        mobileLabel.topAnchor.constraint(equalTo: familyNameLabel.bottomAnchor, constant: 12).isActive  = true
        mobileLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        mobileLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 12).isActive = true
        mobileLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        favoriteLabel.topAnchor.constraint(equalTo: mobileLabel.bottomAnchor, constant: 12).isActive  = true
        favoriteLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        favoriteLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 12).isActive = true
        favoriteLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        favButton.topAnchor.constraint(equalTo: favoriteLabel.topAnchor, constant: -10).isActive  = true
        favButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        favButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        favButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
}
