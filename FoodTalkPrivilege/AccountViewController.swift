//
//  AccountViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 12/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class AccountViewController: UIViewController, UITextFieldDelegate,UIActionSheetDelegate, WebServiceCallingDelegate {
    
    @IBOutlet var lblName : UILabel?
    @IBOutlet var lblPhone : UILabel?
    @IBOutlet var txtName : UITextField?
    @IBOutlet var txtEmail : UITextField?
    
    @IBOutlet var btnDOB : UIButton?
    @IBOutlet var btnVegNonVeg : UIButton?
    @IBOutlet var btnGender : UIButton?
    
    @IBOutlet var lblExpire : UILabel?
    
    var datePicker = UIDatePicker()
    var doneButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FBSDKAppEvents.logEvent("profile_view")
        createDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dictUserDetails = UserDefaults.standard.object(forKey: "userDetails") as! NSDictionary
        
        let expire = UserDefaults.standard.object(forKey: "expiry") as! String
        let fullNameArr = expire.components(separatedBy: " ")
        
        let exp = fullNameArr[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let s = dateFormatter.date(from:exp)
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        let expireDate = dateFormatter.string(from: s!)
        lblExpire?.text = String(format : "Membership valid till %@", expireDate)
        
        lblName?.text = (dictUserDetails.object(forKey: "name") as? String)?.uppercased()
        lblPhone?.text = dictUserDetails.object(forKey: "phone") as? String
        
        txtName?.text = dictUserDetails.object(forKey: "name") as? String
        txtEmail?.text = dictUserDetails.object(forKey: "email") as? String
        
        if((dictUserDetails.object(forKey: "dob") as! String).characters.count > 0){
            btnDOB?.setTitle((dictUserDetails.object(forKey: "dob") as! String), for: .normal)
        }
        if((dictUserDetails.object(forKey: "gender") as! String).characters.count > 0){
            btnGender?.setTitle((dictUserDetails.object(forKey: "gender") as! String), for: .normal)
        }
        if((dictUserDetails.object(forKey: "preference") as! String).characters.count > 0){
            btnVegNonVeg?.setTitle((dictUserDetails.object(forKey: "preference") as! String), for: .normal)
        }
    }
    
    func createDatePicker(){
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 0, y: self.view.frame.size.height - 250, width: self.view.frame.width, height: 250)
        
        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        
        datePicker.datePickerMode = .date
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(AccountViewController.datePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        self.view.addSubview(datePicker)
        
        doneButton.frame = CGRect(x: 0,y: self.view.frame.size.height - 300, width: self.view.frame.size.width,height: 50)
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        doneButton.backgroundColor = .black
        
        self.view.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: #selector(AccountViewController.doneButton(_:)), for: UIControlEvents.touchUpInside)
        
        datePicker.isHidden = true
        doneButton.isHidden = true
    }
    
    func doneButton(_ sender : UIButton){
        datePicker.isHidden = true
        doneButton.isHidden = true
    }
    
    @IBAction func back(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectDOB(_ sender : UIButton){
        datePicker.isHidden = false
        doneButton.isHidden = false
    }
    
    @IBAction func selectVegNonVeg(_ sender : UIButton){
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Vegetarian", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Vegetarian", style: .default)
        { _ in
            self.btnVegNonVeg?.setTitle("Vegetarian", for: .normal)
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Non Vegetarian", style: .default)
        { _ in
            self.btnVegNonVeg?.setTitle("Non Vegetarian", for: .normal)
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    @IBAction func selectGender(_ sender : UIButton){
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select Gender", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Male", style: .default)
        { _ in
            self.btnGender?.setTitle("Male", for: .normal)
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Female", style: .default)
        { _ in
            self.btnGender?.setTitle("Female", for: .normal)
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender : UIButton){
        if((txtEmail?.text?.characters.count)! > 2){
            if((txtName?.text?.characters.count)! > 2){
                webServiceUpdate()
            }
        }
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        btnDOB?.setTitle(selectedDate, for: .normal)
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        
        viewAlert.removeFromSuperview()
        DispatchQueue.main.async{
            self.webServiceUpdate()
        }
    }
    
    func webServiceUpdate(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@?sessionid=%@", baseUrl,"user", session)
            let dict = NSMutableDictionary()
            dict.setObject(txtName?.text, forKey: "name" as NSCopying)
            dict.setObject(txtEmail?.text, forKey: "email" as NSCopying)
            if(btnDOB?.titleLabel?.text != "DD/MM/YYYY"){
               dict.setObject(btnDOB?.titleLabel?.text, forKey: "dob" as NSCopying)
            }
            if(btnVegNonVeg?.titleLabel?.text != "SELECT"){
                dict.setObject(btnVegNonVeg?.titleLabel?.text, forKey: "preference" as NSCopying)
            }
            if(btnGender?.titleLabel?.text != "SELECT"){
                dict.setObject(btnGender?.titleLabel?.text, forKey: "gender" as NSCopying)
            }
            
            webServiceCallingPut(url, parameters: dict)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(AccountViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        stopAnimation()
        if((dict.object(forKey: "status") as! String) == "OK"){
          let userDict = dict.object(forKey: "result") as! NSDictionary
          UserDefaults.standard.setValue(userDict, forKey: "userDetails")
          lblName?.text = userDict.object(forKey: "name") as? String
          self.view.makeToast("Successfully updated")
            self.perform(#selector(AccountViewController.backtoNavigate), with: nil, afterDelay: 1.0)
        }
    }
    
    func backtoNavigate(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation()
        self.view.isUserInteractionEnabled = true
        UserDefaults.standard.setValue(nil, forKey: "userDetails")
        UserDefaults.standard.setValue(nil, forKey: "session")
        UserDefaults.standard.setValue(nil, forKey: "expiry")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
