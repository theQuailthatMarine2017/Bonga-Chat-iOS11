//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        

        SVProgressHUD.show()
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Registration Error", message: "Please check information given. Password must be 6 characters long and email must be correct", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("BACK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"BACK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
//                        let alertOkay = UIAlertController(title: "Successful!", message: "Welcome to Bonga Chat! Safe and Secure Chat Service!", preferredStyle: .alert)
//                        alertOkay.addAction(UIAlertAction(title: NSLocalizedString("CONTINUE", comment: "Default action"), style: .default, handler: { _ in
//                            NSLog("The \"CONTINUE\" alert occured.")
//                        }))
//                        self.present(alertOkay, animated: true, completion: nil)
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
                
            }
        }
        
        

        
        
    } 
    
    
}
