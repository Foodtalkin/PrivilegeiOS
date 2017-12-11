//
//  ExperienceDetailsViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 26/10/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

var totalGuest = ""
var nonVegNumber = ""
var dictExp = NSDictionary()
var non_veg_pref = "0"

class ExperienceDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, iCarouselDelegate, iCarouselDataSource, WebServiceCallingDelegate {
    
    @IBOutlet var tblExperience : UITableView?
    @IBOutlet var lblCost : UILabel?
    @IBOutlet var lblSpots : UILabel?
    @IBOutlet var btnBook : UIButton?
    
    var arrExp = NSMutableArray()
    var arrSuggest = NSArray()
    var arrSugestMulti = NSMutableArray()
    var arrImages1 = NSArray()
    var isSuggestArrayMultiple : Bool = false
    var isReadMore : Bool = false
    
    @IBOutlet var viewDown : UIView?
    @IBOutlet var lblTitle : UILabel?
    @IBOutlet var lblNumber : UILabel?
    @IBOutlet var btnAdd : UIButton?
    @IBOutlet var btnSub : UIButton?
    @IBOutlet var btnCancel : UIButton?
    @IBOutlet var lblTotal : UILabel?
    @IBOutlet var lblCostDown : UILabel?
    @IBOutlet var btnNext : UIButton?
    @IBOutlet var lblSelectText : UILabel?
    
    @IBOutlet var viewVegNonVeg : UIView?
    @IBOutlet var lblTitleVeg : UILabel?
    @IBOutlet var lblTicketInfoVeg : UILabel?
    @IBOutlet var lblVeg : UILabel?
    @IBOutlet var lblNonVeg : UILabel?
    @IBOutlet var lblSelectedVeg : UILabel?
    @IBOutlet var sliderVeg : UISlider?
    @IBOutlet var btnCancelVeg : UIButton?
    @IBOutlet var btnContinueVeg : UIButton?
    
    var couponCounter : Int = 1
    var available_seats = ""
    
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblExperience?.register(UINib(nibName: "ExperienceDetailsImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ExperienceDetailsImageTableViewCell")
        
        tblExperience?.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
        
        tblExperience?.register(UINib(nibName: "FoodTalkSuggestTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodSugestionCell")
        
        tblExperience?.register(UINib(nibName: "ImagesTableViewCell", bundle: nil), forCellReuseIdentifier: "ImagesCell")
        
        tblExperience?.register(UINib(nibName: "VideoExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoExperienceTableViewCell")
        
        tblExperience?.tableFooterView = UIView()
        tblExperience?.backgroundColor = colorDarkGray
        tblExperience?.estimatedRowHeight = 200
        tblExperience?.rowHeight = UITableViewAutomaticDimension
        
        setBase()
        setBaseVeg()
        
        arrSuggest = NSArray()
        arrSugestMulti = NSMutableArray()
        DispatchQueue.main.async{
            self.webServiceForExperience()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    //MARK:- tableview delegates and datsource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblExperience){
            if(arrExp.count > 0){
               return arrExp.count + 1
            }
            else{
                return 0
            }
        
        }
        else{
            if(isSuggestArrayMultiple == true){
                return arrSugestMulti.count
            }
            return arrSuggest.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tblExperience){
            tblExperience?.separatorColor = .clear
        if(indexPath.row == 0){
           let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceDetailsImageTableViewCell", for: indexPath) as! ExperienceDetailsImageTableViewCell
            cell.lblName?.text = dictExp.object(forKey: "title") as? String
            cell.lblAddress?.text = dictExp.object(forKey: "address") as? String
          //  cell.lblDate?.text = dictExp.object(forKey: "display_time") as? String
            
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
        else if((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "type") as! String == "TEXT"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionTableViewCell
            cell.lblTitle?.font = UIFont(name: fontFuture, size: 18)
            cell.lblTitle?.textColor = colorDarkGray
            
            cell.lblDescribe?.textColor = UIColor.lightGray
            
            cell.lblTitle?.text = (arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "title") as? String
            cell.lblDescribe?.text = (arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "content") as? String
            cell.btnReadMore?.addTarget(self, action: #selector(ExperienceDetailsViewController.btnReadMore(_:)), for: .touchUpInside)
            if(isReadMore == true){
                cell.lblDescribe?.frame.size.height = (cell.lblDescribe?.frame.size.height)! + 20
            }
            cell.selectionStyle = .none
            return cell
        }
        else if(((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "type") as! String).contains("LIST")){
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodSugestionCell", for: indexPath) as! FoodTalkSuggestTableViewCell
            cell.lblTitle?.font = UIFont(name: fontFuture, size: 18)
            cell.lblTitle?.textColor = colorDarkGray
            cell.lblTitle?.text = (arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "title") as? String
            cell.selectionStyle = .none
            
            arrSuggest = ((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "content") as? NSArray)!
            if((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "type") as! String == "LIST1"){
                isSuggestArrayMultiple = false
            }
            else{
                arrSugestMulti = NSMutableArray()
                for ind in 0..<arrSuggest.count {
                    arrSugestMulti.add(((arrSuggest.object(at: ind) as! NSDictionary).object(forKey: "title") as? String)!)
                    
                    arrSugestMulti.add(((arrSuggest.object(at: ind) as! NSDictionary).object(forKey: "data") as? String)!)
                }
                isSuggestArrayMultiple = true
            }
            cell.tblSuggest?.estimatedRowHeight = 80
            cell.tblSuggest?.rowHeight = UITableViewAutomaticDimension
            cell.tblSuggest?.separatorColor = .clear
            cell.tblSuggest?.dataSource = self
            cell.tblSuggest?.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "type") as! String == "IMAGE"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesCell", for: indexPath) as! ImagesTableViewCell
            cell.selectionStyle = .none
            cell.lblTitle?.font = UIFont(name: fontFuture, size: 18)
            cell.lblTitle?.textColor = colorDarkGray
            cell.lblTitle?.text = (arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "title") as? String
            arrImages1 = ((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "content") as? NSArray)!
            cell.carousal?.frame = CGRect(x: 0, y: 52, width: self.view.frame.size.width, height : 90)
            cell.carousal?.type = .linear
            cell.carousal?.dataSource = self
            cell.carousal?.delegate = self
            cell.carousal?.scrollToItem(at: 1, animated: false)
            cell.carousal?.reloadData()
             cell.selectionStyle = .none
            return cell
        }
        else if(((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "type") as! String).contains("VIDEO")){
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoExperienceTableViewCell", for: indexPath) as! VideoExperienceTableViewCell
            cell.lblTitle?.font = UIFont(name: fontFuture, size: 18)
            cell.lblTitle?.textColor = colorDarkGray
            cell.lblTitle?.text = (arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "title") as? String
            loadWeView(web: cell.webView!, url: ((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "content") as? String)!)
            cell.selectionStyle = .none
            return cell
        }
        else{
           let cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
            cell.textLabel?.text = (arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "title") as? String
            cell.textLabel?.textColor = colorBrightSkyBlue
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            cell.selectionStyle = .none
            return cell
        }
        }
        else{
            let cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
            if(arrSuggest.count > 0){
                if(isSuggestArrayMultiple == true){
                    if(indexPath.row % 2 == 0){
                        cell.textLabel?.textColor = colorDarkGray
                        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                        cell.textLabel?.text = String(format : "- %@", (arrSugestMulti.object(at: indexPath.row) as? String)!)
                    }
                    else{
                        
                        cell.textLabel?.textColor = UIColor.lightGray
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
                        cell.textLabel?.text = String(format : "%@", arrSugestMulti.object(at: indexPath.row) as! String)
                    }
                }
                else{
                    cell.textLabel?.textColor = UIColor.lightGray
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
                    cell.textLabel?.text = String(format : "- %@", (arrSuggest.object(at: indexPath.row) as? String)!)
                    cell.textLabel?.sizeToFit()
                }
            }
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == tblExperience){
          if(indexPath.row != 0){
            if ((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "type") as! String).contains("URL"){
                selectedWebType = "exp"
                rules = (arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "content") as! String
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Web") as! WebViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
          }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tblExperience){
        if(indexPath.row == 0){
            return 244
        }
        else if((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "type") as! String == "TEXT"){
            if(isReadMore == false){
                return 180
            }
            else{
                return UITableViewAutomaticDimension
            }
        }
        else if(((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "type") as! String).contains("LIST")){
            if(isSuggestArrayMultiple == true){
                
                if(arrSuggest.count > 0){
                    var length = CGFloat()
                    length = CGFloat(0)
                    for index in 0..<arrSugestMulti.count {
                        let heightI = heightForView(text: arrSugestMulti.object(at: index) as! String, font: UIFont.systemFont(ofSize: 17), width: (tblExperience?.frame.size.width)! - 20)
                      length = length + heightI
                    }
                return length + 20
                }
                else{
                    return 40
                }
            }
            else{
                
                return CGFloat(50 + arrSuggest.count * 25)
            }
        }
        else if(((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "type") as! String).contains("IMAGE")){
            return 150
        }
        else if(((arrExp.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "type") as! String).contains("VIDEO")){
            return 223
        }
        else{
            return 54
        }
        }
        else{
            if(isSuggestArrayMultiple == true){
                if(indexPath.row % 2 == 0){
                    return 25
                }
                if(arrSuggest.count > 0){
              return UITableViewAutomaticDimension
                }
                return 40
            }
            return 25
        }
    }
    
    //MARK:- find Number of lines
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height + 25
    }
    
    //MARK:- carousal delegates
    
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return arrImages1.count
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
            
            if(arrImages1.count > 0){
                setImageWithUrl(arrImages1.object(at: index) as! String, imgView: img)
            }
        }
        else{
            itemView = view!;
        }
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        arrImages = arrImages1
        indexSelectedImage = index
        
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "FullImage") as! FullImageViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
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

    
    func loadWeView(web : UIWebView, url : String){
        DispatchQueue.main.async{
        web.loadRequest(URLRequest(url: URL(string: url)!))
        }
    }
    
    //MARK:- webservice
    
    func webServiceForExperience(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@%@", baseUrl,"experiences/", idExperience)
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(ExperienceDetailsViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
       
        stopAnimation(view: self.view)
       if((dict.object(forKey: "api") as! String).contains("experiences/")){
          if(dict.object(forKey: "status") as! String == "OK"){
           dictExp = dict.object(forKey: "result") as! NSDictionary
            arrExp = ((dictExp.object(forKey: "data") as! NSArray).mutableCopy() as? NSMutableArray)!
            lblCost?.text =  String(format : "%@ %@", "\u{20B9}", dictExp.object(forKey: "cost") as! String)
            lblSpots?.text = String(format : "%@ Spots", dictExp.object(forKey: "avilable_seats") as! String)
            lblTitle?.text = String(format: "  %@", (dictExp.object(forKey: "title") as? String)!)
            lblCostDown?.text = String(format : "%@ %@", "\u{20B9}", dictExp.object(forKey: "cost") as! String)
            non_veg_pref = dictExp.object(forKey: "nonveg_preference") as! String
            available_seats = dictExp.object(forKey: "avilable_seats") as! String
            if(available_seats == "0"){
             btnBook?.setTitle("SOLD OUT", for: .normal)
             btnBook?.backgroundColor = UIColor(red: 350/255, green: 75/255, blue: 100/255, alpha: 1.0)
             btnBook?.isEnabled = false
            }
            let isDisable = dictExp.object(forKey: "is_disabled") as! String
            let isActive = dictExp.object(forKey: "is_active") as! String
            
            if(isDisable == "0" && isActive == "0"){
                btnBook?.setTitle("CLOSED", for: .normal)
                btnBook?.backgroundColor = UIColor(red: 350/255, green: 75/255, blue: 100/255, alpha: 1.0)
                btnBook?.isEnabled = false
            }
        }
        tblExperience?.reloadData()
        }
    }
    
    func serviceFailedWitherror(_ error : NSError){
          stopAnimation(view: self.view)
        self.view.isUserInteractionEnabled = true
        UserDefaults.standard.setValue(nil, forKey: "userDetails")
        UserDefaults.standard.setValue(nil, forKey: "session")
        UserDefaults.standard.setValue(nil, forKey: "expiry")
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "LoginNumber") as! LoginNumberViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
    }
    
    func btnReadMore(_ sender : UIButton){
        if (isReadMore == false){
            isReadMore = true
            sender.setTitle("Read Less", for: .normal)
            tblExperience?.reloadData()
        }
        else{
            isReadMore = false
            sender.setTitle("Read More", for: .normal)
            tblExperience?.reloadData()
        }
    }
    
    @IBAction func buyNowTapped(_ sender : UIButton){
        if((UserDefaults.standard.object(forKey: "userDetails")) != nil){
        UIView.animate(withDuration: 0.50, delay: 0.0, options: [], animations: {
            self.viewDown?.frame = CGRect(x: 0, y: self.view.frame.size.height - 216, width: self.view.frame.size.width, height: 216)
        })
        }
        else{
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
    }
    
    @IBAction func back(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- SetBase
    
    func setBase(){
        viewDown?.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 216)
        lblTitle?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 37)
        btnCancel?.frame = CGRect(x: (viewDown?.frame.size.width)! - 45, y: 0, width: 37, height: 37)
        lblSelectText?.frame = CGRect(x: 0, y: (lblTitle?.frame.size.height)! + 20, width: (viewDown?.frame.size.width)!, height: 21)
        lblNumber?.frame = CGRect(x: self.view.frame.size.width/2 - 30, y: (lblSelectText?.frame.origin.y)! + (lblSelectText?.frame.size.height)! + 15, width: 60, height: 55)
        btnAdd?.frame = CGRect(x: self.view.frame.size.width/2 + self.view.frame.size.width/8, y: (lblSelectText?.frame.origin.y)! + (lblSelectText?.frame.size.height)! + 15, width: 60, height: 55)
        btnSub?.frame = CGRect(x: self.view.frame.size.width/2 - self.view.frame.size.width/3, y: (lblSelectText?.frame.origin.y)!  + (lblSelectText?.frame.size.height)! + 12, width: 60, height: 55)
        lblTotal?.frame = CGRect(x: 10, y: (btnAdd?.frame.origin.y)! + (btnAdd?.frame.size.height)! + 15, width: 120, height: 16)
        lblCostDown?.frame = CGRect(x: 10, y: (lblTotal?.frame.origin.y)! + (lblTotal?.frame.size.height)! + 5, width: 120, height: 16)
        btnNext?.frame = CGRect(x: (viewDown?.frame.size.width)! - 114, y: (lblTotal?.frame.origin.y)!, width: 94, height: 30)
    }
    
    func setBaseVeg(){
        viewVegNonVeg?.frame = CGRect(x: self.view.frame.size.width, y: self.view.frame.size.height - 216, width: self.view.frame.size.width, height: 216)
        lblTitleVeg?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 37)
        lblTicketInfoVeg?.frame = CGRect(x: 0, y: (lblTitleVeg?.frame.size.height)! + 2, width: self.view.frame.size.width, height: 16)
        lblSelectedVeg?.frame = CGRect(x: self.view.frame.size.width/2 - 35, y: (lblTicketInfoVeg?.frame.origin.y)! + (lblTicketInfoVeg?.frame.size.height)! + 15, width : 70, height : 35)
        lblNonVeg?.frame = CGRect(x: 20, y: (lblTicketInfoVeg?.frame.origin.y)! + (lblTicketInfoVeg?.frame.size.height)! + 20, width: 107, height: 20)
        lblVeg?.frame = CGRect(x: self.view.frame.size.width - 66, y: (lblTicketInfoVeg?.frame.origin.y)! + (lblTicketInfoVeg?.frame.size.height)! + 20, width: 46, height: 20)
        sliderVeg?.frame = CGRect(x: 20, y: (lblVeg?.frame.origin.y)! + (lblVeg?.frame.size.height)! + 15, width: self.view.frame.size.width - 40, height: 35)
        btnCancelVeg?.frame = CGRect(x: 20, y: (sliderVeg?.frame.origin.y)! + (sliderVeg?.frame.size.height)! + 15, width: (btnCancelVeg?.frame.size.width)!, height: (btnCancelVeg?.frame.size.height)!)
        btnContinueVeg?.frame = CGRect(x: self.view.frame.size.width - (20 + (btnContinueVeg?.frame.size.width)!), y: (sliderVeg?.frame.origin.y)! + (sliderVeg?.frame.size.height)! + 15, width: (btnContinueVeg?.frame.size.width)!, height: (btnContinueVeg?.frame.size.height)!)
    }
    
    @IBAction func cancelTap(_ sender : UIButton){
        UIView.animate(withDuration: 0.50, delay: 0.0, options: [], animations: {
            self.viewDown?.frame.origin.y = self.view.frame.size.height
        })
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
            let num = (lblNumber?.text as! NSString).intValue
            let cost = (dictExp.object(forKey: "cost") as! NSString).intValue
            lblCostDown?.text = String(format : "%@ %d", "\u{20B9}", num * cost)
        }
        else{
            
        }
    }
    
    @IBAction func add(_ sender : UIButton){
        var max = 10
        if(Int(available_seats)! < 10){
            max = Int(available_seats)!
        }
        if(couponCounter < max){
            
            couponCounter = couponCounter + 1
            lblNumber?.text = String(format : "%d", couponCounter)
            if(couponCounter == 10){
                sender.alpha = 0.5
                btnSub?.alpha = 1.0
            }
            else{
                sender.alpha = 1.0
                btnSub?.alpha = 1.0
            }
            let num = (lblNumber?.text as! NSString).intValue
            let cost = (dictExp.object(forKey: "cost") as! NSString).intValue
            lblCostDown?.text = String(format : "%@ %d", "\u{20B9}", num * cost)
        }
        else{
            
        }
    }
    
    @IBAction func nextTap(_ sender : UIButton){
        if(non_veg_pref == "1"){
        UIView.animate(withDuration: 0.50, delay: 0.0, options: [], animations: {
            self.viewVegNonVeg?.frame.origin.x = 0
        })
        lblTitleVeg?.text = dictExp.object(forKey: "title") as? String
        lblTicketInfoVeg?.text = String(format : "Booking %@ tickets, select dining prefrences.", (lblNumber?.text!)!)
        let vegNum = String(format: "%@ / 0", (lblNumber?.text)!)
        let myMutableString = NSMutableAttributedString(string: vegNum, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:0,length:2))
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSRange(location:3,length:2))
        // set label Attribute
        lblSelectedVeg?.attributedText = myMutableString
        
        sliderVeg?.maximumValue = (lblNumber?.text as! NSString).floatValue
        sliderVeg?.minimumValue = 0
        sliderVeg?.value = 0
        nonVegNumber = (lblNumber?.text)!
        }
        else{
            nonVegNumber = "0"
            totalGuest = (lblNumber?.text)!
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Invoice") as! InvoiceViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
    }
    
    @IBAction func sliderAction(_ sender : UISlider){
        let max = Int(sender.maximumValue)
        let val = Int(sender.value)
        let vegNum = String(format: "%d / %d", (max - val), val)
        let myMutableString = NSMutableAttributedString(string: vegNum, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:0,length:2))
        if(val < 10){
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSRange(location:3,length:2))
        }
        else{
         myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSRange(location:3,length:3))
        }
        // set label Attribute
        lblSelectedVeg?.attributedText = myMutableString
        nonVegNumber = String(format : "%d", (max - val))
    }
    
    @IBAction func cancelVeg(_ sender : UIButton){
        UIView.animate(withDuration: 0.50, delay: 0.0, options: [], animations: {
            self.viewVegNonVeg?.frame.origin.x = self.view.frame.size.width
        })
    }
    
    @IBAction func continueAction(_ sender : UIButton){
        totalGuest = (lblNumber?.text)!
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Invoice") as! InvoiceViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        arrSuggest = NSArray()
        arrSugestMulti = NSMutableArray()
        DispatchQueue.main.async{
            self.webServiceForExperience()
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
