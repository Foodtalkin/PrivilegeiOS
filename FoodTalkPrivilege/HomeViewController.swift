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

class HomeViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, WebServiceCallingDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate, CLLocationManagerDelegate {
    
    fileprivate let barSize : CGFloat = 44.0
    fileprivate let kCellReuse : String = "PackCell"
    fileprivate let kCellheaderReuse : String = "PackHeader"
    fileprivate let kCellSavingReuse : String = "SavingCell"
    fileprivate let kCellSavingheaderReuse : String = "SavingHeader"
    var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var tblMenu = UITableView()
    
    @IBOutlet var btnMore : UIButton?
    @IBOutlet var btnSearch : UIButton?
    @IBOutlet var viewNavigate : UIView?
    @IBOutlet var viewBase : UIView?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = colorPaleGray
      
        // Do any additional setup after loading the view.
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeDown)
        
        
      //  Analytics.setScreenName("Home", screenClass: "Home")
        FBSDKAppEvents.logEvent("First_Enter")

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation

        
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
                    }
                }
            
            default:
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(loginAs == "guest"){
            viewBase?.frame = CGRect(x: 0, y: 114, width: self.view.frame.size.width, height: self.view.frame.size.height - 115)
            createBuyView()
        }
        else{
            viewBuy.isHidden = true
            viewBase?.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 65)
            webServiceForProfile()
        }
     //   viewBase?.backgroundColor = .red
        setCollectionView()
        createMenuView()
        tblMenu.reloadData()
        self.navigationController?.isNavigationBarHidden = true
        
        createBottomView()
        
        findLocationService()
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
        viewBase?.frame.size.height = (viewBase?.frame.size.height)! + 60
    }
    
    func selectLocation(_ sender : UIButton){
    //    locationManager.startUpdatingLocation()
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
       // }
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
                viewBase?.frame.size.height = (viewBase?.frame.size.height)! + 50
            //    collectionView.frame.size.height = (viewBase?.frame.size.height)!
            }
            else{
                viewBase?.frame.size.height = (viewBase?.frame.size.height)! + 50
           //     collectionView.frame.size.height = (viewBase?.frame.size.height)!
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
                DispatchQueue.main.async{
                    self.callWebServiceForHome()
                }
            case .authorizedAlways, .authorizedWhenInUse:
                viewBottom.isHidden = true
                
             locationManager.startUpdatingLocation()
                
            }
        } else {
            print("Location services are not enabled")
            DispatchQueue.main.async{
                self.callWebServiceForHome()
            }
        }
    }
    
    func createBuyView(){
        
        viewBuy.frame = CGRect(x: 0, y: (viewNavigate?.frame.size.height)!, width: self.view.frame.size.width, height: 50)
        viewBuy.isHidden = false
        viewBuy.backgroundColor = colorDarkGray
        self.view.addSubview(viewBuy)
        
        let lblText = UILabel(frame : CGRect(x: 20, y : 0, width: self.view.frame.size.width/2 + 15, height: 40))
        lblText.text = "Get access to all these offers for one year at \u{20B9} 1200 only."
        lblText.textColor = .white
        lblText.numberOfLines = 0
        if(UIScreen.main.bounds.size.height < 570){
           lblText.font = UIFont(name: "Futura-Medium", size: 12)
        }
        else{
           lblText.font = UIFont(name: "Futura-Medium", size: 14)
        }
        viewBuy.addSubview(lblText)
        
        let btnBuy = UIButton(frame: CGRect(x: self.view.frame.size.width - 124, y : 6, width: 104, height: 38))
        btnBuy.backgroundColor = colorLightGold
        
        btnBuy.setTitle("BUY", for: .normal)
        btnBuy.setTitleColor(colorDarkGray, for: .normal)
        btnBuy.titleLabel?.font = UIFont(name : fontFuturaBold, size: 12)
        btnBuy.addTarget(self, action: #selector(HomeViewController.buyClicked(_:)), for: .touchUpInside)
        setDownLine(btnBuy)
        viewBuy.addSubview(btnBuy)
    }
    
    func buyClicked(_ sender : UIButton){
        
        viewMenu.removeFromSuperview()
        viewBuy.removeFromSuperview()
        tblMenu.removeFromSuperview()
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "BuySignup") as! BuySignupViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
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
        
        if((viewMenu.viewWithTag(12321)) != nil){
            viewMenu.viewWithTag(12321)?.removeFromSuperview()
            viewMenu.viewWithTag(12345)?.removeFromSuperview()
            viewMenu.viewWithTag(123456)?.removeFromSuperview()
        }
        
        viewMenu.addSubview(lblFoodTalk)
        viewMenu.addSubview(lblPrevilege)
        viewMenu.addSubview(lblSaved)
    }
    
    func setCollectionView(){
        
        if(UIScreen.main.bounds.size.height > 670){
            self.collectionView.frame = CGRect(x: 20, y: 25, width: self.view.frame.size.width - 40,height: (viewBase?.frame.size.height)!)
        }
        else if(UIScreen.main.bounds.size.height < 500){
            if(loginAs == "guest"){
            self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)!)
            }
            else{
              self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)!)
            }
        }
        else if(UIScreen.main.bounds.size.height < 570){
            if(loginAs == "guest"){
                self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)!)
            }
            else{
                self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)!)
            }
        }
        else{
            if(loginAs == "guest"){
            self.collectionView.frame = CGRect(x: 20, y: 15, width: self.view.frame.size.width - 40,height: (viewBase?.frame.size.height)!)
            }
            else{
              self.collectionView.frame = CGRect(x: 20, y: 15, width: self.view.frame.size.width - 40,height: (viewBase?.frame.size.height)!)
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
        // UICollectionReusableView
        
        viewBase?.addSubview(self.collectionView)
    }
    
    // MARK:- UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(loginAs == "user"){
            if(savingValue == "0"){
                let cell : PackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuse, for: indexPath) as! PackCollectionViewCell
                cell.backgroundColor = .white
                
                cell.lblMoney?.text = String(format : "\u{20B9} %@", (arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "cost") as! String)
                
                let imgCell = (arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "card_image") as! String
                cell.lblDistance?.layer.cornerRadius = 9.5
                cell.lblDistance?.layer.masksToBounds = false
                dropShadow(color: .darkGray, opacity: 1.0, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true, lbl: cell.lblDistance!)
                if(((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance")) != nil){
                    cell.lblDistance?.isHidden = false
                    var distance = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance") as! NSString).doubleValue
                    distance = distance / 1000
                    cell.lblDistance?.text = String(format : "%.1f KM", distance)
                }
                else{
                    cell.lblDistance?.isHidden = true
                }
                
                //      setImageWithUrl(imgCell, imgView: cell.packCellImage!)
                DispatchQueue.main.async{
                    
                    setImageWithUrl(imgCell, imgView: cell.packCellImage!)
                    
                }
                
                cell.lblRestaurant?.text = (arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
                
                let outletCount = (arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "primary_cuisine") as? String
                
                
                cell.lblLocation?.text = outletCount
                
                let amount = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "cost") as! NSString).intValue
                if(amount < 500){
                    cell.lblMoney?.text = String(format : "%@", "\u{20B9}")
                }
                else if(amount < 999){
                    cell.lblMoney?.text = String(format : "%@%@", "\u{20B9}", "\u{20B9}")
                }
                else{
                    cell.lblMoney?.text = String(format : "%@%@%@", "\u{20B9}", "\u{20B9}", "\u{20B9}")
                }
                
                cell.layer.shadowColor = colorDarkGray.cgColor
                cell.layer.shadowOpacity = 0.2
                cell.layer.opacity = 1
                cell.layer.shadowOffset = CGSize(width: 0, height: 2)
                cell.layer.shadowRadius = 1
                
                return cell
            }
            else{
        if(indexPath.row == 0){
            let cell : SavingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellSavingReuse, for: indexPath) as! SavingCollectionViewCell
            cell.backgroundColor = colorDarkGray
            cell.lblSavingAmount?.text = String(format : "You have saved \u{20B9} %@", savingValue)
            return cell
        }
        else{
        let cell : PackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuse, for: indexPath) as! PackCollectionViewCell
        cell.backgroundColor = .white
        
        cell.lblMoney?.text = String(format : "\u{20B9} %@", (arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "cost") as! String)
        cell.lblDistance?.layer.cornerRadius = 9.5
            cell.lblDistance?.layer.masksToBounds = false
            dropShadow(color: .darkGray, opacity: 1.0, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true, lbl: cell.lblDistance!)
        let imgCell = (arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "card_image") as! String
            
            if(((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "distance")) != nil){
                cell.lblDistance?.isHidden = false
                
                var distance = ((arrCards.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "distance") as! NSString).doubleValue
                distance = distance / 1000
                cell.lblDistance?.text = String(format : "%.1f KM", distance)
            }
            else{
                cell.lblDistance?.isHidden = true
            }
            
  //      setImageWithUrl(imgCell, imgView: cell.packCellImage!)
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
        
        cell.layer.shadowColor = colorDarkGray.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.opacity = 1
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 1
        
        return cell
        }
            }
        }
        else{
            let cell : PackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuse, for: indexPath) as! PackCollectionViewCell
            cell.backgroundColor = .white
            
            cell.lblMoney?.text = String(format : "\u{20B9} %@", (arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "cost") as! String)
            
            let imgCell = (arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "card_image") as! String
            //      setImageWithUrl(imgCell, imgView: cell.packCellImage!)
            DispatchQueue.main.async{
                
                setImageWithUrl(imgCell, imgView: cell.packCellImage!)
                
            }
            cell.lblDistance?.layer.cornerRadius = 9.5
            cell.lblDistance?.layer.masksToBounds = false
            dropShadow(color: .darkGray, opacity: 1.0, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true, lbl: cell.lblDistance!)
            if(((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance")) != nil){
                cell.lblDistance?.isHidden = false
                var distance = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance") as! NSString).doubleValue
                distance = distance / 1000
                cell.lblDistance?.text = String(format : "%.1f KM", distance)
            }
            else{
                cell.lblDistance?.isHidden = true
            }
            
            cell.lblRestaurant?.text = (arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
            
            let outletCount = (arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "primary_cuisine") as? String
            
            
            cell.lblLocation?.text = outletCount
            
            let amount = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "cost") as! NSString).intValue
            if(amount < 500){
                cell.lblMoney?.text = String(format : "%@", "\u{20B9}")
            }
            else if(amount < 999){
                cell.lblMoney?.text = String(format : "%@%@", "\u{20B9}", "\u{20B9}")
            }
            else{
                cell.lblMoney?.text = String(format : "%@%@%@", "\u{20B9}", "\u{20B9}", "\u{20B9}")
            }
            
            cell.layer.shadowColor = colorDarkGray.cgColor
            cell.layer.shadowOpacity = 0.2
            cell.layer.opacity = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 1
            
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1  // Number of section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(loginAs == "guest"){
           return arrCards.count
        }
        if(savingValue == "0"){
           return arrCards.count
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
            if(loginAs == "user"){
                if(indexPath.row == 0){
                    if(savingValue == "0"){
                        return CGSize(width: 170, height: 220);
                    }
                    return CGSize(width: self.view.frame.size.width - 20, height: 80);
                }
                else{
                    return CGSize(width: 170, height: 220);
                }
            }
            return CGSize(width: 170, height: 220)
        }
        else if(UIScreen.main.bounds.size.height < 570){
            if(loginAs == "user"){
                if(indexPath.row == 0){
                    if(savingValue == "0"){
                        return CGSize(width: 140, height: 190);
                    }
                    return CGSize(width: self.view.frame.size.width - 20, height: 80);
                }
                else{
                    return CGSize(width: 140, height: 190);
                }
            }
            return CGSize(width: 140, height: 190);
        }
        else{
            if(loginAs == "user"){
                if(indexPath.row == 0){
                    if(savingValue == "0"){
                      return CGSize(width: 160, height: 210);  
                    }
                  return CGSize(width: self.view.frame.size.width - 20, height: 80);
                }
                else{
                   return CGSize(width: 160, height: 210);
                }
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
        
        if(isMoreTapped == false){
            
            var outletCount : Int = 0
            var offerCount : Int = 0
            if(loginAs == "user"){
                if(savingValue == "0"){
                    restaurantDetails = arrCards.object(at: indexPath.row) as! NSDictionary
                    restaurantId = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "rid") as? String)!
                    strOneLiner = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "one_liner") as? String)!
                    restaurantName = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String)!
                    outletCount =  Int(Int32((((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "outlet_count") as? NSString)?.intValue)!))
                    
                    offerCount = Int(Int32((((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "offer_count") as? NSString)?.intValue)!))
                    
                    if(outletCount > 1){
                        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOutlet") as! SelectOutletViewController;
                        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                    }
                    else if(offerCount > 1){
                        strAddress = ""
                        outletId = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "outlet_ids") as? String)!
                        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOffer") as! SelectOfferViewController;
                        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                    }
                    else{
                        outletId = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "outlet_ids") as? String)!
                        offerIds = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "offer_ids") as? String)!
                        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "StoreDetails") as! StoreDetailsViewController;
                        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                    }
                }
                else{
                    if(indexPath.row != 0){
                    restaurantDetails = arrCards.object(at: indexPath.row-1) as! NSDictionary
                    restaurantId = ((arrCards.object(at: indexPath.row-1) as! NSDictionary).object(forKey: "rid") as? String)!
                    strOneLiner = ((arrCards.object(at: indexPath.row-1) as! NSDictionary).object(forKey: "one_liner") as? String)!
                    restaurantName = ((arrCards.object(at: indexPath.row-1) as! NSDictionary).object(forKey: "name") as? String)!
                    outletCount =  Int(Int32((((arrCards.object(at: indexPath.row-1) as! NSDictionary).object(forKey: "outlet_count") as? NSString)?.intValue)!))
                    
                    offerCount = Int(Int32((((arrCards.object(at: indexPath.row-1) as! NSDictionary).object(forKey: "offer_count") as? NSString)?.intValue)!))
                        
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
                            outletId = ((arrCards.object(at: indexPath.row-1) as! NSDictionary).object(forKey: "outlet_ids") as? String)!
                            offerIds = ((arrCards.object(at: indexPath.row-1) as! NSDictionary).object(forKey: "offer_ids") as? String)!
                            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "StoreDetails") as! StoreDetailsViewController;
                            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                        }
                    }
                }
            }
            else{
        restaurantDetails = arrCards.object(at: indexPath.row) as! NSDictionary
        restaurantId = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "rid") as? String)!
        strOneLiner = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "one_liner") as? String)!
        restaurantName = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String)!
                outletCount =  Int(Int32((((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "outlet_count") as? NSString)?.intValue)!))
                
                offerCount = Int(Int32((((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "offer_count") as? NSString)?.intValue)!))
                
                if(outletCount > 1){
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOutlet") as! SelectOutletViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
                else if(offerCount > 1){
                    strAddress = ""
                    outletId = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "outlet_ids") as? String)!
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOffer") as! SelectOfferViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
                else{
                    outletId = ((arrCards.object(at: indexPath.row) as! NSDictionary).object(forKey: "outlet_ids") as? String)!
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
    
    //MARK:- TableViewDelegates and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(loginAs == "guest"){
            return 11
        }
        else{
            return 13
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
         if (cell == nil) {
           cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
           }
        cell?.selectionStyle = .none
        cell?.backgroundColor = .clear
        if(loginAs == "guest"){
           if((indexPath.row == 3) || (indexPath.row == 7)){
            
           }
           else{
             addSubViewOnCell(cell!, indexPath: indexPath)
           }
        }
        else{
            if((indexPath.row == 4) || (indexPath.row == 8) || (indexPath.row == 11)){
                
            }
            else{
                addSubViewOnCell(cell!, indexPath: indexPath)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(loginAs == "guest"){
            if(indexPath.row == 0){
                viewMenu.removeFromSuperview()
                tblMenu.removeFromSuperview()
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "LoginNumber") as! LoginNumberViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 1){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "BuySignup") as! BuySignupViewController;
                self.navigationController!.pushViewController(openPost, animated: true)
            }
            else if(indexPath.row == 2){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "BuySignup") as! BuySignupViewController;
                self.navigationController!.pushViewController(openPost, animated: true)
            }
            else if(indexPath.row == 4){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "HowItWork") as! HowItWorkViewController;
                self.navigationController!.pushViewController(openPost, animated: true)
            }
            else if(indexPath.row == 5){
                selectedWebType = "faq"
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Web") as! WebViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 6){
                selectedWebType = "legal"
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Web") as! WebViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 8){
                contactUs()
            }
        }
        else{
            if(indexPath.row == 0){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Account") as! AccountViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 1){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "History") as! HistoryViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 2){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Favourites") as! FavouritesViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 3){
                selectedWebType = "exp"
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Web") as! WebViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 5){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "HowItWork") as! HowItWorkViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 6){
                selectedWebType = "faq"
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Web") as! WebViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 7){
                selectedWebType = "legal"
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Web") as! WebViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(indexPath.row == 9){
                FBSDKAppEvents.logEvent("contact_us_view")
                contactUs()
            }
            else if(indexPath.row == 10){
                showAlert()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
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
        if(loginAs == "guest"){
        if(indexPath.row == 0){
            imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 17, height : 22)
            imgViewIcon.image = UIImage(named : "fill131.png")
            
            lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
            lblValue.text = "LOGIN"
            lblValue.textColor = .white
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
        }
        else if(indexPath.row == 1){
            imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 22.8, height : 22)
            imgViewIcon.image = UIImage(named : "fill7.png")
            
            lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
            lblValue.text = "BUY NOW"
            lblValue.textColor = .white
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
        }
        else if(indexPath.row == 2){
            imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 22.8, height : 22)
            imgViewIcon.image = UIImage(named : "exp.png")
            
            lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
            lblValue.text = "EXPERIENCES"
            lblValue.textColor = .white
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
        }
        else if(indexPath.row == 4){
            imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 17.7, height : 22)
            imgViewIcon.image = UIImage(named : "fill86.png")
            
            lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
            lblValue.text = "HOW IT WORKS"
            lblValue.textColor = .white
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
        }
        else if(indexPath.row == 5){
            imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 17.7, height : 22)
            imgViewIcon.image = UIImage(named : "fill41.png")
            
            lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
            lblValue.text = "FAQ"
            lblValue.textColor = .white
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
        }
        else if(indexPath.row == 6){
            imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 19.6, height : 22)
            imgViewIcon.image = UIImage(named : "fill3.png")
            
            lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
            lblValue.text = "LEGAL"
            lblValue.textColor = .white
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
        }
        else if(indexPath.row == 8){
            imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 21.6, height : 22)
            imgViewIcon.image = UIImage(named : "fill76.png")
            
            lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
            lblValue.text = "CONTACT US"
            lblValue.textColor = .white
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
        }
        else if(indexPath.row == 10){
            imgViewIcon.frame = CGRect(x: 0, y: 0, width: 0, height : 0)
            
            lblValue.frame = CGRect(x: 46, y: 0, width: 200, height: 44)
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                lblValue.text = String(format : "version : %@", version)
            }
            
            lblValue.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
            lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
        }
        else{
            if(indexPath.row == 0){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 22, height : 22)
                imgViewIcon.image = UIImage(named : "fill9.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "PROFILE"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            else if(indexPath.row == 1){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 21, height : 21)
                imgViewIcon.image = UIImage(named : "history.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "HISTORY"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            else if(indexPath.row == 2){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 16.1, height : 22)
                imgViewIcon.image = UIImage(named : "fav.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "FAVOURITES"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            else if(indexPath.row == 3){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 16.1, height : 22)
                imgViewIcon.image = UIImage(named : "exp.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "EXPERIENCES"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            else if(indexPath.row == 5){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 17.7, height : 22)
                imgViewIcon.image = UIImage(named : "fill86.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "HOW IT WORKS"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            else if(indexPath.row == 6){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 17.7, height : 22)
                imgViewIcon.image = UIImage(named : "fill41.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "FAQ"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            else if(indexPath.row == 7){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 19.6, height : 22)
                imgViewIcon.image = UIImage(named : "fill3.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "LEGAL"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            else if(indexPath.row == 9){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 21.6, height : 22)
                imgViewIcon.image = UIImage(named : "fill76.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "CONTACT US"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            else if(indexPath.row == 10){
                imgViewIcon.frame = CGRect(x: 46, y: 45/2 - 11, width: 21.6, height : 22)
                imgViewIcon.image = UIImage(named : "fill131.png")
                
                lblValue.frame = CGRect(x: 94, y: imgViewIcon.frame.origin.y, width: 170, height: 22)
                lblValue.text = "LOGOUT"
                lblValue.textColor = .white
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
            else if(indexPath.row == 12){
                imgViewIcon.frame = CGRect(x: 0, y: 0, width: 0, height : 0)
                
                lblValue.frame = CGRect(x: 46, y: 0, width: 200, height: 30)
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    lblValue.text = String(format : "Version : %@", version)
                }
                lblValue.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
                lblValue.font = UIFont.boldSystemFont(ofSize: 17)
            }
        }
        
        let templateImage = imgViewIcon.image?.withRenderingMode(.alwaysTemplate)
        imgViewIcon.image = templateImage
        imgViewIcon.tintColor = colorLightGold
        
        imgViewIcon.tag = 22
        lblValue.tag = 29
        
        if((cell.contentView.viewWithTag(22)) != nil){
            cell.contentView.viewWithTag(22)?.removeFromSuperview()
            cell.contentView.viewWithTag(29)?.removeFromSuperview()
        }
        
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
            self.viewBuy.frame = CGRect(x: self.view.frame.size.width/2 + 100, y: (self.viewNavigate?.frame.size.height)!, width: self.view.frame.size.width, height: 50)
            self.viewNavigate?.frame = CGRect(x: self.view.frame.size.width/2 + 100, y: (self.viewNavigate?.frame.origin.y)!, width: (self.viewNavigate?.frame.size.width)!, height: (self.viewNavigate?.frame.size.height)!)
            self.viewBase?.frame = CGRect(x: self.view.frame.size.width/2 + 100, y: (self.viewBase?.frame.origin.y)!, width: (self.viewBase?.frame.size.width)!, height: (self.viewBase?.frame.size.height)!)
            self.viewBottom.frame = CGRect(x: self.view.frame.size.width/2 + 100, y: (self.viewBottom.frame.origin.y), width: (self.viewBottom.frame.size.width), height: (self.viewBottom.frame.size.height))
        })
            isMoreTapped = true
        }
        else{
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.viewMenu.frame = CGRect(x: -(self.view.frame.size.width/2 + 110), y: 0, width: self.view.frame.size.width/2 + 100, height: self.view.frame.size.height)
                self.viewBuy.frame = CGRect(x: 0, y: (self.viewNavigate?.frame.size.height)!, width: self.view.frame.size.width, height: 50)
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
            let url = String(format: "%@%@", baseUrl,"offers")
            webServiceGet(url)
            delegate = self
        }
        else{
         stopAnimation()
         openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func callWebServiceForLocation(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@?latitude=%@&longitude=%@", baseUrl,"offers", latitude, longitude)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
 
    }
    
    func callWebNextUrl(){
     //   showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@", nextPageUrl)
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
            let url = String(format: "%@&latitude=%@&longitude=%@", nextPageUrl,latitude, longitude)
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
        let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
        let session = dictSessionId.object(forKey: "session_id") as! String
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@%@", baseUrl,"profile?sessionid=", session)
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
    }
    
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        
        stopAnimation()
        if((dict.object(forKey: "api") as! String).contains("profile?")){
            savingValue = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "saving") as! String
        }
        else if((dict.object(forKey: "api") as! String).contains("offers")){
        if(dict.object(forKey: "status") as! String == "OK"){
            let arr = ((dict.object(forKey: "result") as! NSDictionary).object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
            for index in 0..<arr.count{
                arrCards.add(arr.object(at: index) as! NSDictionary)
                let imgView = UIImageView()
                let imgCell = (arr.object(at: index) as! NSDictionary).object(forKey: "card_image") as! String
                setImageWithUrl(imgCell, imgView: imgView)
            }
            nextPageUrl = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "next_page_url") as! String
        }
        }
        
        collectionView.reloadData()
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
    
    //MARK:- scrollview delegate
    
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//            if(isMoreTapped == false){
//            if(nextPageUrl.characters.count > 0){
//             //   callWebNextUrl()
//                if CLLocationManager.locationServicesEnabled() {
//                    switch(CLLocationManager.authorizationStatus()) {
//                    case .notDetermined, .restricted, .denied:
//                        DispatchQueue.main.async{
//                            self.callWebNextUrl()
//                        }
//    
//                    case .authorizedAlways, .authorizedWhenInUse:
//                        viewBottom.isHidden = true
//                        locationManager.startUpdatingLocation()
//                        DispatchQueue.main.async{
//                            self.callWebNextLocationUrl()
//                        }
//    
//                    }
//                    
//                } else {
//                    DispatchQueue.main.async{
//                     self.callWebNextUrl()
//                    }
//                }
//            }
//            }
//    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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
