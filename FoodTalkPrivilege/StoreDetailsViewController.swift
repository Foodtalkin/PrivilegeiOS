
//
//  StoreDetailsViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 24/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import MapKit

var arrImages = NSArray()
var indexSelectedImage = 0
var dictDetails = NSDictionary()
var numberRedeem = String()

class StoreDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, iCarouselDataSource, iCarouselDelegate, WebServiceCallingDelegate, UIScrollViewDelegate {
    
    @IBOutlet var tblStore : UITableView?
    @IBOutlet var viewDown : UIView?
    @IBOutlet var lineHr : UIView?
    @IBOutlet var lblRedeem : UILabel?
    @IBOutlet var lblCoupons : UILabel?
    @IBOutlet var lblSelectCoupons : UILabel?
    @IBOutlet var lblNumber : UILabel?
    @IBOutlet var lblNavTitle : UILabel?
    
    @IBOutlet var btnSub : UIButton?
    @IBOutlet var btnAdd : UIButton?
    @IBOutlet var btnCancel : UIButton?
    @IBOutlet var btnNext : UIButton?
    @IBOutlet var btnFav : UIButton?
    
    @IBOutlet var lblDiners : UILabel?
    @IBOutlet var lblNumberCoupons : UILabel?
    @IBOutlet var lblDiner1 : UILabel?
    @IBOutlet var lblDiner2 : UILabel?
    @IBOutlet var lblDiner3 : UILabel?
    
    @IBOutlet var lblNumberCoupons1 : UILabel?
    @IBOutlet var lblNumberCoupons2 : UILabel?
    @IBOutlet var lblNumberCoupons3 : UILabel?
    
    @IBOutlet var lblTip1 : UILabel?
    @IBOutlet var lblTip2 : UILabel?
    @IBOutlet var lblTip3 : UILabel?
    
    var arrTableRedeem = NSArray()
    
    var offer_outlet_id = ""
    var couponCounter : Int = 1
    
    var isReadMore : Bool = false
    var arrCousins = NSArray()
    var arrFoodSugest = NSArray()
    
    var isBookmark = "0"
    var purchaseLimit = "0"
    var arrPhoneNumbers = NSArray()
    
    var imgDetails = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblStore!.register(UINib(nibName: "StoreImageTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreCell")
        tblStore!.register(UINib(nibName: "AddressCussineTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        tblStore!.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
        tblStore!.register(UINib(nibName: "ImagesTableViewCell", bundle: nil), forCellReuseIdentifier: "ImagesCell")
        tblStore!.register(UINib(nibName: "FoodTalkSuggestTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodSugestionCell")
        tblStore?.tableFooterView = UIView()
        tblStore?.separatorColor = .lightGray
        
        tblStore?.estimatedRowHeight = 153
        tblStore?.rowHeight = UITableViewAutomaticDimension
        tblStore?.backgroundColor = colorDarkGray
        
        setBase()
        
        DispatchQueue.main.async{
            self.callWebServiceForDeatils()
        }
        
        lblNavTitle?.text = "FOOD TALK"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblStore?.reloadData()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imgDetails.image = UIImage(named : "mask.png")
    }
    
    //MARK:- tableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblStore){
            return 6
        }
        else{
            return arrFoodSugest.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tblStore){
        if(indexPath.row == 5){
         var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
         if (cell == nil) {
            cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
         }
            cell?.selectionStyle = .none
            cell?.textLabel?.text = "RULES OF USE"
            cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            cell?.textLabel?.textColor = colorBrightSkyBlue
         return cell!
        }
        else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCussineTableViewCell
            
            cell.lblAddress?.text = dictDetails.object(forKey: "address") as? String
            let strAddress = dictDetails.object(forKey: "work_hours") as? String
            let newString = strAddress?.replacingOccurrences(of: ",", with: "\n")
            cell.lblTime?.text = newString
            if(arrCousins.count > 0){
            var strCusin = (arrCousins.object(at: 0) as! NSDictionary).object(forKey: "title") as? String
            for index in 1..<arrCousins.count{
                strCusin = String(format : "%@, %@",strCusin!,((arrCousins.object(at: index) as! NSDictionary).object(forKey: "title") as? String)!)
            }
            cell.lblCuisines?.text = strCusin
            }
            
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionTableViewCell
            cell.selectionStyle = .none
            if(dictDetails.count > 0){
            cell.lblDescribe?.text = dictDetails.object(forKey: "description") as? String
            cell.btnReadMore?.addTarget(self, action: #selector(StoreDetailsViewController.btnReadMore(_:)), for: .touchUpInside)
            }
            if(isReadMore == true){
                cell.lblDescribe?.frame.size.height = (cell.lblDescribe?.frame.size.height)! + 20
            }
            
            return cell
        }
        else if(indexPath.row == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesCell", for: indexPath) as! ImagesTableViewCell
            cell.selectionStyle = .none
            cell.carousal?.frame = CGRect(x: 0, y: 52, width: self.view.frame.size.width, height : 90)
            cell.carousal?.type = .linear
            cell.carousal?.dataSource = self
            cell.carousal?.delegate = self
            cell.carousal?.scrollToItem(at: 1, animated: false)
            cell.carousal?.reloadData()
            return cell
        }
        else if(indexPath.row == 4){
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodSugestionCell", for: indexPath) as! FoodTalkSuggestTableViewCell
            cell.selectionStyle = .none
            cell.tblSuggest?.separatorColor = .clear
            cell.tblSuggest?.dataSource = self
            cell.tblSuggest?.delegate = self
            return cell
        }
        else{
           let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreImageTableViewCell
            cell.selectionStyle = .none
            if(dictDetails.count > 0){
            cell.lblTitle?.text = restaurantName
            let url = dictDetails.object(forKey: "cover_image") as? String
          
                let img = UIImage(named : "mask.png")
         
                DispatchQueue.main.async{
                    setPlaceHolderImage(with: url!, placeholderImage: img!, imgView: cell.imgOffer!)
                }
            cell.lblArea?.text = dictDetails.object(forKey: "area") as? String
            cell.lblDescribe?.text = dictDetails.object(forKey: "short_description") as? String
                imgDetails = cell.imgOffer!
                let amount = (dictDetails.object(forKey: "cost") as! NSString).intValue
                if(amount < 500){
                    cell.lblRupee?.text = String(format : "%@", "\u{20B9}")
                }
                else if(amount < 999){
                    cell.lblRupee?.text = String(format : "%@%@", "\u{20B9}", "\u{20B9}")
                }
                else{
                    cell.lblRupee?.text = String(format : "%@%@%@", "\u{20B9}", "\u{20B9}", "\u{20B9}")
                }
            }
            return cell
        }
        }
        else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
            if (cell == nil) {
                cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
            }
            if(arrFoodSugest.count > 0){
            cell?.textLabel?.text = arrFoodSugest.object(at: indexPath.row) as?String
            }
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = colorDarkGray
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tblStore){
        if(indexPath.row == 0){
            return 320
        }
        else if(indexPath.row == 1){
            return 255
        }
        else if(indexPath.row == 2){
            if(isReadMore == false){
            return 125
            }
            else{
                return UITableViewAutomaticDimension
            }
        }
        else if(indexPath.row == 3){
            if(arrImages.count > 0){
            return 153
            }
            else{
                return 64
            }
        }
        else if(indexPath.row == 4){
           return CGFloat(40 + (37 * arrFoodSugest.count))
        }
        else{
            return 44
        }
        }
        else{
            return 35
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == tblStore){
            if(btnCancel?.isHidden == false){
            if(indexPath.row == 5){
                rules = "http://foodtalk.in/app/rules.html"
                selectedWebType = "rules"
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Web") as! WebViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
                tblStore?.alpha = 1.0
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.viewDown?.frame = CGRect(x: 0, y: self.view.frame.size.height - 67, width: self.view.frame.size.width, height: 375)
                })
                btnCancel?.isHidden = true
                btnNext?.isHidden = true
            }
            else{
                if(indexPath.row == 5){
                    rules = "http://foodtalk.in/app/rules.html"
                    selectedWebType = "rules"
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Web") as! WebViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                } 
            }
        }
    }
    
    //MARK:- Carousal datasource and delegate
    
    //MARK:- CarousalDelegates
    
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return arrImages.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        var itemView: UIView
        //create new view if no view is available for recycling
        if (view == nil)
        {
            itemView = UIView(frame:CGRect(x: 0, y:0, width:carousel.frame.size.height, height:carousel.frame.size.height))
            itemView.backgroundColor = .gray
            let img = UIImageView(frame : CGRect(x: 0, y: 0, width: itemView.frame.size.width, height: itemView.frame.size.height))
            itemView.addSubview(img)
            var url = ""
            if(arrImages.count > 0){
                url = (arrImages.object(at: index) as! NSDictionary).object(forKey: "url") as! String
                DispatchQueue.main.async {
                 setImageWithUrl(url, imgView: img)
                }
            }
        }
        else{
          itemView = view!;
        }
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .spacing)
        {
            return value + 0.20
        }
        if (option == .wrap)
        {
            return 0
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        indexSelectedImage = index
        
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "FullImage") as! FullImageViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        if(carousel.currentItemIndex == 0){
            carousel.scrollToItem(at: 1, animated: false)
        }
    }
    
    //MARK:- buttonAction
    
    @IBAction func backTabbed(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func redeemAction(_ sender : UIButton){
        if(loginAs == "user"){
            tblStore?.alpha = 0.09
            tblStore?.tintColor = UIColor.lightGray
            if(arrTableRedeem.count > 0){
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.viewDown?.frame = CGRect(x: 0, y: self.view.frame.size.height - 375, width: self.view.frame.size.width, height: 375)
                })
            }
            else{
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.viewDown?.frame = CGRect(x: 0, y: self.view.frame.size.height - 290, width: self.view.frame.size.width, height: 290)
                })
            }
        btnCancel?.isHidden = false
        btnNext?.isHidden = false
        }
        else{
            buyClicked()
        }
    }
    
    func buyClicked(){
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "BuySignup") as! BuySignupViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }

    
    //MARK:- setBaseView
    
    func setBase(){
        viewDown?.frame = CGRect(x: 0, y: self.view.frame.size.height - 67, width: self.view.frame.size.width, height: 375)
        
        let btnReedemOpen = UIButton (frame : CGRect(x: 60, y: 0, width: self.view.frame.size.width - 120, height : 67))
        btnReedemOpen.addTarget(self, action: #selector(StoreDetailsViewController.redeemAction(_:)), for: .touchUpInside)
        viewDown?.addSubview(btnReedemOpen)
        
        if(loginAs == "guest"){
            lblRedeem?.text = "BUY NOW"
            lblCoupons?.isHidden = true
        }
        else{
            lblRedeem?.text = "REDEEM"
            lblCoupons?.isHidden = false
        }
        
        lineHr?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1)
        lblRedeem?.frame = CGRect(x: 0, y: 17, width: self.view.frame.size.width, height: 27)
        lblCoupons?.frame = CGRect(x: 0, y: 39, width: self.view.frame.size.width, height: 21)
        lblSelectCoupons?.frame = CGRect(x: 0, y: 98, width: self.view.frame.size.width, height: 21)
        lblNumber?.frame = CGRect(x: self.view.frame.size.width/2 - 30, y: 139, width: 60, height: 55)
        btnAdd?.frame = CGRect(x: (lblNumber?.frame.origin.x)! + (lblNumber?.frame.size.width)! + 20, y: 147, width: 46, height: 40)
        btnSub?.frame = CGRect(x: (lblNumber?.frame.origin.x)! - 66, y: 139, width: 46, height: 44)
        
        btnCancel?.frame = CGRect(x: 0, y: 13, width: 44, height: 44)
        btnNext?.frame = CGRect(x: self.view.frame.size.width - 100, y: 15, width: 100, height: 40)
        
        lblNumber?.text = String(format : "%d", couponCounter)
        
        btnCancel?.isHidden = true
        btnNext?.isHidden = true
        btnSub?.alpha = 0.5
        
        lblDiners?.frame = CGRect(x: 0, y: (lblNumber?.frame.origin.y)! + (lblNumber?.frame.size.height)! + 15, width : 150, height : 40)
        lblNumberCoupons?.frame = CGRect(x: 0, y: (lblDiners?.frame.origin.y)! + (lblDiners?.frame.size.height)!, width : 150, height : 40)
        lblDiner1?.frame = CGRect(x: 150, y: (lblNumber?.frame.origin.y)! + (lblNumber?.frame.size.height)! + 15, width : (self.view.frame.size.width - 150)/3, height : 40)
        lblDiner2?.frame = CGRect(x: (lblDiner1?.frame.origin.x)! + (lblDiner1?.frame.size.width)!, y: (lblNumber?.frame.origin.y)! + (lblNumber?.frame.size.height)! + 15, width : (self.view.frame.size.width - 150)/3, height : 40)
        lblDiner3?.frame = CGRect(x: (lblDiner2?.frame.origin.x)! + (lblDiner2?.frame.size.width)!, y: (lblNumber?.frame.origin.y)! + (lblNumber?.frame.size.height)! + 15, width : (self.view.frame.size.width - 150)/3, height : 40)
        lblNumberCoupons1?.frame = CGRect(x: 150, y: (lblDiners?.frame.origin.y)! + (lblDiners?.frame.size.height)!, width : (self.view.frame.size.width - 150)/3, height : 40)
        lblNumberCoupons2?.frame = CGRect(x: (lblNumberCoupons1?.frame.origin.x)! + (lblNumberCoupons1?.frame.size.width)!, y: (lblDiners?.frame.origin.y)! + (lblDiners?.frame.size.height)!, width : (self.view.frame.size.width - 150)/3, height : 40)
        lblNumberCoupons3?.frame = CGRect(x: (lblNumberCoupons2?.frame.origin.x)! + (lblNumberCoupons2?.frame.size.width)!, y: (lblDiners?.frame.origin.y)! + (lblDiners?.frame.size.height)!, width : (self.view.frame.size.width - 150)/3, height : 40)
        
        lblTip1?.frame = CGRect(x: 20, y: (lblNumberCoupons3?.frame.origin.y)! + (lblNumberCoupons3?.frame.size.height)! + 10, width : self.view.frame.size.width - 20, height : 15)
        lblTip2?.frame = CGRect(x: 20, y: (lblTip1?.frame.origin.y)! + (lblTip1?.frame.size.height)! + 2, width : self.view.frame.size.width - 20, height : 15)
        lblTip3?.frame = CGRect(x: 20, y: (lblTip2?.frame.origin.y)! + (lblTip2?.frame.size.height)! + 2, width : self.view.frame.size.width - 20, height : 15)
        
        createLayer(lblDiners!)
        createLayer(lblNumberCoupons!)
        createLayer(lblDiner1!)
        createLayer(lblDiner2!)
        createLayer(lblDiner3!)
        createLayer(lblNumberCoupons1!)
        createLayer(lblNumberCoupons2!)
        createLayer(lblNumberCoupons3!)
    }
    
    func createLayer(_ lblPopUp : UILabel){
        lblPopUp.layer.borderWidth = 1
        lblPopUp.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func subtract(_ sender : UIButton){
        if(couponCounter > 1){
            
            couponCounter = couponCounter - 1
            lblNumber?.text = String(format : "%d", couponCounter)
            if(couponCounter == 1){
                sender.alpha = 0.5
                btnAdd?.alpha = 1.0
            }
            else{
                sender.alpha = 1.0
                btnAdd?.alpha = 1.0
            }
        }
        else{
            
        }
    }
    
    @IBAction func add(_ sender : UIButton){
        if(couponCounter < Int(purchaseLimit)!){
            
            couponCounter = couponCounter + 1
            lblNumber?.text = String(format : "%d", couponCounter)
            if(couponCounter == Int(purchaseLimit)){
                sender.alpha = 0.5
                btnSub?.alpha = 1.0
            }
            else{
                sender.alpha = 1.0
                btnSub?.alpha = 1.0
            }
        }
        else{
            
        }
    }
    
    @IBAction func cancelTapped(_ sender : UIButton){
        tblStore?.alpha = 1.0
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.viewDown?.frame = CGRect(x: 0, y: self.view.frame.size.height - 67, width: self.view.frame.size.width, height: 375)
        })
        btnCancel?.isHidden = true
        btnNext?.isHidden = true
    }
    
    @IBAction func nextTapped(_ sender : UIButton){
        if(loginAs == "user"){
         
            numberRedeem = (lblNumber?.text)!
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "RestaurantPin") as! RestaurantPinViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
        else{
            
        }
    }
    
    func btnReadMore(_ sender : UIButton){
        if (isReadMore == false){
            isReadMore = true
            sender.setTitle("Read Less", for: .normal)
            tblStore?.reloadData()
        }
        else{
            isReadMore = false
            sender.setTitle("Read More", for: .normal)
            tblStore?.reloadData()
        }
    }
    
    //MARK:- Favorite tapped
    
    @IBAction func favTapped(_ sender : UIButton){
        if(isBookmark == "0"){
        if(loginAs == "user"){
        let origImage = UIImage(named: "favWhite.png")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        sender.setImage(tintedImage, for: .normal)
        sender.tintColor = .green
        isBookmark = "1"
        self.view.makeToast("Bookmarked Successfully")
        callWebServiceForFav()
        }
        else{
            buyClicked()
        }
        }
        else{
            if(loginAs == "user"){
                let origImage = UIImage(named: "favWhite.png")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                sender.setImage(tintedImage, for: .normal)
                sender.tintColor = .white
                isBookmark = "0"
                callWebServiceForUnFav()
            }
            else{
                buyClicked()
            }
        }
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        
        viewAlert.removeFromSuperview()
        DispatchQueue.main.async{
            self.callWebServiceForDeatils()
        }
    }
    
    //MARK:- webServiceCalling
    
    func callWebServiceForFav(){
        
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@/%@/%@?sessionid=%@", baseUrl,"bookmark",offer_outlet_id, session)
            let dict = NSDictionary()
            webServiceCallingPost(url, parameters: dict)
            delegate = self
        }
        else{
            
        }
    }
    
    func callWebServiceForUnFav(){
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@/%@/%@?sessionid=%@", baseUrl,"bookmark",offer_outlet_id, session)
            let dict = NSDictionary()
            webServiceCallingDelete(url, parameters: dict)
            delegate = self
        }
        else{
            
        }
    }
    
    func callWebServiceForDeatils(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            if(loginAs == "user"){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@%@/%@%@?sessionid=%@", baseUrl,"outlet/",outletId,"offer/",offerIds, session)
            webServiceGet(url)
            delegate = self
            }
            else{
            let url = String(format: "%@%@%@/%@%@", baseUrl,"outlet/",outletId,"offer/",offerIds)
            
            webServiceGet(url)
            delegate = self
            }
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(StoreDetailsViewController.alertTap), for: .touchUpInside)
        }
    }
    
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        
        stopAnimation()
        if((dict.object(forKey: "api") as! String).contains("bookmark")){
            if(dict.object(forKey: "status") as! String == "OK"){
                
            }
        }
        else{
            
        if(dict.object(forKey: "status") as! String == "OK"){
        dictDetails = dict.object(forKey: "result") as! NSDictionary
        
        isBookmark = dictDetails.object(forKey: "is_bookmarked") as! String
         
            if(isBookmark == "1"){
                let origImage = UIImage(named: "favWhite.png")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                btnFav?.setImage(tintedImage, for: .normal)
                btnFav?.tintColor = .green
            }
            else{
                let origImage = UIImage(named: "favWhite.png")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                btnFav?.setImage(tintedImage, for: .normal)
                btnFav?.tintColor = .white
            }
        
        offer_outlet_id = dictDetails.object(forKey: "outlet_offer_id") as! String
        arrImages = dictDetails.object(forKey: "images") as! NSArray
        arrCousins = dictDetails.object(forKey: "cuisine") as! NSArray
        let strSuggest = dictDetails.object(forKey: "suggested_dishes") as! String
        let fullNameArr : [String] = strSuggest.components(separatedBy: ", ")
        arrFoodSugest = fullNameArr as NSArray
        purchaseLimit = dictDetails.object(forKey: "purchase_limit") as! String
        
        lblCoupons?.text = String(format : "%@ Coupons available.", purchaseLimit)
        tblStore?.reloadData()
            let arrLines = ((dictDetails.object(forKey: "metadata") as! NSDictionary).object(forKey: "rules") as! NSDictionary).object(forKey: "lines") as! NSArray
            if((((dictDetails.object(forKey: "metadata") as! NSDictionary).object(forKey: "rules") as! NSDictionary).object(forKey: "table")) != nil){
            arrTableRedeem = (((dictDetails.object(forKey: "metadata") as! NSDictionary).object(forKey: "rules") as! NSDictionary).object(forKey: "table") as! NSDictionary).object(forKey: "body") as! NSArray
            
            lblDiner1?.text = (arrTableRedeem.object(at: 0) as! NSArray).object(at: 0) as? String
            lblDiner2?.text = (arrTableRedeem.object(at: 0) as! NSArray).object(at: 1) as? String
            lblDiner3?.text = (arrTableRedeem.object(at: 0) as! NSArray).object(at: 2) as? String
            
            
            lblNumberCoupons1?.text = String(format : "%@", ((arrTableRedeem.object(at: 1) as! NSArray).object(at: 0) as? String)!)
            lblNumberCoupons2?.text = String(format : "%@", ((arrTableRedeem.object(at: 1) as! NSArray).object(at: 1) as? String)!)
            lblNumberCoupons3?.text = String(format : "%@", ((arrTableRedeem.object(at: 1) as! NSArray).object(at: 2) as? String)!)
            }
            else{
                lblDiners?.isHidden = true
                lblDiner1?.isHidden = true
                lblDiner2?.isHidden = true
                lblDiner3?.isHidden = true
                lblNumberCoupons?.isHidden = true
                lblNumberCoupons1?.isHidden = true
                lblNumberCoupons2?.isHidden = true
                lblNumberCoupons3?.isHidden = true
                
                lblTip1?.frame.size.height = 40
                lblTip1?.numberOfLines = 0
                lblTip1?.frame.origin.y -= 100
                lblTip2?.frame.origin.y -= 80
                lblTip3?.frame.origin.y -= 80
                btnAdd?.isEnabled = false
                btnAdd?.alpha = 0.5
                lblSelectCoupons?.text = "Only 1 coupon can be used at a time"
            }
            
            lblTip1?.text = String(format : "- %@", (arrLines.object(at: 0) as? String)!)
            lblTip2?.text = String(format : "- %@", (arrLines.object(at: 1) as? String)!)
            lblTip3?.text = String(format : "- %@", (arrLines.object(at: 2) as? String)!)
            
            if(Int(purchaseLimit) == 0){
                lblNumber?.text = "0"
                lblSelectCoupons?.text = "You have 0 coupons left."
                btnAdd?.isEnabled = false
                btnSub?.isEnabled = false
                btnNext?.isEnabled = false
                btnAdd?.alpha = 0.5
                btnSub?.alpha = 0.5
                btnNext?.alpha = 0.5
            }
            
        }
        }
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
    
    //MARK:- Call Restaurant
    
    @IBAction func callRestaurant(_ sender : UIButton){
        if(loginAs == "user"){
        let phoneNumber = dictDetails.object(forKey: "phone") as! String
        if(phoneNumber.contains(",")){
            let fullNameArr : [String] = phoneNumber.components(separatedBy: ", ")
            arrPhoneNumbers = fullNameArr as NSArray
        }
        else{
           arrPhoneNumbers = [phoneNumber]
        }
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select Phone Numbers", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: (arrPhoneNumbers.object(at: 0) as! String), style: .default)
        { _ in
            self.call(self.arrPhoneNumbers.object(at: 0) as! String)
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        if(arrPhoneNumbers.count > 1){
        let deleteActionButton = UIAlertAction(title: (arrPhoneNumbers.object(at: 1) as! String), style: .default)
        { _ in
            self.call(self.arrPhoneNumbers.object(at: 1) as! String)
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        }
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
        else{
            buyClicked()
        }
    }
    
    func call(_ number : String){
        
        if(loginAs == "user"){
        guard let number = URL(string: "telprompt://" + number) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
            if let url = URL(string: "telprompt://\(number)") {
                UIApplication.shared.openURL(url)
            }
        }
        }
        else{
            buyClicked()
        }
    }
    
    @IBAction func openMap(_ sender : UIButton){
        if(loginAs == "user"){
        let latitude: CLLocationDegrees = 28.5678
        let longitude: CLLocationDegrees = 77.3258
        
        let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
        else{
            buyClicked()
        }
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
