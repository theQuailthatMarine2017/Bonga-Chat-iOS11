//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messagesArray: [Message] = [Message]()
    

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self

        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        
        messageTableView.addGestureRecognizer(tapGesture)
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        confirgureTableView()
        retrieveMessages()
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messagesArray[indexPath.row].messageBody
        cell.senderUsername.text = messagesArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        cell.messageBackground.backgroundColor = UIColor.flatPlum()
        cell.senderUsername.textColor = UIColor.flatRed()
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            
           cell.messageBackground.backgroundColor = UIColor.flatPurple()
           cell.senderUsername.textColor = UIColor.flatGreen()
            
        }
        
        return cell
        
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesArray.count
        
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped() {
        
        messageTextfield.endEditing(true)
        
    }
    
    
    
    //TODO: Declare configureTableView here:
    func confirgureTableView() {
        
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.3){
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.3){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        //TODO: Send the message to Firebase and save it in our database
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDict = ["sender": Auth.auth().currentUser?.email, "messageBody": messageTextfield.text!]
        
        messagesDB.childByAutoId().setValue(messageDict) {
            (error, reference) in
            
            if error != nil {
                
                let alert = UIAlertController(title: "Sending Failed", message: "Something went wrong somewhere. Please try again or check your Internet Connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("BACK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"BACK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                self.retrieveMessages()
                
                self.messageTextfield.endEditing(false)
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                
            }
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let receivedMessage = snapshotValue["messageBody"]!
            let sender = snapshotValue["sender"]!
            
            let message = Message()
            message.sender = sender
            message.messageBody = receivedMessage
            
            self.messagesArray.append(message)
            
            self.confirgureTableView()
            self.messageTableView.reloadData()
            
        }
    }
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        
        
    }
    


}
