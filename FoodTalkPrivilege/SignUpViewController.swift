//
//  SignUpViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 11/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, WebServiceCallingDelegate, UITextFieldDelegate {
    
    @IBOutlet var txtName : UITextField?
    @IBOutlet var txtEmail : UITextField?
    @IBOutlet var txtPhone : UITextField?
    
    @IBOutlet var lineName : UIView?
    @IBOutlet var linePhone : UIView?
    @IBOutlet var lineEmail : UIView?
    
    @IBOutlet var btnVerify : UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK:- alertTapped
    
    func alertTap(){
        
        viewAlert.removeFromSuperview()
    }
    
    //MARK:- WebServiceCalling
    
    func callWebServiceForNumber(){
        showAnimationWithFrame(x: self.view.frame.size.width/2 - 30, y: (self.btnVerify?.frame.origin.y)! + 10, view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@", baseUrl,"getotp")
            let params = NSMutableDictionary()
            params.setObject(txtName?.text!, forKey: "name" as NSCopying)
            params.setObject(txtPhone?.text!, forKey: "phone" as NSCopying)
            params.setObject(txtEmail?.text!, forKey: "email" as NSCopying)
            params.setObject("1", forKey: "signup" as NSCopying)
            dictUserDetails = params
            webServiceCallingPost(url, parameters: params)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(SignUpViewController.alertTap), for: .touchUpInside)
        }
    }
    
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        print(dict)
        stopAnimation()
        if(dict.object(forKey: "status") as! String == "OK"){
            otpFrom = "signup"
            strOtp = dict.object(forKey: "result") as! String
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Login") as! LoginViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
        else{
            self.view.makeToast(dict.object(forKey: "message") as! String)
            if((dict.object(forKey: "message") as! String).contains("email")){
                lineEmail?.backgroundColor = .red
                txtEmail?.text = ""
            }
            else{
                
                let msg = String(format : "%@ is already registered, would you like to log in now?", (txtPhone?.text)!)
                
                
                let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                
                
                // Create the actions
                let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    mobileNumber = (self.txtPhone?.text)!
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "LoginNumber") as! LoginNumberViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
                let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation()
        self.view.isUserInteractionEnabled = true
        var counter = UserDefaults.standard.value(forKey: "counterSessionExpire") as! Int
        if(counter > 0){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            var ind = 0
            var isFind = false
            for vc in viewControllers{
                
                if(vc.isKind(of: ViewController.self)) {
                    UserDefaults.standard.setValue(nil, forKey: "userDetails")
                    UserDefaults.standard.setValue(nil, forKey: "session")
                    UserDefaults.standard.setValue(nil, forKey: "expiry")
                    UserDefaults.standard.setValue(0, forKey: "counterSessionExpire")
                    self.navigationController!.popToViewController(viewControllers[ind], animated: true);
                    isFind = true
                    break
                }
                ind = ind + 1
            }
            if(isFind == false){
                if(ind == viewControllers.count){
                    UserDefaults.standard.setValue(nil, forKey: "userDetails")
                    UserDefaults.standard.setValue(nil, forKey: "session")
                    UserDefaults.standard.setValue(nil, forKey: "expiry")
                    UserDefaults.standard.setValue(0, forKey: "counterSessionExpire")
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
            }
            
            counter = 0
            UserDefaults.standard.set(counter, forKey: "counterSessionExpire")
        }
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
    }
    
    //MARK:- textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == txtPhone){
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
            
        return (string == numberFiltered && newLength <= 10)
        }
        return true
    }
    
    //MARK:- verifyNumber Button Action
    
    @IBAction func verifyNumber(_ sender : UIButton){
        lineName?.backgroundColor = colorDarkGray
        lineEmail?.backgroundColor = colorDarkGray
        linePhone?.backgroundColor = colorDarkGray
        if((txtName?.text?.characters.count)! > 0){
            if((txtEmail?.text?.characters.count)! > 0){
                if((txtPhone?.text?.characters.count)! > 0){
                    if(validateEmail(enteredEmail: (txtEmail?.text)!) == true){
                        if((txtPhone?.text! as! NSString).length == 10){
                           callWebServiceForNumber()
                        }
                        else{
                            linePhone?.backgroundColor = .red
                            self.view.makeToast("Please enter valid Phone.")
                        }
                    }
                    else{
                        txtEmail?.text = ""
                        lineEmail?.backgroundColor = .red
                        self.view.makeToast("Please enter valid email.")
                    }
                    
                }
                else{
                    linePhone?.backgroundColor = .red
                    self.view.makeToast("Please enter your Phone.")
                }
            }
            else{
                lineEmail?.backgroundColor = .red
                self.view.makeToast("Please enter your email.")
            }
        }
        else{
           lineName?.backgroundColor = .red
           self.view.makeToast("Please enter your name.")
        }
        
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    @IBAction func back(_ sender : UIButton){
      self.navigationController?.popViewController(animated: true)
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
