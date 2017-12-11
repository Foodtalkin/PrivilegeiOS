//
//  HomeViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 20/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseAnalytics
import FBSDKCoreKit
import Crashlytics

var restaurantDetails = NSDictionary()
var restaurantId = String()
var selectedWebType = ""
var strOneLiner = ""
var restaurantName = ""
var idExperience = ""
var todayDate = ""
var openPushView = ""

class HomeViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, WebServiceCallingDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, FloatRatingViewDelegate {
    
    fileprivate let barSize : CGFloat = 44.0
    fileprivate let kCellReuse : String = "PackCell"
    fileprivate let kCellheaderReuse : String = "PackHeader"
    fileprivate let kCellSavingReuse : String = "SavingCell"
    fileprivate let kCellSavingheaderReuse : String = "SavingHeader"
    var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var tblMenu = UITableView()
    var tblExperience = UITableView()
    
    @IBOutlet var btnMore : UIButton?
    @IBOutlet var btnSearch : UIButton?
    @IBOutlet var viewNavigate : UIView?
    @IBOutlet var viewBase : UIView?
    @IBOutlet var lblCity : UILabel?
    @IBOutlet var lblTitle : UILabel?
    
    var viewMenu = UIView()
    var isMoreTapped : Bool = false
    var viewBuy = UIView()
    var nextPageUrl = ""
    
    var arrCards = NSMutableArray()
    var savingValue = ""
    
    var viewBottom = UIView()
    var locationManager = CLLocationManager()
    
    var isLocationCalled : Bool = false
    var isLocationEnable : Bool = false
    var isLocationKill : Bool = false
    
    var lblMenuCity = UILabel()
    
    var arrExperience = NSMutableArray()
    @IBOutlet var viewChoice : UIView?
    @IBOutlet var btnOffer : UIButton?
    @IBOutlet var btnExperience : UIButton?
    @IBOutlet var viewMarker : UIView?
    
    @IBOutlet var floatRatingView: FloatRatingView!
    var selectedRating = "0.0"
    var dictRating = NSDictionary()
    @IBOutlet var ratingView : UIView?
    @IBOutlet var lblRestaurantName : UILabel?
    @IBOutlet var lblRate : UILabel?
    @IBOutlet var lblHowText : UILabel?
    @IBOutlet var btnSubmit : UIButton?
    
    var viewEmpty = UIView()
    var selectedType = "Home"
    var nextTableUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = colorPaleGray
      
        // Do any additional setup after loading the view.
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.viewBase?.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.left
        self.viewBase?.addGestureRecognizer(swipeDown)
        
      //  Analytics.setScreenName("Home", screenClass: "Home")
        FBSDKAppEvents.logEvent("First_Enter")

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation

        self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        let nipName2=UINib(nibName: "TopUpCollectionViewCell", bundle:nil)
        
        collectionView.register(nipName2, forCellWithReuseIdentifier: "TopUpCollectionViewCell")
        viewBase?.frame = CGRect(x: 0, y: 114, width: self.view.frame.size.width, height: self.view.frame.size.height - 115)
        
        createRatingView()
        setCollectionView()
        setExperienceTable()
        createMenuView()
        setEmptyCredentials()
        viewChoiceCreate()
       
        self.perform(#selector(HomeViewController.webServiceForExperience), with: nil, afterDelay: 2)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                let point: CGPoint = gesture.location(in: gesture.view!)
                if gesture.state == .began {
                    print(NSStringFromCGPoint(point))
                }
                else if gesture.state == .ended {
                    if(isMoreTapped == false){
                    if(point.x < 50){
                       let btn = UIButton()
                       openMenu(btn)
                    }
                    else{
                        let btn = UIButton()
                        offerChoice(btn)
                        }
                    }
                }
            
            case UISwipeGestureRecognizerDirection.left:
                let point: CGPoint = gesture.location(in: gesture.view!)
                if gesture.state == .began {
                    print(NSStringFromCGPoint(point))
                }
                else if gesture.state == .ended {
                    if(isMoreTapped == true){
                    if(point.x > self.view.frame.size.width/2 + 100){
                        let btn = UIButton()
                        openMenu(btn)
                    }
                    else{
                        let btn = UIButton()
                        experienceChoice(btn)
                        }
                    }
                    else{
                        let btn = UIButton()
                        experienceChoice(btn)
                    }
                }
            
            default:
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopAnimation(view: self.view)
     //   showActivityIndicator(view: self.view)
        if(loginAs == "guest"){
            viewBase?.frame = CGRect(x: 0, y: 114, width: self.view.frame.size.width, height: self.view.frame.size.height - 115)
            if(city_id == ""){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "CitySelection") as! CitySelectionViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            tblMenu.reloadData()
       
        }
        else if(loginAs == "trail"){
            webServiceForProfile()
            viewBase?.frame = CGRect(x: 0, y: 114, width: self.view.frame.size.width, height: self.view.frame.size.height - 115)
            
        }
        else{
            webServiceForProfile()
            viewBase?.frame = CGRect(x: 0, y: 114, width: self.view.frame.size.width, height: self.view.frame.size.height - 115)
            
        }
        
        self.navigationController?.isNavigationBarHidden = true
        
        createBottomView()
        if((UserDefaults.standard.object(forKey: "city_id")) != nil){
            city_id = UserDefaults.standard.object(forKey: "city_id") as! String
        }
        isMoreTapped = false
        isLocationCalled = false
    
        
        DispatchQueue.main.async{
        self.findLocationService()
        }
        
        if(city_id == "1"){
            lblCity?.text = "DELHI NCR"
            lblMenuCity.text = "DELHI NCR"
        }
        else if(city_id == "2"){
            lblCity?.text = "MUMBAI"
            lblMenuCity.text = "MUMBAI"
        }
        
        lblCity?.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleTap(_:)))
        tap1.delegate = self
        lblCity?.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleTap(_:)))
        tap2.delegate = self
        lblTitle?.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleTap3(_:)))
        tap3.delegate = self
        if(arrExperience.count == 0){
          tblExperience.addGestureRecognizer(tap3)
        }
        else if(arrExperience.count == 1){
           let viewEx = UIView()
            viewEx.frame = CGRect(x: 0, y: 390, width: self.view.frame.size.width, height: self.view.frame.size.height - 390)
            tblExperience.addSubview(viewEx)
            tblExperience.addGestureRecognizer(tap3)
        }
     //   tblExperience.addGestureRecognizer(tap3)
        
        viewChoice?.frame = CGRect(x: 0, y: (viewNavigate?.frame.size.height)!, width: self.view.frame.size.width, height: 52)
        viewBase?.backgroundColor = UIColor(red: 242/255, green: 250/255, blue: 252/255, alpha: 1.0)
        self.floatRatingView.rating = 0
        
        if((UserDefaults.standard.object(forKey: "session")) != nil){
        viewBase?.isUserInteractionEnabled = false
        btnOffer?.isEnabled = false
        btnExperience?.isEnabled = false
        btnMore?.isEnabled = false
        btnSearch?.isEnabled = false
        }
        
        if((UserDefaults.standard.object(forKey: "session")) != nil){
            self.perform(#selector(HomeViewController.webServiceForRating), with: nil, afterDelay: 3)
        }
    }
    
    func setEmptyCredentials(){
        viewEmpty.frame = CGRect(x: 0, y: self.view.frame.size.height/2 - 40, width: self.view.frame.size.width, height: 80)
        viewEmpty.isUserInteractionEnabled = true
        let img = UIImageView(frame : CGRect(x: viewEmpty.frame.size.width/2 - 12, y: 5, width: 23, height: 53))
        img.image = UIImage(named: "wine.png")
        viewEmpty.addSubview(img)
        let lblText = UILabel(frame: CGRect(x: 0,y: 68, width: viewEmpty.frame.size.width, height: 17))
        lblText.textAlignment = .center
        lblText.text = "New experiences coming soon"
        lblText.font = UIFont(name : fontFuturaBold, size : 14)
        viewEmpty.addSubview(lblText)
        
        self.view.addSubview(viewEmpty)
        viewEmpty.isHidden = true
    }
    
    func handleTap(_ gesture : UIGestureRecognizer){
        if(gesture.view == lblCity){
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "CitySelection") as! CitySelectionViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
    }
    
    func handleTap3(_ gesture : UIGestureRecognizer){
        
            if(selectedType == "exp"){
                if(isMoreTapped == true){
                let btn = UIButton()
                openMenu(btn)
                }
            }
    }
    
    func viewChoiceCreate(){
        viewChoice?.frame = CGRect(x: 0, y: (viewNavigate?.frame.size.height)!, width: self.view.frame.size.width, height: 52)
        
        btnOffer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/2, height: (viewChoice?.frame.size.height)!)
        
        btnExperience?.frame = CGRect(x: self.view.frame.size.width/2, y: 0, width: self.view.frame.size.width/2, height: (viewChoice?.frame.size.height)!)
        
        viewMarker?.frame = CGRect(x: 7, y: (viewChoice?.frame.size.height)! - 7, width: self.view.frame.size.width/2 - 14, height: 7)
        
        btnOffer?.setTitleColor(colorLightGold, for: .normal)
        btnExperience?.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func offerChoice(_ sender : UIButton){
        selectedType = "Home"
        viewMarker?.frame = CGRect(x: 7, y: (viewChoice?.frame.size.height)! - 7, width: self.view.frame.size.width/2 - 14, height: 7)
        UIView.animate(withDuration: 0.50, delay: 0.0, options: [], animations: {
            if(UIScreen.main.bounds.size.height > 670){
                self.collectionView.frame = CGRect(x: 20, y: 5, width: self.view.frame.size.width - 40,height: (self.viewBase?.frame.size.height)! - 6)
            }
            else if(UIScreen.main.bounds.size.height < 500){
                if(loginAs == "guest"){
                    self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (self.viewBase?.frame.size.height)! - 6)
                }
                else{
                    self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (self.viewBase?.frame.size.height)! - 6)
                }
            }
            else if(UIScreen.main.bounds.size.height < 570){
                if(loginAs == "guest"){
                    self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (self.viewBase?.frame.size.height)! - 6)
                }
                else{
                    self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (self.viewBase?.frame.size.height)! - 6)
                }
            }
            else{
                if(loginAs == "guest"){
                    self.collectionView.frame = CGRect(x: 20, y: 15, width: self.view.frame.size.width - 40,height: (self.viewBase?.frame.size.height)! - 16)
                }
                else{
                    self.collectionView.frame = CGRect(x: 20, y: 15, width: self.view.frame.size.width - 40,height: (self.viewBase?.frame.size.height)! - 16)
                }
            }
            self.tblExperience.frame.origin.x = self.view.frame.size.width
        }, completion: { (finished: Bool) in
            
            self.tblExperience.isHidden = true
        })
        btnOffer?.setTitleColor(colorLightGold, for: .normal)
        btnExperience?.setTitleColor(.white, for: .normal)
        collectionView.isHidden = false
        viewEmpty.isHidden = true
        collectionView.reloadData()
    }
    
    @IBAction func experienceChoice(_ sender : UIButton){
        selectedType = "exp"
        viewMarker?.frame = CGRect(x: self.view.frame.size.width/2 + 7, y: (viewChoice?.frame.size.height)! - 7, width: self.view.frame.size.width/2 - 14, height: 7)
        UIView.animate(withDuration: 0.50, delay: 0.0, options: [], animations: {
            if(UIScreen.main.bounds.size.height > 670){
                self.tblExperience.frame = CGRect(x: 20, y: 2, width: self.view.frame.size.width - 40,height: (self.viewBase?.frame.size.height)! - 3)
            }
            else if(UIScreen.main.bounds.size.height < 500){
                if(loginAs == "guest"){
                    self.tblExperience.frame = CGRect(x: 10, y: 2, width: self.view.frame.size.width - 20,height: (self.viewBase?.frame.size.height)! - 3)
                }
                else{
                    self.tblExperience.frame = CGRect(x: 10, y: 2, width: self.view.frame.size.width - 20,height: (self.viewBase?.frame.size.height)! - 3)
                }
            }
            else if(UIScreen.main.bounds.size.height < 570){
                if(loginAs == "guest"){
                    self.tblExperience.frame = CGRect(x: 10, y: 2, width: self.view.frame.size.width - 20,height: (self.viewBase?.frame.size.height)! - 3)
                }
                else{
                    self.tblExperience.frame = CGRect(x: 10, y: 2, width: self.view.frame.size.width - 20,height: (self.viewBase?.frame.size.height)! - 3)
                }
            }
            else{
                if(loginAs == "guest"){
                    self.tblExperience.frame = CGRect(x: 20, y: 2, width: self.view.frame.size.width - 40,height: (self.viewBase?.frame.size.height)! - 3)
                }
                else{
                    self.tblExperience.frame = CGRect(x: 20, y: 2, width: self.view.frame.size.width - 40,height: (self.viewBase?.frame.size.height)! - 3)
                }
            }
            self.collectionView.frame.origin.x = -(self.view.frame.size.width)
        }, completion: { (finished: Bool) in
            
            self.collectionView.isHidden = true
            if(self.arrExperience.count > 0){
                self.viewEmpty.isHidden = true
            }
            else{
                self.viewEmpty.isHidden = false
            }
        })

        btnExperience?.setTitleColor(colorLightGold, for: .normal)
        btnOffer?.setTitleColor(.white, for: .normal)
        
        tblExperience.isHidden = false
        tblExperience.reloadData()
    }
    
    func createBottomView(){
        viewBottom.frame = CGRect(x : 0, y : self.view.frame.size.height - 60, width : self.view.frame.size.width, height : 60)
        viewBottom.backgroundColor = colorDarkGray
        self.view.addSubview(viewBottom)
        
        let lblText = UILabel(frame : CGRect(x: 20, y: 0, width : viewBottom.frame.size.width - 160, height : viewBottom.frame.size.height))
        lblText.text = "Enable location access to discover nearby restaurants"
        lblText.textColor = .white
        lblText.font = UIFont(name : "Futura-Medium", size : 14)
        lblText.numberOfLines = 0
        viewBottom.addSubview(lblText)
        
        let btnEnable = UIButton(frame : CGRect(x: viewBottom.frame.size.width - 140, y: 10, width : 100, height: 40))
        btnEnable.backgroundColor = colorLightGold
        btnEnable.setTitle("ENABLE", for: .normal)
        btnEnable.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btnEnable.setTitleColor(colorDarkGray, for: .normal)
        btnEnable.addTarget(self, action: #selector(HomeViewController.enableLocation(_:)), for: .touchUpInside)
        setDownLine(btnEnable)
        viewBottom.addSubview(btnEnable)
        
        let btnClose = UIButton(frame : CGRect(x: viewBottom.frame.size.width - 35, y: 17.5, width : 25, height: 25))
        btnClose.setImage(UIImage(named : "cancelMaterial.png"), for: .normal)
        btnClose.setTitleColor(.white, for: .normal)
        btnClose.addTarget(self, action: #selector(HomeViewController.closeLocation(_:)), for: .touchUpInside)
        viewBottom.addSubview(btnClose)
        
    }
    
    func closeLocation(_ sender : UIButton){
        isLocationKill = true
        viewBottom.isHidden = true
  //      viewBase?.frame.size.height = (viewBase?.frame.size.height)! + 60
    }
    
    func selectLocation(_ sender : UIButton){
    
    }
    
    func enableLocation(_ sender : UIButton){
        if(UserDefaults.standard.bool(forKey: "isLocationEnable")){
            isLocationEnable = UserDefaults.standard.bool(forKey: "isLocationEnable")
        }

            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    if(isLocationEnable == false){
                        isLocationCalled = false
                        locationManager.delegate = self
                        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        locationManager.activityType = .automotiveNavigation
                        locationManager.requestAlwaysAuthorization()
                        locationManager.requestWhenInUseAuthorization()
                        locationManager.startUpdatingLocation()
                        isLocationEnable = true
                        UserDefaults.standard.set(true, forKey: "isLocationEnable")
                    }
                    else{
                        
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    
                case .authorizedAlways, .authorizedWhenInUse:
                    isLocationCalled = false
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.activityType = .automotiveNavigation
                    locationManager.requestAlwaysAuthorization()
                    locationManager.requestWhenInUseAuthorization()
                    locationManager.startUpdatingLocation()
                    
                }
            } else {
                        if(isLocationEnable == false){
                            isLocationCalled = false
                            locationManager.delegate = self
                            locationManager.desiredAccuracy = kCLLocationAccuracyBest
                            locationManager.activityType = .automotiveNavigation
                            locationManager.requestAlwaysAuthorization()
                            locationManager.requestWhenInUseAuthorization()
                            locationManager.startUpdatingLocation()
                            isLocationEnable = true
                            UserDefaults.standard.set(true, forKey: "isLocationEnable")
                        }
                        else{
                print("Location services are not enabled")

            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                }
                }
            }
    }
    
    //MARK:- location Delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
                print(error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(isLocationCalled == false){
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            
        
        latitude = "\(locationObj.coordinate.latitude)"
        longitude = "\(locationObj.coordinate.longitude)"
            
        manager.stopUpdatingLocation()
       
        arrCards.removeAllObjects()
        DispatchQueue.main.async{
            self.callWebServiceForLocation()
        }
                    viewBottom.isHidden = true
            if(loginAs == "user"){
          //      viewBase?.frame.size.height = (viewBase?.frame.size.height)! + 50
            }
            else{
         //       viewBase?.frame.size.height = (viewBase?.frame.size.height)! + 50
           
            }
            
            locationManager.startUpdatingLocation()
            isLocationCalled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case CLAuthorizationStatus.restricted: break
            
        case CLAuthorizationStatus.denied: break
            
        case CLAuthorizationStatus.notDetermined: break
            
        case CLAuthorizationStatus.authorizedWhenInUse : break
         //   manager.startUpdatingLocation()
            
        default: break
            
        }
        
    }
    
    //MARK:- find LOcation Services
    
    func findLocationService(){
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                if(isLocationKill == false){
                viewBottom.isHidden = false
                }
                else{
                viewBottom.isHidden = true
                }
//                DispatchQueue.main.async{
//                    self.callWebServiceForHome()
//                }
                self.perform(#selector(HomeViewController.callWebServiceForHome), with: nil, afterDelay: 1.0)
            case .authorizedAlways, .authorizedWhenInUse:
                viewBottom.isHidden = true
                
             locationManager.startUpdatingLocation()
                
            }
        } else {
            print("Location services are not enabled")
//            DispatchQueue.main.async{
//                self.callWebServiceForHome()
//            }
            self.perform(#selector(HomeViewController.callWebServiceForHome), with: nil, afterDelay: 1.0)
        }
    }
    
    func createBuyView(){
        
        viewBuy.frame = CGRect(x: 0, y: (viewNavigate?.frame.size.height)!, width: self.view.frame.size.width, height: 50)
        viewBuy.isHidden = false
        viewBuy.backgroundColor = colorDarkGray
        self.view.addSubview(viewBuy)
        
        let lblText = UILabel(frame : CGRect(x: 20, y : 0, width: self.view.frame.size.width/2 + 25, height: 50))
        if(loginAs == "guest"){
        lblText.text = "Start your 7 days free trial. Access deals, discounts and experiences"
        }
        else if(loginAs == "trail"){
        let expiryDate = UserDefaults.standard.object(forKey: "expiry") as! String
            let fullNameArr = expiryDate.components(separatedBy: " ")
            
            let date1    = fullNameArr[0]
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let s = dateFormatter.date(from:date1)
        
        let calendar = NSCalendar.current as NSCalendar
            
            let fullNameArr1 = todayDate.components(separatedBy: " ")
            
            let date2    = fullNameArr1[0]
            
        let s1 = dateFormatter.date(from: date2)
        let flags = NSCalendar.Unit.day
        let components = calendar.components(flags, from: s1!, to: s!, options: [])
        let daysNumber = components.day
            
        if(daysNumber! > 0){
        isTrailExpired = false
        lblText.text = String(format : "%d day free trial left. Buy your annual memebership to continue", daysNumber! + 1)
        }
        else{
            isTrailExpired = true
         lblText.text = String(format : "Your free trial has expired. Buy your annual membership to continue")
        }
        }
        
        lblText.textColor = .white
        lblText.numberOfLines = 0
        if(UIScreen.main.bounds.size.height < 570){
           lblText.font = UIFont(name: "Futura-Medium", size: 10)
        }
        else{
           lblText.font = UIFont(name: "Futura-Medium", size: 12)
        }
        viewBuy.addSubview(lblText)
        
        let btnBuy = UIButton(frame: CGRect(x: self.view.frame.size.width - 124, y : 6, width: 104, height: 38))
        btnBuy.backgroundColor = colorLightGold
        if(loginAs == "guest"){
          btnBuy.setTitle("START TRIAL", for: .normal)
        }
        else if(loginAs == "trail"){
           btnBuy.setTitle("BUY", for: .normal)
        }
        btnBuy.setTitleColor(colorDarkGray, for: .normal)
        btnBuy.titleLabel?.font = UIFont(name : fontFuturaBold, size: 12)
        btnBuy.addTarget(self, action: #selector(HomeViewController.buyClicked(_:)), for: .touchUpInside)
        setDownLine(btnBuy)
        viewBuy.addSubview(btnBuy)
    }
    
    func findExpireDate(){
        
    }
    
    func buyClicked(_ sender : UIButton){
        
        viewMenu.removeFromSuperview()
    //    viewBuy.removeFromSuperview()
        tblMenu.removeFromSuperview()
        if(loginAs == "guest"){
            loginAs = "UnPaid"
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
        else if(loginAs == "trail"){
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "BuySignup") as! BuySignupViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
        else if(loginAs == "UnPaid"){
            if(sender.titleLabel?.text == "START TRIAL"){
               webCallStartTrial()
            }
            else{
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "BuySignup") as! BuySignupViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
        }
    }
    
    //MARK:- CreateMenuView
    
    func createMenuView(){
        
        viewMenu.frame = CGRect(x: -(self.view.frame.size.width/2 + 110), y: 0, width: self.view.frame.size.width/2 + 100, height: self.view.frame.size.height)
        viewMenu.backgroundColor = colorDarkGray
        
        viewMenu.layer.shadowColor = UIColor.black.cgColor
        viewMenu.layer.shadowOffset = CGSize(width: 5,height: 5)
        viewMenu.layer.shadowRadius = 5
        viewMenu.layer.shadowOpacity = 0.5
        
        self.view.addSubview(viewMenu)
        
        let lblFoodTalk = UILabel(frame: CGRect(x: 46, y: 31, width: 170, height: 24))
        if(loginAs == "guest"){
          lblFoodTalk.text = "FOOD TALK"
        }
        else{
          lblFoodTalk.text = (dictUserDetails.object(forKey: "name") as? String)?.uppercased()
        }
        lblFoodTalk.textColor = colorLightGold
        lblFoodTalk.font = UIFont(name: fontAbril, size : 20)
        lblFoodTalk.tag = 12321
     //   viewMenu.addSubview(lblFoodTalk)
        
        let lblPrevilege = UILabel(frame: CGRect(x: 46, y: 55, width: 170, height: 18))
        let lblSaved = UILabel(frame: CGRect(x: 46, y: 79, width: 170, height: 18))
        if(loginAs == "guest"){
            lblPrevilege.text = ""
            lblSaved.text = ""
        }
        else{
            lblPrevilege.text = "Privilege Member"
            if((UserDefaults.standard.object(forKey: "saved")) != nil){
                let saved = UserDefaults.standard.object(forKey: "saved") as! String
                lblSaved.text = String(format : "", saved)
            }
            else{
              lblSaved.text = String(format : "")
            }
        }
        lblPrevilege.textColor = .white
        lblPrevilege.font = UIFont(name: "Futura-Medium", size : 12)
        lblPrevilege.tag = 12345
     //   viewMenu.addSubview(lblPrevilege)
        
        lblSaved.textColor = .white
        lblSaved.font = UIFont(name: "Futura-Medium", size : 12)
        lblSaved.tag = 123456
        
        if tblMenu.isDescendant(of: viewMenu) {
           tblMenu.removeFromSuperview()
        }
        tblMenu = UITableView()
        tblMenu.frame = CGRect(x: 0, y: 100, width: viewMenu.frame.size.width, height: viewMenu.frame.size.height - 100)
        tblMenu.backgroundColor = .clear
        tblMenu.separatorColor = .clear
        tblMenu.dataSource = self
        tblMenu.delegate = self
        viewMenu.addSubview(tblMenu)
        
        let viewCity = UIView(frame : CGRect(x: 0, y : viewMenu.frame.size.height - 45, width: viewMenu.frame.size.width, height: 45))
        viewCity.backgroundColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleTap1(_:)))
        tap.delegate = self
        viewCity.addGestureRecognizer(tap)
        
        let imgViewIcon = UIImageView()
        imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 17, height : 22)
        imgViewIcon.image = UIImage(named : "location_on.png")
        viewCity.addSubview(imgViewIcon)
        
        let lblTap = UILabel()
        lblMenuCity.frame = CGRect(x: 94, y: 5, width: 170, height: 22)
        lblTap.frame = CGRect(x: 94, y: viewCity.frame.size.height - 17, width : 120, height : 15)
        lblTap.text = "TAP TO CHANGE CITY"
        lblTap.textColor = UIColor.lightGray
        lblTap.font = UIFont.boldSystemFont(ofSize: 10)
        lblTap.tag = 12321
        viewCity.addSubview(lblTap)
        
        let lblVersion = UILabel(frame : CGRect(x: 46, y: viewMenu.frame.size.height - 85, width: 170, height: 30))
        lblVersion.textColor = UIColor.darkGray
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            lblVersion.text = ""
        }
        viewMenu.addSubview(lblVersion)
        
        if(city_id == "1"){
            lblMenuCity.text = "DELHI NCR"
        }
        else if(city_id == "2"){
            lblMenuCity.text = "MUMBAI"
        }
        
        lblMenuCity.textColor = .white
        lblMenuCity.font = UIFont.boldSystemFont(ofSize: 17)
        viewCity.addSubview(lblMenuCity)
        
        if((viewMenu.viewWithTag(12321)) != nil){
            viewMenu.viewWithTag(12321)?.removeFromSuperview()
            viewMenu.viewWithTag(12345)?.removeFromSuperview()
            viewMenu.viewWithTag(123456)?.removeFromSuperview()
        }
        
        viewMenu.addSubview(lblFoodTalk)
        viewMenu.addSubview(lblPrevilege)
        viewMenu.addSubview(lblSaved)
        viewMenu.addSubview(viewCity)
    }
    
    func handleTap1(_ sender: UITapGestureRecognizer) {
        if(isMoreTapped == false){
            
        }
        else{
            let btn = UIButton()
            openMenu(btn)
        }
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "CitySelection") as! CitySelectionViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    func setCollectionView(){
        
        if(UIScreen.main.bounds.size.height > 670){
            self.collectionView.frame = CGRect(x: 20, y: 2, width: self.view.frame.size.width - 40,height: (viewBase?.frame.size.height)! - 3)
        }
        else if(UIScreen.main.bounds.size.height < 500){
            if(loginAs == "guest"){
            self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)! - 6)
            }
            else{
              self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)! - 6)
            }
        }
        else if(UIScreen.main.bounds.size.height < 570){
            if(loginAs == "guest"){
                self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)! - 6)
            }
            else{
                self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)! - 6)
            }
        }
        else{
            if(loginAs == "guest"){
            self.collectionView.frame = CGRect(x: 20, y: 5, width: self.view.frame.size.width - 40,height: (viewBase?.frame.size.height)! - 6)
            }
            else{
              self.collectionView.frame = CGRect(x: 20, y: 5, width: self.view.frame.size.width - 40,height: (viewBase?.frame.size.height)! - 6)
            }
        }
        
        
 //       self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(PackCollectionViewCell.self, forCellWithReuseIdentifier: kCellReuse) // UICollectionViewCell
        
        let nipName=UINib(nibName: "PackCollectionViewCell", bundle:nil)
        
        collectionView.register(nipName, forCellWithReuseIdentifier: "PackCell")
        
        self.collectionView.register(SavingCollectionViewCell.self, forCellWithReuseIdentifier: kCellSavingReuse) // UICollectionViewCell
        
        let nipName1=UINib(nibName: "SavingCollectionViewCell", bundle:nil)
        
        collectionView.register(nipName1, forCellWithReuseIdentifier: "SavingCell")
        
        let nipName2=UINib(nibName: "TopUpCollectionViewCell", bundle:nil)
        
        collectionView.register(nipName2, forCellWithReuseIdentifier: "TopUpCollectionViewCell")
        // UICollectionReusableView
        
        viewBase?.addSubview(self.collectionView)
    }
    
    //MARK:- setExperienceTableView
    
    func setExperienceTable(){
        if(UIScreen.main.bounds.size.height > 670){
            self.tblExperience.frame = CGRect(x: self.view.frame.size.width, y: 25, width: self.view.frame.size.width - 40,height: (viewBase?.frame.size.height)! - 25)
        }
        else if(UIScreen.main.bounds.size.height < 500){
            if(loginAs == "guest"){
                self.tblExperience.frame = CGRect(x: self.view.frame.size.width, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)! - 5)
            }
            else{
                self.tblExperience.frame = CGRect(x: self.view.frame.size.width, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)! - 5)
            }
        }
        else if(UIScreen.main.bounds.size.height < 570){
            if(loginAs == "guest"){
                self.tblExperience.frame = CGRect(x: self.view.frame.size.width, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)! - 5)
            }
            else{
                self.tblExperience.frame = CGRect(x: self.view.frame.size.width, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)! - 5)
            }
        }
        else{
            if(loginAs == "guest"){
                self.tblExperience.frame = CGRect(x: self.view.frame.size.width, y: 5, width: self.view.frame.size.width - 40,height: (viewBase?.frame.size.height)! - 6)
            }
            else{
                self.tblExperience.frame = CGRect(x: self.view.frame.size.width, y: 5, width: self.view.frame.size.width - 40,height: (viewBase?.frame.size.height)! - 6)
            }
        }
        self.tblExperience.register(UINib(nibName: "ExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "ExperienceTableViewCell")
        self.tblExperience.showsVerticalScrollIndicator = false
        self.tblExperience.tableFooterView = UIView()
        self.tblExperience.delegate = self
        self.tblExperience.dataSource = self
        self.tblExperience.backgroundColor = UIColor.clear
        
        // UICollectionReusableView
        
        viewBase?.addSubview(self.tblExperience)
    }
    
    // MARK:- UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(loginAs == "user" || loginAs == "trail" || loginAs == "UnPaid"){
            if(indexPath.row == 0){
                if(loginAs == "user"){
                let cell : SavingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellSavingReuse, for: indexPath) as! SavingCollectionViewCell
                cell.backgroundColor = colorDarkGray
                cell.lblSavingAmount?.text = String(format : "You have saved \u{20B9} %@", savingValue)
                return cell
                }
                else if(loginAs == "trail"){
                    let cell : TopUpCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopUpCollectionViewCell", for: indexPath) as! TopUpCollectionViewCell
                    cell.backgroundColor = colorDarkGray
                    
                    cell.btnAction?.frame = CGRect(x: cell.frame.size.width - 84, y: cell.frame.size.height/2 - 15, width: 74, height: 30)
                    cell.lblText?.frame = CGRect(x: 10, y: 0, width: cell.frame.size.width - 100, height: cell.frame.size.height)
                    
                    setDownLine(cell.btnAction!)
                    if(arrCards.count > 0){
                    let expiryDate = UserDefaults.standard.object(forKey: "expiry") as! String
                    let fullNameArr = expiryDate.components(separatedBy: " ")
                    
                    let date1    = fullNameArr[0]
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let s = dateFormatter.date(from:date1)
                    
                    let calendar = NSCalendar.current as NSCalendar
                    
                    let fullNameArr1 = todayDate.components(separatedBy: " ")
                    
                    let date2    = fullNameArr1[0]
                    
                    let s1 = dateFormatter.date(from: date2)
                    let flags = NSCalendar.Unit.day
                    let components = calendar.components(flags, from: s1!, to: s!, options: [])
                    let daysNumber = components.day
                
                    if(daysNumber! > 0){
                        if(Int(savingValue)! > 0){
                            var strVal = String(format : "You saved \u{20B9} %@ with your privilege trial. You have %d days of trial remaining.", savingValue, daysNumber! + 1)
                            
                            let myMutableString = NSMutableAttributedString(string: strVal, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
                            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:10,length:savingValue.characters.count + 2))
                            myMutableString.addAttribute(NSForegroundColorAttributeName, value: colorLightGold, range: NSRange(location:21,length:21))
                            
                            // set label Attribute
                            cell.lblText?.attributedText = myMutableString
                            
                            cell.btnAction?.setTitle("BUY NOW", for: .normal)
                            
                        }
                        else{
                            let strVal = String(format : "Your trial will expire in %d days. Start redeeming now",daysNumber! + 1)
                            let myMutableString = NSMutableAttributedString(string: strVal, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
                            myMutableString.addAttribute(NSForegroundColorAttributeName, value:colorLightGold, range: NSRange(location:26,length: 6))
                            
                            // set label Attribute
                            cell.lblText?.attributedText = myMutableString
                            cell.btnAction?.setTitle("BUY NOW", for: .normal)
                        }
                        
                    }
                    else{
                        if(arrCards.count > 0){
                        if(savingValue.characters.count > 0){
                            if(Int(savingValue)! > 0){
                            let strVal = String(format : "Your 7 days trial has expired, you saved \u{20B9} %@, Buy now to continue.", savingValue)
                            
                            let myMutableString = NSMutableAttributedString(string: strVal, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
                            myMutableString.addAttribute(NSForegroundColorAttributeName, value:UIColor.white, range: NSRange(location:45,length: savingValue.characters.count))
                            
                            // set label Attribute
                            cell.lblText?.attributedText = myMutableString
                            
                            cell.btnAction?.setTitle("BUY NOW", for: .normal)
                            }
                            else{
                                cell.lblText?.text = "Your 7 day trial has expired. Buy now to continue"
                                cell.btnAction?.setTitle("BUY NOW", for: .normal)
                            }
                        }
                        else{
                            cell.lblText?.text = "Your 7 day trial has expired. Buy now to continue"
                            cell.btnAction?.setTitle("BUY NOW", for: .normal)
                        }
                        }
                    }
                    }
                    cell.btnAction?.addTarget(self, action: #selector(HomeViewController.buyClicked(_:)), for: .touchUpInside)
                    return cell
                }
                else{
                    let cell : TopUpCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopUpCollectionViewCell", for: indexPath) as! TopUpCollectionViewCell
                    cell.backgroundColor = colorDarkGray
                    cell.btnAction?.frame = CGRect(x: cell.frame.size.width - 84, y: cell.frame.size.height/2 - 15, width: 74, height: 30)
                    cell.lblText?.frame = CGRect(x: 10, y: 0, width: cell.frame.size.width - 100, height: cell.frame.size.height)
                    setDownLine(cell.btnAction!)
                    var strVal = "Unlock all your offers for 7 days at no cost. Start your trial"
                    
                    let myMutableString = NSMutableAttributedString(string: strVal, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
                    myMutableString.addAttribute(NSForegroundColorAttributeName, value: colorLightGold, range: NSRange(location:40,length: 17))
                    
                    // set label Attribute
                    cell.lblText?.attributedText = myMutableString
                    
                    cell.btnAction?.setTitle("START TRIAL", for: .normal)
                    cell.btnAction?.addTarget(self, action: #selector(HomeViewController.buyClicked(_:)), for: .touchUpInside)
                    return cell
                }
            }
            else{
                let cell : PackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuse, for: indexPath) as! PackCollectionViewCell
                cell.backgroundColor = .white
                
                if(arrCards.count > 0){
                cell.lblMoney?.text = String(format : "\u{20B9} %@", (arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "cost") as! String)
                let imgCell = (arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "card_image") as! String
                cell.lblDistance?.layer.cornerRadius = 9.5
                cell.lblDistance?.layer.masksToBounds = false
                dropShadow(color: .darkGray, opacity: 1.0, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true, lbl: cell.lblDistance!)
                
                if(((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "distance")) != nil){
                    cell.lblDistance?.isHidden = false
                    var distance = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "distance") as! NSString).doubleValue
                    distance = distance / 1000
                    if(distance > 100){
                       cell.lblDistance?.isHidden = true
                    }
                    else{
                        cell.lblDistance?.isHidden = false
                    cell.lblDistance?.text = String(format : "%.1f KM", distance)
                    }
                }
                else{
                    cell.lblDistance?.isHidden = true
                }
            
            cell.packCellImage?.image = nil
                DispatchQueue.main.async{
                    
                    setImageWithUrl(imgCell, imgView: cell.packCellImage!)
                    
                }
                
                cell.lblRestaurant?.text = (arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "name") as? String
                
                let outletCount = (arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "primary_cuisine") as? String
                
                
                cell.lblLocation?.text = outletCount
                
                let amount = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "cost") as! NSString).intValue
                if(amount < 500){
                    cell.lblMoney?.text = String(format : "%@", "\u{20B9}")
                }
                else if(amount < 999){
                    cell.lblMoney?.text = String(format : "%@%@", "\u{20B9}", "\u{20B9}")
                }
                else{
                    cell.lblMoney?.text = String(format : "%@%@%@", "\u{20B9}", "\u{20B9}", "\u{20B9}")
                }
                }
                
                cell.layer.shadowColor = colorDarkGray.cgColor
                cell.layer.shadowOpacity = 0.2
                cell.layer.opacity = 1
                cell.layer.shadowOffset = CGSize(width: 0, height: 2)
                cell.layer.shadowRadius = 1
                
                return cell
            }
        }
        else{
            
            if(indexPath.row == 0){
                let cell : TopUpCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopUpCollectionViewCell", for: indexPath) as! TopUpCollectionViewCell
                cell.btnAction?.frame = CGRect(x: cell.frame.size.width - 84, y: cell.frame.size.height/2 - 15, width: 74, height: 30)
                cell.lblText?.frame = CGRect(x: 10, y: 0, width: cell.frame.size.width - 100, height: cell.frame.size.height)
                
                setDownLine(cell.btnAction!)
                cell.backgroundColor = colorDarkGray
                let strVal = "Unlock all your offers for 7 days at no cost. Start your trial."
                
                let myMutableString = NSMutableAttributedString(string: strVal, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
                myMutableString.addAttribute(NSForegroundColorAttributeName, value: colorLightGold, range: NSRange(location:40,length:17))
                
                // set label Attribute
                cell.lblText?.attributedText = myMutableString
                
                cell.btnAction?.setTitle("START TRIAL", for: .normal)
                cell.btnAction?.addTarget(self, action: #selector(HomeViewController.buyClicked(_:)), for: .touchUpInside)
                return cell
            }
            else{
            let cell : PackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuse, for: indexPath) as! PackCollectionViewCell
            cell.backgroundColor = .white
            if(arrCards.count > 0){
            cell.lblMoney?.text = String(format : "\u{20B9} %@", (arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "cost") as! String)
            
            let imgCell = (arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "card_image") as! String
           
            DispatchQueue.main.async{
                setImageWithUrl(imgCell, imgView: cell.packCellImage!)
            }
                
            cell.lblDistance?.layer.cornerRadius = 9.5
            cell.lblDistance?.layer.masksToBounds = false
            dropShadow(color: .darkGray, opacity: 1.0, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true, lbl: cell.lblDistance!)
            if(((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "distance")) != nil){
                cell.lblDistance?.isHidden = false
                var distance = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "distance") as! NSString).doubleValue
                distance = distance / 1000
                if(distance > 100){
                    cell.lblDistance?.isHidden = true
                }
                else{
                    cell.lblDistance?.isHidden = false
                    cell.lblDistance?.text = String(format : "%.1f KM", distance)
                }
            }
            else{
                cell.lblDistance?.isHidden = true
            }
            
            cell.lblRestaurant?.text = (arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "name") as? String
            
            let outletCount = (arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "primary_cuisine") as? String
            
            
            cell.lblLocation?.text = outletCount
            
            let amount = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "cost") as! NSString).intValue
            if(amount < 500){
                cell.lblMoney?.text = String(format : "%@", "\u{20B9}")
            }
            else if(amount < 999){
                cell.lblMoney?.text = String(format : "%@%@", "\u{20B9}", "\u{20B9}")
            }
            else{
                cell.lblMoney?.text = String(format : "%@%@%@", "\u{20B9}", "\u{20B9}", "\u{20B9}")
            }
            }
            cell.layer.shadowColor = colorDarkGray.cgColor
            cell.layer.shadowOpacity = 0.2
            cell.layer.opacity = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 1
            
            return cell
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1  // Number of section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(loginAs == "guest"){
           return arrCards.count + 1
        }
        if(loginAs == "user" || loginAs == "trail" || loginAs == "UnPaid"){
           return arrCards.count + 1
        }
        return arrCards.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        if(UIScreen.main.bounds.size.height > 670){
           layout.sectionInset = UIEdgeInsets(top: 15, left: 20, bottom: 5, right: 20)
        }
        else if(UIScreen.main.bounds.size.height < 570){
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        else{
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        if(UIScreen.main.bounds.size.height > 670){
            if(loginAs == "user" || loginAs == "trail" || loginAs == "UnPaid"){
                if(indexPath.row == 0){
                    return CGSize(width: self.collectionView.frame.size.width, height: 80);
                }
                else{
                    return CGSize(width: 170, height: 220);
                }
            }
            if(indexPath.row == 0){
                return CGSize(width: collectionView.frame.size.width, height: 80);
            }
            return CGSize(width: 170, height: 220)
        }
        else if(UIScreen.main.bounds.size.height < 570){
            if(loginAs == "user" || loginAs == "trail" || loginAs == "UnPaid"){
                if(indexPath.row == 0){
                    return CGSize(width: self.collectionView.frame.size.width, height: 80);
                }
                else{
                    
                    return CGSize(width: 140, height: 190);
                }
            }
            if(indexPath.row == 0){
                
                return CGSize(width: self.collectionView.frame.size.width, height: 80);
            }
            return CGSize(width: 140, height: 190);
        }
        else{
            if(loginAs == "user" || loginAs == "trail" || loginAs == "UnPaid"){
                if(indexPath.row == 0){

                  return CGSize(width: self.collectionView.frame.size.width, height: 80);
                }
                else{
                   return CGSize(width: 160, height: 210);
                }
            }
            if(indexPath.row == 0){
                
                return CGSize(width: self.collectionView.frame.size.width, height: 80);
            }
            return CGSize(width: 160, height: 210);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if(UIScreen.main.bounds.size.height > 670){
            return 18
        }
        else if(UIScreen.main.bounds.size.height < 570){
            return 5
        }
        else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if(UIScreen.main.bounds.size.height > 670){
            return 18
        }
        else if(UIScreen.main.bounds.size.height < 570){
            return 5
        }
        else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row != 0){
        if(isMoreTapped == false){
            
            var outletCount : Int = 0
            var offerCount : Int = 0
            if(loginAs == "user" || loginAs == "trail" || loginAs == "UnPaid"){
               // if(savingValue == "0"){
                    restaurantDetails = arrCards.object(at: indexPath.row - 1) as! NSDictionary
                    restaurantId = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "rid") as? String)!
                    strOneLiner = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "one_liner") as? String)!
                    restaurantName = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "name") as? String)!
                    outletCount =  Int(Int32((((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "outlet_count") as? NSString)?.intValue)!))
                    
                    offerCount = Int(Int32((((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "offer_count") as? NSString)?.intValue)!))
                    
                    if(outletCount > 1){
                        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOutlet") as! SelectOutletViewController;
                        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                    }
                    else if(offerCount > 1){
                        strAddress = ""
                        outletId = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "outlet_ids") as? String)!
                        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOffer") as! SelectOfferViewController;
                        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                    }
                    else{
                        outletId = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "outlet_ids") as? String)!
                        offerIds = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "offer_ids") as? String)!
                        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "StoreDetails") as! StoreDetailsViewController;
                        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                    }
            }
            else{
        restaurantDetails = arrCards.object(at: indexPath.row - 1) as! NSDictionary
        restaurantId = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "rid") as? String)!
        strOneLiner = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "one_liner") as? String)!
        restaurantName = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "name") as? String)!
                outletCount =  Int(Int32((((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "outlet_count") as? NSString)?.intValue)!))
                
                offerCount = Int(Int32((((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "offer_count") as? NSString)?.intValue)!))
                
                if(outletCount > 1){
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOutlet") as! SelectOutletViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
                else if(offerCount > 1){
                    strAddress = ""
                    outletId = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "outlet_ids") as? String)!
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOffer") as! SelectOfferViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
                else{
                    outletId = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "outlet_ids") as? String)!
                    offerIds = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "offer_ids") as? String)!
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "StoreDetails") as! StoreDetailsViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
            }
        }
        else{
            let btn = UIButton()
            openMenu(btn)
        }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastElement = arrCards.count - 2
        if indexPath.row == lastElement {
            loadMoreMethod()
        }
    }
    
    //MARK:- loadMore
    
    func loadMoreMethod(){
        if(isMoreTapped == false){
            if(nextPageUrl.characters.count > 0){
                //   callWebNextUrl()
                if CLLocationManager.locationServicesEnabled() {
                    switch(CLLocationManager.authorizationStatus()) {
                    case .notDetermined, .restricted, .denied:
                        DispatchQueue.main.async{
                            self.callWebNextUrl()
                        }
                        
                    case .authorizedAlways, .authorizedWhenInUse:
                        viewBottom.isHidden = true
                        locationManager.startUpdatingLocation()
                        DispatchQueue.main.async{
                            self.callWebNextLocationUrl()
                        }
                        
                    }
                    
                } else {
                    DispatchQueue.main.async{
                        self.callWebNextUrl()
                    }
                }
            }
        }
    }
    
    //MARK:- TableViewDelegates and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblExperience){
            return arrExperience.count
        }
        else{
        if(loginAs == "guest"){
            return 7
        }
        else{
            return 7
        }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tblMenu){
        let cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
//         if (cell == nil) {
//           cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
//           }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        if(loginAs == "guest"){
           if((indexPath.row == 1) || (indexPath.row == 3) || (indexPath.row == 5)){
            
           }
           else{
             addSubViewOnCell(cell, indexPath: indexPath)
           }
        }
        else{
            if((indexPath.row == 1) || (indexPath.row == 3) || (indexPath.row == 5)){
                
            }
            else{
                addSubViewOnCell(cell, indexPath: indexPath)
            }
        }
        return cell
        }
        else{
           let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceTableViewCell", for: indexPath) as! ExperienceTableViewCell
            cell.btnDetails?.addTarget(self, action: #selector(HomeViewController.detailsExp(_:)), for: .touchUpInside)
            cell.lblEventName?.text = (arrExperience.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String
        //    cell.lblTime?.text = (arrExperience.object(at: indexPath.row) as! NSDictionary).object(forKey: "display_time") as? String
            
            let str = (arrExperience.object(at: indexPath.row) as! NSDictionary).object(forKey: "display_time") as? String
            
            if let range = str?.range(of: "\n") {
                let startPos = str?.distance(from: (str?.startIndex)!, to: range.lowerBound)
                let myMutableString = NSMutableAttributedString(string: str!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
                myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:startPos!,length: (str?.characters.count)! - startPos!))
                
                myMutableString.addAttribute(NSFontAttributeName, value : UIFont.systemFont(ofSize: 10), range: NSRange(location:startPos!,length: (str?.characters.count)! - startPos!))
                
                cell.lblTime?.attributedText = myMutableString
            }
            else {
                cell.lblTime?.text = (arrExperience.object(at: indexPath.row) as! NSDictionary).object(forKey: "display_time") as? String
            }
            
            cell.backgroundColor = .white
            
            let available_seats = (arrExperience.object(at: indexPath.row) as! NSDictionary).object(forKey: "avilable_seats") as! String
            if(available_seats == "0"){
                cell.btnDetails?.backgroundColor = UIColor(red: 350/255, green: 75/255, blue: 100/255, alpha: 1.0)
                cell.btnDetails?.setTitle("SOLD OUT", for: .normal)
            }
            else{
                cell.btnDetails?.backgroundColor = UIColor(red: 54/255, green: 200/255, blue: 69/255, alpha: 1.0)
                cell.btnDetails?.setTitle("VIEW DETAILS", for: .normal)
            }
            cell.lblAddress?.text = (arrExperience.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as? String
            cell.lblPrice?.text = String(format : "%@ / Person", ((arrExperience.object(at: indexPath.row) as! NSDictionary).object(forKey: "cost") as? String)!)
            cell.btnWorkshop?.setTitle((arrExperience.object(at: indexPath.row) as! NSDictionary).object(forKey: "tag") as? String, for: .normal)
            setImageWithUrl(((arrExperience.object(at: indexPath.row) as! NSDictionary).object(forKey: "cover_image") as? String)!, imgView: cell.imgView!)
         //   cell.imgView?.backgroundColor = UIColor(red: 240/255, green: 250/255, blue: 252/255, alpha: 1.0)
            cell.btnDetails?.tag = indexPath.row
            
            cell.viewBack?.layer.shadowColor = UIColor.black.cgColor
            cell.viewBack?.layer.shadowOffset = CGSize(width:2.0,height: 2.0);
            cell.viewBack?.layer.shadowRadius = 5.0;
            cell.viewBack?.layer.shadowOpacity = 1.0;
            cell.viewBack?.layer.masksToBounds = false
            cell.selectionStyle = .none
            let shadowRect: CGRect = (cell.viewBack?.bounds.insetBy(dx: 4, dy: 4))!
            cell.viewBack?.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
            
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == tblMenu){
        if(loginAs == "guest"){
            if(indexPath.row == 0){
                
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "LoginNumber") as! LoginNumberViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 2){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "BuySignup") as! BuySignupViewController;
                self.navigationController!.pushViewController(openPost, animated: true)
            }
            
            else if(indexPath.row == 4){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Help&Support") as! Help_SupportViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 6){
                contactUs()
            }
            self.viewChoice?.frame = CGRect(x: 0, y: (self.viewNavigate?.frame.size.height)!, width: self.view.frame.size.width, height: 52)
        }
        else{
            
            if(indexPath.row == 0){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Account") as! AccountViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            
            else if(indexPath.row == 4){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Help&Support") as! Help_SupportViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 2){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Tickets") as! TicketsViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 6){
                FBSDKAppEvents.logEvent("contact_us_view")
                contactUs()
            }
            self.viewChoice?.frame = CGRect(x: 0, y: (self.viewNavigate?.frame.size.height)!, width: self.view.frame.size.width, height: 52)
        }
            if(isMoreTapped == false){
                
            }
            else{
                let btn = UIButton()
                openMenu(btn)
            }
        }
        else{
            if(isMoreTapped == false){
                
            }
            else{
                let btn = UIButton()
                openMenu(btn)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tblMenu){
        if(indexPath.row == 3){
            return 25
        }
        else if(indexPath.row == 5){
            return 15
        }
        else if(indexPath.row == 1){
            return 10
        }
        return 45
        }
        else{
            if(self.view.frame.size.height < 570){
            return 327
            }
            else if(self.view.frame.size.height < 670){
             return 330
            }
            return 340
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(tableView == tblExperience){
          let lastElement = arrExperience.count - 1
            if indexPath.row == lastElement {
                loadMoreTableMethod()
            }
        }
    }
    
    func loadMoreTableMethod(){
        if(isMoreTapped == false){
            if(nextTableUrl.characters.count > 0){
                DispatchQueue.main.async{
                    self.callWebTableNextUrl()
                }
            }
        }
    }
    
    func detailsExp(_ sender : UIButton){
        idExperience = ((arrExperience.object(at: sender.tag) as! NSDictionary).object(forKey: "id") as? String)!
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "ExperienceDetails") as! ExperienceDetailsViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    //MARK:- showAlert of yes no
    
    func showAlert(){
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
    
    //MARK:- addSubview
    
    func addSubViewOnCell(_ cell: UITableViewCell, indexPath : IndexPath){
        let imgViewIcon = UIImageView()
        let lblValue = UILabel()
        lblValue.tag = 29
        let lblTap = UILabel()
        if(loginAs == "guest"){
            
        if(indexPath.row == 0){
            imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 17, height : 22)
            imgViewIcon.image = UIImage(named : "fill131.png")
            
            lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
            lblValue.text = "LOGIN"
            lblValue.textColor = .white
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
        }
        else if(indexPath.row == 2){
            imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 22.8, height : 22)
            imgViewIcon.image = UIImage(named : "fill7.png")
            
            lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
            lblValue.text = "BUY NOW"
            lblValue.textColor = .white
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
        }

        else if(indexPath.row == 4){
            imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 17.7, height : 22)
            imgViewIcon.image = UIImage(named : "fill86.png")
            
            lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
            lblValue.text = "SUPPORT"
            lblValue.textColor = .white
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
        }
        else if(indexPath.row == 6){
            imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 21.6, height : 22)
            imgViewIcon.image = UIImage(named : "fill76.png")
            
            lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
            lblValue.text = "CONTACT US"
            lblValue.textColor = .white
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
        }
        }
        else{
            if(indexPath.row == 0){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 22, height : 22)
                imgViewIcon.image = UIImage(named : "fill9.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "ACCOUNT"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            else if(indexPath.row == 2){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2, width: 23, height : 21)
                imgViewIcon.image = UIImage(named : "ticket.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "TICKETS"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            
            else if(indexPath.row == 4){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 17.7, height : 22)
                imgViewIcon.image = UIImage(named : "fill86.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "SUPPORT"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            else if(indexPath.row == 6){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 21.6, height : 22)
                imgViewIcon.image = UIImage(named : "fill76.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "CONTACT US"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
        }
        
        let templateImage = imgViewIcon.image?.withRenderingMode(.alwaysTemplate)
        imgViewIcon.image = templateImage
        imgViewIcon.tintColor = colorLightGold
        
        imgViewIcon.tag = 22
        
        
        if((cell.contentView.viewWithTag(22)) != nil){
            cell.contentView.viewWithTag(22)?.removeFromSuperview()
            cell.contentView.viewWithTag(29)?.removeFromSuperview()
            cell.contentView.viewWithTag(12321)?.removeFromSuperview()
        }
        
        cell.contentView.addSubview(lblTap)
        cell.contentView.addSubview(imgViewIcon)
        cell.contentView.addSubview(lblValue)
    }
    
    //MARK:- openSearch
    
    @IBAction func openSearch(_ sender : UIButton){
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Search") as! SearchViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    //MARK:- MenuView
    
    @IBAction func openMenu(_ sender : UIButton){
        if(isMoreTapped == false){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.viewMenu.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/2 + 100, height: self.view.frame.size.height)
            self.viewChoice?.frame = CGRect(x: self.view.frame.size.width/2 + 100, y: (self.viewNavigate?.frame.size.height)!, width: self.view.frame.size.width, height: 52)
            self.viewNavigate?.frame = CGRect(x: self.view.frame.size.width/2 + 100, y: (self.viewNavigate?.frame.origin.y)!, width: (self.viewNavigate?.frame.size.width)!, height: (self.viewNavigate?.frame.size.height)!)
            self.viewBase?.frame = CGRect(x: self.view.frame.size.width/2 + 100, y: (self.viewBase?.frame.origin.y)!, width: (self.viewBase?.frame.size.width)!, height: (self.viewBase?.frame.size.height)!)
            self.viewBottom.frame = CGRect(x: self.view.frame.size.width/2 + 100, y: (self.viewBottom.frame.origin.y), width: (self.viewBottom.frame.size.width), height: (self.viewBottom.frame.size.height))
        })
            isMoreTapped = true
        }
        else{
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.viewMenu.frame = CGRect(x: -(self.view.frame.size.width/2 + 110), y: 0, width: self.view.frame.size.width/2 + 100, height: self.view.frame.size.height)
                self.viewChoice?.frame = CGRect(x: 0, y: (self.viewNavigate?.frame.size.height)!, width: self.view.frame.size.width, height: 52)
                self.viewNavigate?.frame = CGRect(x: 0, y: (self.viewNavigate?.frame.origin.y)!, width: (self.viewNavigate?.frame.size.width)!, height: (self.viewNavigate?.frame.size.height)!)
                self.viewBase?.frame = CGRect(x: 0, y: (self.viewBase?.frame.origin.y)!, width: (self.viewBase?.frame.size.width)!, height: (self.viewBase?.frame.size.height)!)
                self.viewBottom.frame = CGRect(x: 0, y: (self.viewBottom.frame.origin.y), width: (self.viewBottom.frame.size.width), height: (self.viewBottom.frame.size.height))
            })
            isMoreTapped = false
        }
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        arrCards.removeAllObjects()
        viewAlert.removeFromSuperview()
        DispatchQueue.main.async{
          self.callWebServiceForHome()
        }
    }
    
    //MARK:- WebServiceCalling
    
    func callWebServiceForHome(){
        
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@city_id=%@", baseUrl,"offers?",city_id)
            
            webServiceGet(url)
            delegate = self
        }
        else{
         stopAnimation(view: self.view)
         openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func callWebServiceForLocation(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@?latitude=%@&longitude=%@&city_id=%@", baseUrl,"offers", latitude, longitude, city_id)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
 
    }
    
    func webCallStartTrial(){
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@sessionid=%@", baseUrl,"trial?",session)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func callWebNextUrl(){
     //   showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@&city_id=%@", nextPageUrl, city_id)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func callWebTableNextUrl(){
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@", nextTableUrl)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func callWebNextLocationUrl(){
     //   showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@&latitude=%@&longitude=%@&city_id=%@", nextPageUrl,latitude, longitude, city_id)
            webServiceGet(url)
            delegate = self
        }
        else{
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func webServiceForProfile(){
       // showActivityIndicator(view: self.view)
        if((UserDefaults.standard.object(forKey: "session")) != nil){
        let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
        let session = dictSessionId.object(forKey: "session_id") as! String
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@%@", baseUrl,"profile?sessionid=", session)
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
        }
        else{
           self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func webServiceForExperience(){
        stopAnimation(view: self.view)
            if (isConnectedToNetwork() == true){
                if(city_id == ""){
                   city_id = "1"
                }
                let url = String(format: "%@%@?city_id=%@", baseUrl,"experiences", city_id)
                webServiceGet(url)
                delegate = self
            }
            else{
                stopAnimation(view: self.view)
                openAlertScreen(self.view)
                alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
            }
    }
    
    func webServiceForRating(){
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@sessionid=%@", baseUrl,"unreviewed?", session)
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func webserviceForRatingSubmit(){
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let order_id = dictRating.object(forKey: "id") as! String
            let url = String(format: "%@%@%@%@?sessionid=%@", baseUrl,"offer/","review/", order_id,session)
            let dict = NSMutableDictionary()
            dict.setObject(selectedRating, forKey: "rating" as NSCopying)
            webServiceCallingPost(url, parameters: dict)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
    
        stopAnimation(view: self.view)
        if((dict.object(forKey: "api") as! String).contains("profile")){
            todayDate = dict.object(forKey: "date_time") as! String
            savingValue = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "saving") as! String
            let city_id1 = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "city_id") as! String
            let arrSub = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "subscription") as! NSArray
            if(arrSub.count > 0){
                let dictS = arrSub.object(at: 0) as! NSDictionary
                let subType = dictS.object(forKey: "subscription_type_id") as! String
                let expiryD = dictS.object(forKey: "expiry") as! String
                UserDefaults.standard.set(expiryD, forKey: "expiry")
                if(subType == "3"){
                    loginAs = "trail"
                    viewBase?.frame = CGRect(x: 0, y: 114, width: self.view.frame.size.width, height: self.view.frame.size.height - 115)
               //     createBuyView()
                }
                else{
                    loginAs = "user"
                }
            }
            else{
                loginAs = "UnPaid"
            }
            if(city_id1 == ""){
                self.perform(#selector(HomeViewController.callwithdelay), with: nil, afterDelay: 1.0)
            }
            else{
                if(loginAs == "user" || loginAs == "trail" || loginAs == "UnPaid"){
                
                 UserDefaults.standard.set(city_id1, forKey: "city_id")
                }
            }
            city_id = city_id1
            if(city_id == "1"){
                lblCity?.text = "DELHI NCR"
                lblMenuCity.text = "DELHI NCR"
            }
            else if(city_id == "2"){
                lblCity?.text = "MUMBAI"
                lblMenuCity.text = "MUMBAI"
            }
            createMenuView()
            tblMenu.reloadData()
        }
            
        else if((dict.object(forKey: "api") as! String).contains("trial")){
            
            if(dict.object(forKey: "status") as! String == "OK"){
                todayDate = dict.object(forKey: "date_time") as! String
                let arrSubscribe = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "subscription") as! NSArray
                if(arrSubscribe.count > 0){
                    
                    loginAs = "trail"
                    let newInfo = NSMutableDictionary()
                    newInfo.setObject(dictUserDetails.object(forKey: "name") as! String, forKey: "name" as NSCopying)
                    newInfo.setObject(dictUserDetails.object(forKey: "phone") as! String, forKey: "phone" as NSCopying)
                    newInfo.setObject(dictUserDetails.object(forKey: "dob") as! String, forKey: "dob" as NSCopying)
                    newInfo.setObject(dictUserDetails.object(forKey: "email") as! String, forKey: "email" as NSCopying)
                    newInfo.setObject(dictUserDetails.object(forKey: "gender") as! String, forKey: "gender" as NSCopying)
                    newInfo.setObject(dictUserDetails.object(forKey: "preference") as! String, forKey: "preference" as NSCopying)
                    
                    let expiry = (arrSubscribe.object(at: 0) as! NSDictionary).object(forKey: "expiry") as? String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let s = dateFormatter.date(from:expiry!)
                    
                    let subscribeType = (arrSubscribe.object(at: 0) as! NSDictionary).object(forKey: "subscription_type_id") as? String
                    
                    let currentInstallation = PFInstallation.current()
                    currentInstallation.setObject(s!, forKey: "expiry")
                    currentInstallation.setObject(subscribeType!, forKey: "subscription_type_id")
                    currentInstallation.saveInBackground()
                    
                    let token = dictSessionInfo.object(forKey: "refresh_token") as! String
                    let userId = dictSessionInfo.object(forKey: "user_id") as! String
                    let currentInstallation1 = PFInstallation.current()
                    currentInstallation1.setObject(userId, forKey: "userId")
                    currentInstallation1.saveInBackground()
                    UserDefaults.standard.setValue(expiry, forKey: "expiry")
                    UserDefaults.standard.setValue(newInfo, forKey: "userDetails")
                    UserDefaults.standard.setValue(dictSessionInfo, forKey: "session")
                    UserDefaults.standard.setValue(token, forKey: "token")
                    
                    let alert = UIAlertController(title: "SUCCESS", message: "Your 7 days free trial has started.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
            
        else if((dict.object(forKey: "api") as! String).contains("offers")){
            stopAnimation(view: self.view)
        if(dict.object(forKey: "status") as! String == "OK"){
            todayDate = dict.object(forKey: "date_time") as! String
            let arr = ((dict.object(forKey: "result") as! NSDictionary).object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
            for index in 0..<arr.count{
                arrCards.add(arr.object(at: index) as! NSDictionary)
            }
            nextPageUrl = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "next_page_url") as! String
        }
            collectionView.reloadData()
        }
        else if((dict.object(forKey: "api") as! String).contains("offer/review")){
           if(dict.object(forKey: "status") as! String == "OK"){
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.ratingView?.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 295)
            })
            viewBase?.isUserInteractionEnabled = true
            btnOffer?.isEnabled = true
            btnExperience?.isEnabled = true
            btnMore?.isEnabled = true
            btnSearch?.isEnabled = true
            }
        }
        else if((dict.object(forKey: "api") as! String).contains("experiences")){
            
            stopAnimation(view: self.view)
            if(dict.object(forKey: "status") as! String == "OK"){
                todayDate = dict.object(forKey: "date_time") as! String
                
                let dict1 = dict.object(forKey: "result") as! NSDictionary
                if(dict1.count > 0){
                let arr = ((dict.object(forKey: "result") as! NSDictionary).object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                for index in 0..<arr.count{
                    arrExperience.add(arr.object(at: index) as! NSDictionary)
                }
               nextTableUrl = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "next_page_url") as! String
                }
            }
            if(arrExperience.count > 0){
                viewEmpty.isHidden = true
            }
            else{
                viewEmpty.isHidden = false
            }
            tblExperience.reloadData()
            
            if(openPushView == "exp"){
              let btn = UIButton()
                self.perform(#selector(HomeViewController.experienceChoice(_:)), with: btn, afterDelay: 1.5)
            }
        }
        else if((dict.object(forKey: "api") as! String).contains("unreviewed")){
            
            stopAnimation(view: self.view)
            if(dict.object(forKey: "status") as! String == "OK"){
               let dic = dict.object(forKey: "result") as! NSDictionary
               let arr = dic.object(forKey: "offers") as! NSArray
                if(arr.count > 0){
                    dictRating = arr.object(at : 0) as! NSDictionary
                    lblRestaurantName?.text = dictRating.object(forKey: "name") as? String
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
                       self.ratingView?.frame = CGRect(x: 0, y: self.view.frame.size.height - 295, width: self.view.frame.size.width, height: 295)
                    })
                    viewBase?.isUserInteractionEnabled = false
                    btnOffer?.isEnabled = false
                    btnExperience?.isEnabled = false
                    btnMore?.isEnabled = false
                    btnSearch?.isEnabled = false
                }
                else{
                    viewBase?.isUserInteractionEnabled = true
                    btnOffer?.isEnabled = true
                    btnExperience?.isEnabled = true
                    btnMore?.isEnabled = true
                    btnSearch?.isEnabled = true
                }
            }
        }
        UIView.performWithoutAnimation {
            self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
          //  self.collectionView.reloadData()
        }
    }
    
    func callwithdelay(){
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "CitySelection") as! CitySelectionViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    func serviceFailedWitherror(_ error : NSError){
      //  stopAnimation()
        self.view.isUserInteractionEnabled = true
        UserDefaults.standard.setValue(nil, forKey: "userDetails")
        UserDefaults.standard.setValue(nil, forKey: "session")
        UserDefaults.standard.setValue(nil, forKey: "expiry")
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "LoginNumber") as! LoginNumberViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
    }
    
    //MARK:- scrollview delegate
    
    
    
    //MARK:- contactUS
    
    func contactUs(){
        let emailTitle = "Contact Us"
        let messageBody = ""
        let toRecipents = ["contact@foodtalkindia.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        if (MFMailComposeViewController.canSendMail()) {
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: true)
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        }
    }
    
    //MARK:- mailComposer delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- createRatingView
    
    func createRatingView(){
        ratingView?.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 295)
        lblRate?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 51)
        lblHowText?.frame = CGRect(x: 0, y: 68, width: self.view.frame.size.width, height: 21)
        lblRestaurantName?.frame = CGRect(x: 0, y: 98, width: self.view.frame.size.width, height: 21)
        floatRatingView?.frame = CGRect(x: 45, y: 138, width: self.view.frame.size.width - 90, height: 55)
        btnSubmit?.frame = CGRect(x: 0, y: (ratingView?.frame.size.height)! - 57, width: self.view.frame.size.width, height: 57)
        
        self.floatRatingView.emptyImage = UIImage(named: "stars-02.png")
        self.floatRatingView.fullImage = UIImage(named: "stars-01.png")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 0
        self.floatRatingView.rating = 0
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = false
        self.floatRatingView.floatRatings = false
    }
    
    @IBAction func submitRating(_ sender : UIButton){
        if(selectedRating != "0.0"){
        webserviceForRatingSubmit()
        }
    }
    
    //MARK:- Shadow
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true, lbl : UILabel) {
        lbl.layer.masksToBounds = false
        lbl.layer.shadowColor = color.cgColor
        lbl.layer.shadowOpacity = opacity
        lbl.layer.shadowOffset = offSet
        lbl.layer.shadowRadius = radius
        
        lbl.layer.shadowPath = UIBezierPath(rect: lbl.bounds).cgPath
        lbl.layer.shouldRasterize = true
        lbl.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //   self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //   self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        
        selectedRating = String(format: "%.1f", self.floatRatingView.rating)
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
