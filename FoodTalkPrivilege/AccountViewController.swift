//
//  AccountViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 12/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class AccountViewController: UIViewController, UITextFieldDelegate,UIActionSheetDelegate, WebServiceCallingDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet var lblExpire : UILabel?
    @IBOutlet var tblScreen : UITableView?
    
    var datePicker = UIDatePicker()
    var doneButton = UIButton()
    
    @IBOutlet var viewMarker : UIView?
    @IBOutlet var viewTop : UIView?
    
    var selectedScreen = "1"
    
    var arrHistory = NSMutableArray()
    var arrFavList = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblScreen!.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "UserProfileTableViewCell")
        tblScreen?.tableFooterView = UIView()
        tblScreen?.separatorColor = .lightGray
        
        tblScreen!.register(UINib(nibName: "HistoryCellTableViewCell", bundle: nil), forCellReuseIdentifier: "History")
        tblScreen?.tableFooterView = UIView()
        tblScreen?.separatorColor = .lightGray
        
        tblScreen!.register(UINib(nibName: "FavTableViewCell", bundle: nil), forCellReuseIdentifier: "Fav")
        tblScreen?.tableFooterView = UIView()
        tblScreen?.separatorColor = .lightGray
        
        viewMarker?.frame = CGRect(x: 20, y: (viewTop?.frame.size.height)! - 3, width: 100, height: 3)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK:- SwipeMethods
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if(selectedScreen != "1"){
                    if(selectedScreen == "2"){
                        viewMarker?.frame.origin.x = 20
                        selectedScreen = "1"
                    }
                    else if(selectedScreen == "3"){
                        DispatchQueue.main.async{
                            self.callWebServiceForHistory()
                        }
                        viewMarker?.frame.origin.x = self.view.frame.size.width/2 - 50
                        selectedScreen = "2"
                    }
                }
            case UISwipeGestureRecognizerDirection.left:
                if(selectedScreen != "3"){
                    if(selectedScreen == "1"){
                        DispatchQueue.main.async{
                            self.callWebServiceForHistory()
                        }
                        viewMarker?.frame.origin.x = self.view.frame.size.width/2 - 50
                        selectedScreen = "2"
                    }
                    else if(selectedScreen == "2"){
                        DispatchQueue.main.async{
                            self.callWebServiceForFavDeatils()
                        }
                        viewMarker?.frame.origin.x = self.view.frame.size.width - 120
                        selectedScreen = "3"
                    }
                }
            default:
                break
            }
        }
        tblScreen?.reloadData()
    }
    
    //MARK:- Tableview Delegate Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(selectedScreen == "1"){
           return 1
        }
        else if(selectedScreen == "2"){
           return arrHistory.count
        }
        else{
           return arrFavList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(selectedScreen == "1"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileTableViewCell", for: indexPath) as! UserProfileTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            dictUserDetails = UserDefaults.standard.object(forKey: "userDetails") as! NSDictionary
            cell.lblName?.text = (dictUserDetails.object(forKey: "name") as? String)?.uppercased()
            cell.lblPhone?.text = dictUserDetails.object(forKey: "phone") as? String
            //
            cell.txtName?.text = dictUserDetails.object(forKey: "name") as? String
            cell.txtEmail?.text = dictUserDetails.object(forKey: "email") as? String
            
            cell.txtName?.delegate = self
            cell.txtEmail?.delegate = self
            
        if((dictUserDetails.object(forKey: "dob") as! String).characters.count > 0){
            cell.btnDOB?.setTitle((dictUserDetails.object(forKey: "dob") as! String), for: .normal)
        }
        if((dictUserDetails.object(forKey: "gender") as! String).characters.count > 0){
                cell.btnGender?.setTitle((dictUserDetails.object(forKey: "gender") as! String), for: .normal)
        }
        if((dictUserDetails.object(forKey: "preference") as! String).characters.count > 0){
                cell.btnVegNonVeg?.setTitle((dictUserDetails.object(forKey: "preference") as! String), for: .normal)
        }
        
        
            createDatePicker(cell)
            cell.btnDOB?.addTarget(self, action: #selector(AccountViewController.selectDOB(_:)), for: .touchUpInside)
            
            cell.btnGender?.addTarget(self, action: #selector(AccountViewController.selectGender(_:)), for: .touchUpInside)
            
            cell.btnVegNonVeg?.addTarget(self, action: #selector(AccountViewController.selectVegNonVeg(_:)), for: .touchUpInside)
            
            cell.doneButton?.addTarget(self, action: #selector(AccountViewController.doneAction(_:)), for: .touchUpInside)
            return cell
        }
        else if(selectedScreen == "2"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "History", for: indexPath) as! HistoryCellTableViewCell
            
            cell.lblCouponUsed?.text = String(format: "Coupon used : %@", (arrHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "offers_redeemed") as! String)
            cell.lblRid?.text = String(format: "RID : %@", (arrHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String)
            cell.lbldate?.text = String(format: "%@", (arrHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "created_at") as! String)
            cell.lblName?.text = String(format: "%@", (arrHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as! String)
            
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Fav", for: indexPath) as! FavTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.lblName?.text = (arrFavList.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
            cell.lblDate?.text = (arrFavList.object(at: indexPath.row) as! NSDictionary).object(forKey: "created_at") as? String
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedScreen == "3"){
        restaurantName = ((arrFavList.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String)!
        offerIds = (arrFavList.object(at: indexPath.row) as! NSDictionary).object(forKey: "offer_id") as! String
        outletId = (arrFavList.object(at: indexPath.row) as! NSDictionary).object(forKey: "outlet_id") as! String
        
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "StoreDetails") as! StoreDetailsViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedScreen == "1"){
            return 538
        }
        else if(selectedScreen == "2"){
            return 122
        }
        else{
           return 84
        }
    }
    
    //MARK:- ButtonActions
    
    @IBAction func ProfileTap(_ sender : UIButton){
        viewMarker?.frame.origin.x = 20
        selectedScreen = "1"
        tblScreen?.reloadData()
    }
    
    @IBAction func HistoryTap(_ sender : UIButton){
        DispatchQueue.main.async{
            self.callWebServiceForHistory()
        }
        viewMarker?.frame.origin.x = self.view.frame.size.width/2 - 50
        selectedScreen = "2"
        tblScreen?.reloadData()
    }
    
    @IBAction func BookmarkTap(_ sender : UIButton){
        DispatchQueue.main.async{
            self.callWebServiceForFavDeatils()
        }
        viewMarker?.frame.origin.x = self.view.frame.size.width - 120
        selectedScreen = "3"
        tblScreen?.reloadData()
    }
    
    func createDatePicker(_ cell : UserProfileTableViewCell){
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
        
        let saveActionButton = UIAlertAction(title: "Yes", style: .default)
        { _ in
            sender.setTitle("Yes", for: .normal)
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "No", style: .default)
        { _ in
            sender.setTitle("No", for: .normal)
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    func selectGender(_ sender : UIButton){
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select Gender", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Male", style: .default)
        { _ in
            sender.setTitle("Male", for: .normal)
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Female", style: .default)
        { _ in
            sender.setTitle("Female", for: .normal)
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender : UIButton){
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = tblScreen?.cellForRow(at: indexPath) as! UserProfileTableViewCell
        if((cell.txtName?.text?.characters.count)! > 2){
            if((cell.txtEmail?.text?.characters.count)! > 2){
                webServiceUpdate(cell: cell)
            }
        }
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = tblScreen?.cellForRow(at: indexPath) as! UserProfileTableViewCell
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        cell.btnDOB?.setTitle(selectedDate, for: .normal)
    }
    
    //MARK:- alertTapped
    
    func alertTap(_ sender : UIButton){
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = tblScreen?.cellForRow(at: indexPath) as! UserProfileTableViewCell
        viewAlert.removeFromSuperview()
        DispatchQueue.main.async{
            self.webServiceUpdate(cell: cell)
        }
    }
    
    //MARK:- HistoryWebservice
    
    func callWebServiceForHistory(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@?%@=%@", baseUrl,"redeemhistory","sessionid",session)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HistoryViewController.alertTap), for: .touchUpInside)
        }
    }
    
    //MARK:- favWebservice
    
    func callWebServiceForFavDeatils(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@%@=%@", baseUrl,"bookmark?","sessionid",session)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(FavouritesViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func webServiceUpdate(cell : UserProfileTableViewCell){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@?sessionid=%@", baseUrl,"user", session)
            let dict = NSMutableDictionary()
            dict.setObject(cell.txtName?.text!, forKey: "name" as NSCopying)
            dict.setObject(cell.txtEmail?.text!, forKey: "email" as NSCopying)
            if(cell.btnDOB?.titleLabel?.text != "DD/MM/YYYY"){
               dict.setObject(cell.btnDOB?.titleLabel?.text!, forKey: "dob" as NSCopying)
            }
            if(cell.btnVegNonVeg?.titleLabel?.text != "SELECT"){
                dict.setObject(cell.btnVegNonVeg?.titleLabel?.text, forKey: "preference" as NSCopying)
            }
            if(cell.btnGender?.titleLabel?.text != "SELECT"){
                dict.setObject(cell.btnGender?.titleLabel?.text!, forKey: "gender" as NSCopying)
            }
            
            webServiceCallingPut(url, parameters: dict)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(AccountViewController.alertTap(_:)), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        viewAlert.subviews.forEach({ $0.removeFromSuperview() })
        viewAlert.removeFromSuperview()
        stopAnimation(view: self.view)
        if((dict.object(forKey: "api") as! String).contains("redeemhistory")){
            if(dict.object(forKey: "status") as! String == "OK"){
                arrHistory = (dict.object(forKey: "result") as! NSArray).mutableCopy() as! NSMutableArray
                tblScreen?.reloadData()
            }
            if(arrHistory.count == 0){
                problemArise = "history"
                openAlertScreen(self.view)
                alerButton.addTarget(self, action: #selector(AccountViewController.alertHistory), for: .touchUpInside)
            }
        }
        else if((dict.object(forKey: "api") as! String).contains("bookmark")){
            if(dict.object(forKey: "status") as! String == "OK"){
                arrFavList = (dict.object(forKey: "result") as! NSArray).mutableCopy() as! NSMutableArray
            }
            if(arrFavList.count == 0){
                problemArise = "fav"
                openAlertScreen(self.view)
                alerButton.addTarget(self, action: #selector(AccountViewController.alertFav), for: .touchUpInside)
            }
            tblScreen?.reloadData()
        }
        else{
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = tblScreen?.cellForRow(at: indexPath) as! UserProfileTableViewCell
        stopAnimation(view: self.view)
        if((dict.object(forKey: "status") as! String) == "OK"){
          let userDict = dict.object(forKey: "result") as! NSDictionary
          UserDefaults.standard.setValue(userDict, forKey: "userDetails")
          cell.lblName?.text = userDict.object(forKey: "name") as? String
          self.view.makeToast("Successfully updated")
        }
        }
    }
    
    func alertFav(){
        viewAlert.subviews.forEach({ $0.removeFromSuperview() })
        viewAlert.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    
    func alertHistory(){
        viewAlert.subviews.forEach({ $0.removeFromSuperview() })
        viewAlert.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    
    func backtoNavigate(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation(view: self.view)
        self.view.isUserInteractionEnabled = true
        UserDefaults.standard.setValue(nil, forKey: "userDetails")
        UserDefaults.standard.setValue(nil, forKey: "session")
        UserDefaults.standard.setValue(nil, forKey: "expiry")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
    }
    
    //MARK:- textfield delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Logout Method
    
    @IBAction func logoutMethod(_ sender : UIButton){
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let attrubuted = NSMutableAttributedString(string: "Are you sure ?")
        attrubuted.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 16), range: NSMakeRange(0, 14))
        alertController.setValue(attrubuted, forKey: "attributedTitle")
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            UserDefaults.standard.setValue(nil, forKey: "userDetails")
            UserDefaults.standard.setValue(nil, forKey: "session")
            UserDefaults.standard.setValue(nil, forKey: "expiry")
            UserDefaults.standard.setValue(nil, forKey: "token")
            UserDefaults.standard.setValue(nil, forKey: "city_id")
            FBSDKAppEvents.logEvent("logout")
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
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
