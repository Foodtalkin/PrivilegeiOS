//
//  InvoiceViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 03/11/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WebServiceCallingDelegate, PGTransactionDelegate {
    
    @IBOutlet var tblView : UITableView?
    
    var dictInvoice = NSDictionary()
    var dictParaPayTm = NSDictionary()
    var isPurchased : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView?.register(UINib(nibName: "ExperienceDetailsImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ExperienceDetailsImageTableViewCell")
        tblView?.register(UINib(nibName: "InvoiceTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceTableViewCell")
        tblView?.tableFooterView = UIView()
        tblView?.separatorColor = .clear
        self.title = "BOOKING"
        
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [ NSFontAttributeName: UIFont(name: fontAbril, size: 18)!, NSForegroundColorAttributeName: UIColor.white]
        
        
        var backImage: UIImage = UIImage(named: "fill301.png")!
        backImage = backImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        
        DispatchQueue.main.async{
         self.callWebService()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        if(isPurchased == true){
            
            self.callWebServiceSubscribe()
            isPurchased = false
        }
    }
    
    //MARK:- tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(dictInvoice.count > 0){
           return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceDetailsImageTableViewCell", for: indexPath) as! ExperienceDetailsImageTableViewCell
            cell.lblName?.text = dictExp.object(forKey: "title") as? String
            cell.lblAddress?.text = dictExp.object(forKey: "address") as? String
       //     cell.lblDate?.text = dictExp.object(forKey: "display_time") as? String
            
            let str = dictExp.object(forKey: "display_time") as? String
            
            if let range = str?.range(of: "\n") {
                let startPos = str?.distance(from: (str?.startIndex)!, to: range.lowerBound)
                let myMutableString = NSMutableAttributedString(string: str!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
                myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:startPos!,length: (str?.characters.count)! - startPos!))
                
                myMutableString.addAttribute(NSFontAttributeName, value : UIFont.systemFont(ofSize: 13), range: NSRange(location:startPos!,length: (str?.characters.count)! - startPos!))
                
                cell.lblDate?.attributedText = myMutableString
            }
            else {
             //   print("String not present")
                cell.lblDate?.text = dictExp.object(forKey: "display_time") as? String
            }
            
            
            let origImage = UIImage(named: "mapE.png")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            cell.imgMap?.image = tintedImage
            cell.imgMap?.tintColor = .lightGray
            
            let origImage1 = UIImage(named: "clock.png")
            let tintedImage1 = origImage1?.withRenderingMode(.alwaysTemplate)
            cell.imgClock?.image = tintedImage1
            cell.imgClock?.tintColor = .lightGray
            
            setImageWithUrl((dictExp.object(forKey: "cover_image") as? String)!, imgView: cell.imgView!)
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceTableViewCell", for: indexPath) as! InvoiceTableViewCell
            cell.selectionStyle = .none
            if(non_veg_pref == "0"){
               cell.lblVegNonVeg?.isHidden = true
            }
            else{
               cell.lblVegNonVeg?.isHidden = false
            }
            cell.lblVegNonVeg?.text = String(format : "VEG : %d | NON VEG : %@", Int(totalGuest)! - Int(nonVegNumber)!, nonVegNumber)
            cell.lblSubtottal?.text = String(format : "SUBTOTAL: %@ * %@", totalGuest, dictInvoice.object(forKey: "cost_for_one") as! String)
            cell.lblSubtotalValue?.text = String(format : "\u{20B9} %@", dictInvoice.object(forKey: "cost") as! NSNumber)
            cell.lblConvinienceFee?.text = String(format : "\u{20B9} %@", dictInvoice.object(forKey: "convenience_fee") as! NSNumber)
            cell.lblTaxesValue?.text = String(format : "\u{20B9} %@", dictInvoice.object(forKey: "taxes") as! NSNumber)
            cell.lblTotal?.text = String(format : "\u{20B9} %@", dictInvoice.object(forKey: "amount") as! NSNumber)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 228
        }
        else{
            return 198
        }
    }
    
    //MARK:- webservice delegate
    
    func callWebService(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@%@/%@%@sessionid=%@", baseUrl,"experiences/", idExperience,"order/","estimate?", session)
            let dict = NSMutableDictionary()
            dict.setObject(totalGuest, forKey: "total_tickets" as NSCopying)
            dict.setObject(nonVegNumber, forKey: "non_veg" as NSCopying)
            
            webServiceCallingPost(url, parameters: dict)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(InvoiceViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        
        stopAnimation(view: self.view)
        if((dict.object(forKey: "api") as! String).contains("estimate")){
        if(dict.object(forKey: "status") as! String == "OK"){
          dictInvoice = dict.object(forKey: "result") as! NSDictionary
        }
        }
        else if((dict.object(forKey: "api") as! String).contains("orderstatus")){
           if((dict.object(forKey: "result") as! NSDictionary).object(forKey: "payment_status") as! String == "TXN_FAILURE"){
              transactionResult = "failure"
            }
           else{
            transactionResult = "success"
            }
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Success") as! SuccessViewController;
            self.navigationController!.pushViewController(openPost, animated: true)
        }
        else{
            dictParaPayTm = dict.object(forKey: "result") as! NSDictionary
            transactionID = dictParaPayTm.object(forKey: "ORDER_ID") as! String
            callPaytm()
        }
        tblView?.reloadData()
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation(view: self.view)
        
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
    }
    
    func webCallForPaytm(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@%@/%@sessionid=%@", baseUrl,"experiences/", idExperience,"order?", session)
            let dict = NSMutableDictionary()
            dict.setObject(totalGuest, forKey: "total_tickets" as NSCopying)
            dict.setObject(nonVegNumber, forKey: "non_veg" as NSCopying)
            
            webServiceCallingPost(url, parameters: dict)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(InvoiceViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func callWebServiceSubscribe(){
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@%@%@?sessionid=%@", baseUrl,"experiences/", "orderstatus/",transactionID, session)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(InvoiceViewController.alertTap), for: .touchUpInside)
        }
    }
    
    @IBAction func paytmTap(_ sender : UIButton){
        DispatchQueue.main.async{
         self.webCallForPaytm()
        }
    }
    
    func callPaytm(){
        let merchantConfig = PGMerchantConfiguration.default()
        
        let order: PGOrder = PGOrder(params: dictParaPayTm as! [AnyHashable : Any])
        let transactionController = PGTransactionViewController.init(transactionFor: order)
        transactionController? .serverType = eServerTypeProduction
        transactionController? .merchant = merchantConfig
        transactionController? .delegate = self
        self.showController(transactionController!)
    }
    
    func showController(_ controller : PGTransactionViewController){
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func removeController(_ controller : PGTransactionViewController){
        self.navigationController?.popViewController(animated: true)
    }
    
    func didCancelTrasaction(_ controller: PGTransactionViewController!) {
        print("Transaction has been Cancelled")
        comingSuccessFrom = "Event"
        transactionResult = "failure"
        self.removeController(controller)
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Success") as! SuccessViewController;
        self.navigationController!.pushViewController(openPost, animated: true)
    }
    
    func didFinishedResponse(_ controller: PGTransactionViewController!, response responseString: String) {
        comingSuccessFrom = "Event"
        isPurchased = true
        eventNamePurchased = (dictExp.object(forKey: "title") as? String)!
        self.removeController(controller)
    }
    
    func errorMisssingParameter(_ controller: PGTransactionViewController!, error: Error!) {
        print(error)
    }

    //MARK:- alertTapped
    
    func alertTap(){
        dictInvoice = NSDictionary()
        
        DispatchQueue.main.async{
            self.callWebService()
        }
        viewAlert.removeFromSuperview()
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
