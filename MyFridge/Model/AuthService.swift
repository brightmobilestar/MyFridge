//
//  AuthService.swift
//  Mariner License Prep
//
//  Created by Alex on 2/1/18.
//  Copyright © 2018 Mariner License Prep. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    static let global = AuthService()
    
    var username = String()
    var email = String()
    var subscriptionStatus = true
    var profileImageURL = String()
    var profileImageUIImage = UIImage()
    
    
    
    //INITIALIZE USER DEFAULTS
    let defaults = UserDefaults.standard
    
    private init() {
        
        //SET SUB STATUS FROM MEMORY
        if let subStatus = defaults.object(forKey: "subStatus") {
            subscriptionStatus = subStatus as! Bool
        }
        
        
    }
    
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError(error?.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError(error?.localizedDescription)
                return
            } else {
               
                /*
                let uid = user?.uid
                let storageRef = Storage.storage().reference().child("profile_image").child(uid!)
                
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        onError(error?.localizedDescription)
                        return
                    } else {
                        let profileImageUrl = metadata?.downloadURL()?.absoluteString
                        self.setUserInformation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
                    }
                }
                */
            }
        }
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, firstName: String, lastName: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError(error?.localizedDescription)

            } else {
                
                let uid = user?.uid
                let storageRef = Storage.storage().reference().child("profile_image").child(uid!)
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        onError(error?.localizedDescription)
                        return
                    } else {
                        let profileImageUrl = metadata?.downloadURL()?.absoluteString
                        self.setUserInformation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, firstName: firstName, lastName: lastName, onSuccess: onSuccess)
                    }
                }
                
            }
        }
    }
    
    static func singUpFromFB(username: String, email: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        let uid = Auth.auth().currentUser?.uid
        let storageRef = Storage.storage().reference().child("profile_image").child(uid!)
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                onError(error?.localizedDescription)
                return
            } else {
                /*
                let profileImageUrl = metadata?.downloadURL()?.absoluteString
                self.setUserInformation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
                    */
            }
        }
    }
    
    static func setUserInformation(profileImageUrl: String, username: String, email: String, uid: String, firstName: String, lastName: String, onSuccess: @escaping () -> Void) {
        
        let ref = Database.database().reference()
        let userReference = ref.child("users")
        let newUserReference = userReference.child(uid)
        
        newUserReference.setValue(["username": username, "email": email,"profileImageURL": profileImageUrl, "firstName": firstName, "lastName": lastName])
        onSuccess()
    }
    
    
    static func resetPassword(email: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                // An error happened.
                onError(error?.localizedDescription)
            } else {
                // Password reset email sent.
                onSuccess()
            }
        }
    }
    
    
    static func changePassword(newPassword: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        
        if Auth.auth().currentUser != nil {
            Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                if error != nil {
                    onSuccess()
                }
                else {
                    onError(error?.localizedDescription)
                }
            })
        }
    }
    
    static func changeEmail(email: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        if Auth.auth().currentUser != nil {
            Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
                if error != nil {
                    if let uid = Auth.auth().currentUser?.uid {
                        let ref = Database.database().reference()
                        let userReference = ref.child("users")
                        let newUserReference = userReference.child(uid)
                        newUserReference.updateChildValues(["email": email])
                        onSuccess()
                    }
                    
                } else {
                    onError(error?.localizedDescription)
                }
            })
        }
    }
    
    
    
    static func submitBug(questionNumber: String, errorMessage: String, questionIllustration: String, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let userReference = ref.child("errors")
            let newUserReference = userReference.childByAutoId()
            newUserReference.setValue(["username":username, "email":email, "question number": questionNumber, "illustration": questionIllustration, "error message": errorMessage])
            onSuccess()
            
        }) { (error) in
            print(error.localizedDescription)
            onError()
        }
    }
    
    func retrieveUserName(username: @escaping (_ username: String?) -> Void) {
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        if Auth.auth().currentUser != nil {
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                if let usernameRetrieved = value?["username"] {
                    self.username = usernameRetrieved as! String
                    self.defaults.set(usernameRetrieved as! String, forKey: "username")
                    username(usernameRetrieved as? String)
                }
                
            })
        }
    }
    
    func retrieveUserEmail(email: @escaping (_ email: String?) -> Void) {
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        if Auth.auth().currentUser != nil {
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                if let emailRetrieved = value?["email"] {
                    self.email = emailRetrieved as! String
                    self.defaults.set(emailRetrieved as! String, forKey: "email")
                    email(emailRetrieved as? String)
                }
            })
        }
    }
    
    func retrieveSubscriptionStatus() {
        let ref = Database.database().reference()
        
        ref.child("subscriptions").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if let activated = value?["activateAllAccounts"] {
                
                if activated as! String == "true" {
                    
                    self.subscriptionStatus = true
                    self.defaults.set(true, forKey: "subStatus")
                    print("This is the fucking : \(true)")
                    
                }
                else if activated as! String == "false" {
                    
                    self.subscriptionStatus = false
                    self.defaults.set(false, forKey: "subStatus")
                    print("This is the fucking : \(false)")
                    
                    
                }
                
                
            }
        })
    }
    
    
    func retrieveUserInfo()  {
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        
        if Auth.auth().currentUser != nil {
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if let usernameRetrieved = value?["username"] {
                self.username = usernameRetrieved as! String
                self.defaults.set(usernameRetrieved as! String, forKey: "username")
                
            }
            if let emailRetrieved = value?["email"] {
                self.email = emailRetrieved as! String
                self.defaults.set(emailRetrieved as! String, forKey: "email")
                
            }
            if let profileImageURLRetrieved = value?["profileImageURL"] {
                self.profileImageURL = profileImageURLRetrieved as! String
                self.defaults.set(profileImageURLRetrieved as! String, forKey: "profileImageURL")
            }

            // Create a reference to the file you want to download
            
        })
       
    }
    }
    
   
    
    func retrieveProfilePicture(image: @escaping (_ image: UIImage?) -> Void) {
  
        let profileImageFromDatabase = Storage.storage().reference().child("profile_image").child((Auth.auth().currentUser?.uid)!)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        profileImageFromDatabase.getData(maxSize: 1 * 700 * 700) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                if let profilePicRetreived = UIImage(data: data!) {
                    self.profileImageUIImage = profilePicRetreived
                    image(profilePicRetreived)
                    
                }
                
            }
        }
    }
}
