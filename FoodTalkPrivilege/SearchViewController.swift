//
//  SearchViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 10/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import FBSDKCoreKit

var arrFilteredData = NSMutableArray()
var filterText = ""
var nextUrlFilter = ""
var previousUrlFilter = ""
var selectedFilterUrl = ""

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, WebServiceCallingDelegate {
    
    @IBOutlet var tblFilter : UITableView?
    @IBOutlet var viewTop : UIView?
    @IBOutlet var searchBar : UISearchBar?
    var tblSearch = UITableView()
    var filtered:NSMutableArray = []
    var myTimer : Timer?
    
    var cityZone = ""
    var cusine = ""
    var cost = ""
    var offer_types = ""
    
    var arrCity = NSMutableArray()
    var arrCusine = NSMutableArray()
    var arrCost = NSMutableArray()
    
    var arrCusinesValues = NSMutableArray()
    var arrOfferTypes = NSMutableArray()
    var arrOffer = NSMutableArray()
    var arrString = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        offer_types = ""
        selectedFilterUrl = ""
        tblFilter!.register(UINib(nibName: "FilterLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterLocation")
        tblFilter!.register(UINib(nibName: "FilterCostTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterCost")
        tblFilter!.register(UINib(nibName: "FilterCousinTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterCousin")
        tblFilter!.register(UINib(nibName: "OfferTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "OfferType")
        
        tblFilter?.backgroundColor = colorPaleGray
        self.view.backgroundColor = colorPaleGray
        
        createSearchTable()
        searchBar?.showsCancelButton = true
        
        webServiceCallingCousines()
        webServiceForOffertype()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filterText = ""
        searchBar?.text = ""
        filtered = []
        tblSearch.reloadData()
    }
    
    func createSearchTable(){
        tblSearch.frame = CGRect(x: 0, y: -(self.view.frame.size.height), width : self.view.frame.size.width, height : self.view.frame.size.height)
        tblSearch.dataSource = self
        tblSearch.delegate = self
        self.view.addSubview(tblSearch)
        self.view.bringSubview(toFront: viewTop!)
        
        tblSearch.layer.borderWidth = 0
        tblSearch.layer.borderColor = colorDarkGray.cgColor
    }
    
    //MARK:- tableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblFilter){
            return 4
        }
        else{
            if(filtered.count > 0){
                return filtered.count
            }
            else{
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tblFilter){
        if(indexPath.row == 0){
           let cell = tableView.dequeueReusableCell(withIdentifier: "FilterLocation", for: indexPath) as! FilterLocationTableViewCell
            cell.selectionStyle = .none
            createCircleButton(cell.btnEastDelhi!)
            createCircleButton(cell.btnNoida!)
            createCircleButton(cell.btnGurgaon!)
            createCircleButton(cell.btnNorthDelhi!)
            createCircleButton(cell.btnSouthDelhi!)
            createCircleButton(cell.btnCentralDelhi!)
            createCircleButton(cell.btnWestDelhi!)
            
            cell.btnCentralDelhi?.addTarget(self, action: #selector(SearchViewController.selectFilterLocation(_:)), for: .touchUpInside)
            cell.btnGurgaon?.addTarget(self, action: #selector(SearchViewController.selectFilterLocation(_:)), for: .touchUpInside)
            cell.btnNoida?.addTarget(self, action: #selector(SearchViewController.selectFilterLocation(_:)), for: .touchUpInside)
            cell.btnSouthDelhi?.addTarget(self, action: #selector(SearchViewController.selectFilterLocation(_:)), for: .touchUpInside)
            cell.btnNorthDelhi?.addTarget(self, action: #selector(SearchViewController.selectFilterLocation(_:)), for: .touchUpInside)
            cell.btnWestDelhi?.addTarget(self, action: #selector(SearchViewController.selectFilterLocation(_:)), for: .touchUpInside)
            cell.btnEastDelhi?.addTarget(self, action: #selector(SearchViewController.selectFilterLocation(_:)), for: .touchUpInside)
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapLocation(_:)))
            let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapLocation(_:)))
            let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapLocation(_:)))
            let gestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapLocation(_:)))
            let gestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapLocation(_:)))
            let gestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapLocation(_:)))
            let gestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapLocation(_:)))
            cell.lblEastDelhi?.addGestureRecognizer(gestureRecognizer)
            cell.lblNoida?.addGestureRecognizer(gestureRecognizer1)
            cell.lblGurgaon?.addGestureRecognizer(gestureRecognizer2)
            cell.lblNorthDelhi?.addGestureRecognizer(gestureRecognizer3)
            cell.lblSouthDelhi?.addGestureRecognizer(gestureRecognizer4)
            cell.lblCentralDelhi?.addGestureRecognizer(gestureRecognizer5)
            cell.lblWestDelhi?.addGestureRecognizer(gestureRecognizer6)
            
            return cell
        }
        else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCost", for: indexPath) as! FilterCostTableViewCell
            cell.selectionStyle = .none
            createCircleButton(cell.btnBudget!)
            createCircleButton(cell.btnSuplre!)
            createCircleButton(cell.btnMidRange!)
            
            cell.btnSuplre?.addTarget(self, action: #selector(SearchViewController.selectFilterCost(_:)), for: .touchUpInside)
            cell.btnMidRange?.addTarget(self, action: #selector(SearchViewController.selectFilterCost(_:)), for: .touchUpInside)
            cell.btnBudget?.addTarget(self, action: #selector(SearchViewController.selectFilterCost(_:)), for: .touchUpInside)
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapCost(_:)))
            let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapCost(_:)))
            let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapCost(_:)))
            cell.lblBudget?.addGestureRecognizer(gestureRecognizer)
            cell.lblSuplre?.addGestureRecognizer(gestureRecognizer1)
            cell.lblMidRange?.addGestureRecognizer(gestureRecognizer2)
            
            return cell
        }
        else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferType", for: indexPath) as! OfferTypeTableViewCell
            cell.selectionStyle = .none
            
            for index in 0..<arrOfferTypes.count{
                let btnCousin = UIButton(frame : CGRect(x: 20, y: 30 + 27 * (index + 1), width: 15, height: 15))
                btnCousin.backgroundColor = UIColor(red: 138/255, green: 179/255, blue: 207/255, alpha: 1.0)
                btnCousin.addTarget(self, action: #selector(SearchViewController.selectOfferTypes(_:)), for: .touchUpInside)
                btnCousin.tag = Int((arrOfferTypes.object(at: index) as! NSDictionary).object(forKey: "id") as! String)!
                cell.contentView.addSubview(btnCousin)
                
                createCircleButton(btnCousin)
                
                let lblCousins = UILabel(frame : CGRect(x: 51, y: btnCousin.frame.origin.y + btnCousin.frame.size.height - 20, width: 200, height: 26))
                lblCousins.textColor = UIColor(red: 97/255, green: 127/255, blue: 148/255, alpha: 1.0)
                lblCousins.tag = btnCousin.tag
                lblCousins.font = UIFont.systemFont(ofSize: 14)
                lblCousins.text = (arrOfferTypes.object(at: index) as! NSDictionary).object(forKey: "title") as? String
                lblCousins.isUserInteractionEnabled = true
                cell.contentView.addSubview(lblCousins)
                
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapOfferType(_:)))
                
                lblCousins.addGestureRecognizer(gestureRecognizer)
                
            }
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCousin", for: indexPath) as! FilterCousinTableViewCell
            cell.selectionStyle = .none
            for index in 0..<arrCusinesValues.count{
            let btnCousin = UIButton(frame : CGRect(x: 20, y: 30 + 27 * (index + 1), width: 15, height: 15))
            btnCousin.backgroundColor = UIColor(red: 138/255, green: 179/255, blue: 207/255, alpha: 1.0)
            btnCousin.addTarget(self, action: #selector(SearchViewController.selectFilterCusine(_:)), for: .touchUpInside)
            btnCousin.tag = Int((arrCusinesValues.object(at: index) as! NSDictionary).object(forKey: "id") as! String)!
            cell.contentView.addSubview(btnCousin)
            
            createCircleButton(btnCousin)
            
            let lblCousins = UILabel(frame : CGRect(x: 51, y: btnCousin.frame.origin.y + btnCousin.frame.size.height - 20, width: 200, height: 26))
            lblCousins.textColor = UIColor(red: 97/255, green: 127/255, blue: 148/255, alpha: 1.0)
            lblCousins.tag = btnCousin.tag
            lblCousins.font = UIFont.systemFont(ofSize: 14)
            lblCousins.text = (arrCusinesValues.object(at: index) as! NSDictionary).object(forKey: "title") as? String
             lblCousins.isUserInteractionEnabled = true
            cell.contentView.addSubview(lblCousins)
                
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTapCousin(_:)))
            
            lblCousins.addGestureRecognizer(gestureRecognizer)
           
            }
            return cell
        }
        }
        else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
            if (cell == nil) {
                cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
            }
            cell?.selectionStyle = .none
            
            let lblRestaurant = UILabel(frame : CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height : 20))
            lblRestaurant.textColor = colorDarkGray
            lblRestaurant.font = UIFont.boldSystemFont(ofSize: 16)
            lblRestaurant.tag = 1002
          //  cell?.contentView.addSubview(lblRestaurant)
            
            let lblOffers = UILabel(frame : CGRect(x: 10, y: 30, width: self.view.frame.size.width - 20, height : 15))
            lblOffers.textColor = colorBattleShipGray
            lblOffers.font = UIFont.systemFont(ofSize: 12)
            lblOffers.tag = 1003
        //    cell?.contentView.addSubview(lblOffers)
            
            if(filtered.count > 0){
                
                lblRestaurant.text = ((filtered.object(at: indexPath.row) as! NSDictionary).object(forKey: "_source") as! NSDictionary).object(forKey: "name") as! String
                let amount = (((filtered.object(at: indexPath.row) as! NSDictionary).object(forKey: "_source") as! NSDictionary).object(forKey: "cost") as! NSString).intValue
                if(amount < 500){
                    lblOffers.text = String(format : "%@", "\u{20B9}")
                }
                else if(amount < 999){
                    lblOffers.text = String(format : "%@%@", "\u{20B9}", "\u{20B9}")
                }
                else{
                    lblOffers.text = String(format : "%@%@%@", "\u{20B9}", "\u{20B9}", "\u{20B9}")
                }
            }
            else{
                if((searchBar?.text?.characters.count)! > 0){
                   lblRestaurant.text = "No result found"
                }
                else{
                   lblRestaurant.text = "Start typing.." 
                }
                
            }
            
            if((cell?.contentView.viewWithTag(1002)) != nil){
                cell?.contentView.viewWithTag(1002)?.removeFromSuperview()
                cell?.contentView.viewWithTag(1003)?.removeFromSuperview()
            }
            
            cell?.contentView.addSubview(lblRestaurant)
            cell?.contentView.addSubview(lblOffers)
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == tblSearch){
            restaurantName = ((filtered.object(at: indexPath.row) as! NSDictionary).object(forKey: "_source") as! NSDictionary).object(forKey: "name") as! String
            restaurantDetails = filtered.object(at: indexPath.row) as! NSDictionary
            restaurantId = ((filtered.object(at: indexPath.row) as! NSDictionary).object(forKey: "_source") as! NSDictionary).object(forKey: "rid") as! String
            strOneLiner = ((filtered.object(at: indexPath.row) as! NSDictionary).object(forKey: "_source") as! NSDictionary).object(forKey: "one_liner") as! String
            let outletCount = Int(((filtered.object(at: indexPath.row) as! NSDictionary).object(forKey: "_source") as! NSDictionary).object(forKey: "outlet_count") as! String)
            
            let offerCount = Int(((filtered.object(at: indexPath.row) as! NSDictionary).object(forKey: "_source") as! NSDictionary).object(forKey: "offer_count") as! String)
            
            if(outletCount! > 1){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOutlet") as! SelectOutletViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else if(offerCount! > 1){
                outletId = ((filtered.object(at: indexPath.row) as! NSDictionary).object(forKey: "_source") as! NSDictionary).object(forKey: "outlet_ids") as! String
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOffer") as! SelectOfferViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else{
                outletId = ((filtered.object(at: indexPath.row) as! NSDictionary).object(forKey: "_source") as! NSDictionary).object(forKey: "outlet_ids") as! String
                offerIds = ((filtered.object(at: indexPath.row) as! NSDictionary).object(forKey: "_source") as! NSDictionary).object(forKey: "offer_ids") as! String
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "StoreDetails") as! StoreDetailsViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
        }
        else if(tableView == tblFilter){
            if(indexPath.row == 0){
               
                
            }
            else if(indexPath.row == 1){
                
            }
            else{
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tblFilter){
        if(indexPath.row == 0){
            return 269
        }
        else if(indexPath.row == 1){
            return 147
        }
        else if(indexPath.row == 2){
            return CGFloat(60 + (arrOfferTypes.count * 27))
        }
        else if(indexPath.row == 3){
            return CGFloat(60 + (arrCusinesValues.count * 27))
        }
        else{
            return 44
        }
        }
        else{
            return 54
        }
    }
    
    //MARK:- searchBar delegates
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.tblSearch.frame = CGRect(x: 0, y: 64, width : self.view.frame.size.width, height : self.view.frame.size.height - 64)
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //    searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseOut, animations: {
                self.tblSearch.frame = CGRect(x: 0, y: -(self.view.frame.size.height), width : self.view.frame.size.width, height : self.view.frame.size.height)
            })
        filtered.removeAllObjects()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var str = NSString()
        str = searchBar.text! as NSString
        if(str.length > 0){
            self.filtered = []
            tblSearch.reloadData()
            
            if(searchBar.text != ""){
                
                if (myTimer != nil) {
                    if ((myTimer?.isValid) != nil)
                    {
                        myTimer!.invalidate();
                    }
                    myTimer = nil;
                }
                cancelRequest()
                myTimer = Timer.scheduledTimer(timeInterval: 0.10, target: self, selector: #selector(SearchViewController.webSearchService(_:)), userInfo: searchText, repeats: false)
            }
            else{
                cancelRequest()
                myTimer?.invalidate()
                self.filtered = []
                tblSearch.reloadData()
            }
        }
        else{
            cancelRequest()
            myTimer?.invalidate()
            self.filtered = []
            tblSearch.reloadData()
        }
        
        
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        
        viewAlert.removeFromSuperview()
    }
    
    //MARK:- webSearch
    
    func webSearchService(_ timer : Timer){
        let searchText = timer.userInfo as! String
        self.webServiceCallingSearch(searchText)
    }
    
    func webServiceCallingSearch(_ text : String){
      //  showActivityIndicator(view: self.view)
        if (isConnectedToNetwork()){
                let searchText = (text).lowercased()
                let url = String(format: "%@%@%@", baseUrl, "search/", searchText)
            FBSDKAppEvents.logEvent("search", parameters: ["search" : searchText])
                webServiceGet(url)
                
                delegate = self
                
            }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(SelectOutletViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func webServiceForOffertype(){
        if (isConnectedToNetwork()){
            let url = String(format: "%@%@", baseUrl, "offer_types")
            webServiceGet(url)
            delegate = self
            
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(SelectOutletViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func webServiceCallingCousines(){
        
        if (isConnectedToNetwork()){
            let url = String(format: "%@%@", baseUrl, "cuisine")
            
            webServiceGet(url)
            
            delegate = self
            
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(SelectOutletViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func webServiceCallingFilter(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork()){
            var url = ""
            if(cityZone != "" && cusine != "" && cost != "" && offer_types != ""){
             url = String(format: "%@%@city_zone_id=%@&cuisine=%@&cost=%@&type=%@", baseUrl, "offers?", cityZone, cusine, cost, offer_types)
            }
            else if(cityZone == "" && cusine != "" && cost != "" && offer_types != ""){
               url = String(format: "%@%@&cuisine=%@&cost=%@&type=%@", baseUrl, "offers?", cusine, cost, offer_types)
            }
            else if(cityZone != "" && cusine == "" && cost != "" && offer_types != ""){
               url = String(format: "%@%@city_zone_id=%@&cost=%@&type=%@", baseUrl, "offers?", cityZone,  cost, offer_types)
            }
            else if(cityZone != "" && cusine != "" && cost == "" && offer_types != ""){
                url = String(format: "%@%@city_zone_id=%@&cuisine=%@&type=%@", baseUrl, "offers?", cityZone, cusine, offer_types)
            }
            else if(cityZone != "" && cusine != "" && cost != "" && offer_types == ""){
                url = String(format: "%@%@city_zone_id=%@&cuisine=%@cost=%@", baseUrl, "offers?", cityZone, cusine, cost)
            }
            else if(cityZone != "" && cusine == "" && cost == "" && offer_types == ""){
                url = String(format: "%@%@city_zone_id=%@", baseUrl, "offers?", cityZone)
            }
            else if(cityZone == "" && cusine != "" && cost == "" && offer_types == ""){
                url = String(format: "%@%@cuisine=%@", baseUrl, "offers?",  cusine)
            }
            else if(cityZone == "" && cusine == "" && cost != "" && offer_types == ""){
                url = String(format: "%@%@cost=%@", baseUrl, "offers?", cost)
            }
            else if(cityZone == "" && cusine == "" && cost == "" && offer_types != ""){
                url = String(format: "%@%@type=%@", baseUrl, "offers?", offer_types)
            }
            else if(cityZone != "" && cusine != "" && cost == "" && offer_types == ""){
                url = String(format: "%@%@city_zone_id=%@&cuisine=%@", baseUrl, "offers?", cityZone, cusine)
            }
            else if(cityZone != "" && cusine == "" && cost != "" && offer_types == ""){
                url = String(format: "%@%@city_zone_id=%@&cost=%@", baseUrl, "offers?", cityZone, cost)
            }
            else if(cityZone != "" && cusine == "" && cost == "" && offer_types != ""){
                url = String(format: "%@%@city_zone_id=%@&type=%@", baseUrl, "offers?", cityZone, offer_types)
            }
            else if(cityZone == "" && cusine != "" && cost != "" && offer_types == ""){
                url = String(format: "%@%@cuisine=%@&cost=%@", baseUrl, "offers?", cusine, cost)
            }
            else if(cityZone == "" && cusine != "" && cost == "" && offer_types != ""){
                url = String(format: "%@%@cuisine=%@&type=%@", baseUrl, "offers?", cusine, offer_types)
            }
            else if(cityZone == "" && cusine == "" && cost != "" && offer_types != ""){
                url = String(format: "%@%@cost=%@&type=%@", baseUrl, "offers?", cost, offer_types)
            }
            let fullNameArr = url.components(separatedBy: "offers?")
            let surname = fullNameArr[1]
            selectedFilterUrl = surname
            
            webServiceGet(url)
            
            delegate = self
            
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(SearchViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict : NSMutableDictionary){
        
        stopAnimation()
        if((dict.object(forKey: "api") as! String).contains("search")){
            if(dict.object(forKey: "status") as! String == "OK"){
                filtered.removeAllObjects()
                let valuesArray = ((dict.object(forKey: "result") as! NSDictionary).object(forKey: "hits") as! NSArray).mutableCopy() as! NSMutableArray
                for index in 0..<valuesArray.count {
                    
                    filtered.add(valuesArray.object(at: index))
                }
                
                tblSearch.reloadData()
            }
        }
        else if((dict.object(forKey: "api") as! String).contains("/cuisine")){
            
         if(dict.object(forKey: "status") as! String == "OK"){
             arrCusinesValues = (dict.object(forKey: "result") as! NSArray).mutableCopy() as! NSMutableArray
             tblFilter?.reloadData()
         }
        }
        else if((dict.object(forKey: "api") as! String).contains("offer_types")){
           
            if(dict.object(forKey: "status") as! String == "OK"){
              arrOfferTypes = (dict.object(forKey: "result") as! NSArray).mutableCopy() as! NSMutableArray
              tblFilter?.reloadData()
            }
        }
        else{
            
        nextUrlFilter = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "next_page_url") as! String
           
        arrFilteredData = ((dict.object(forKey: "result") as! NSDictionary).object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "FilterResult") as! FilterResultViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:false);
        }
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation()
        self.view.isUserInteractionEnabled = true
//        var counter = UserDefaults.standard.value(forKey: "counterSessionExpire") as! Int
//        if(counter > 0){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            var ind = 0
            var isFind = false
            for vc in viewControllers{
                
                if(vc.isKind(of: ViewController.self)) {
                    UserDefaults.standard.setValue(nil, forKey: "userDetails")
                    UserDefaults.standard.setValue(nil, forKey: "session")
                    UserDefaults.standard.setValue(nil, forKey: "expiry")
                    
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
                    
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
            }
//            
//            counter = 0
//            UserDefaults.standard.set(counter, forKey: "counterSessionExpire")
//        }
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
    }

    
    //MARK:- makeButtonCircle
    
    func createCircleButton(_ sender : UIButton){
        sender.layer.cornerRadius = 7.5
        sender.layer.masksToBounds = true
    }
    
    func handleTapLocation(_ gestureRecognizer: UIGestureRecognizer) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = tblFilter?.cellForRow(at: indexPath) as! FilterLocationTableViewCell
        
        if(gestureRecognizer.view?.tag == 1){
            if(cell.btnGurgaon?.backgroundColor == colorSeeweed){
                arrString.remove((gestureRecognizer.view as! UILabel).text!)
            }
            else{
                arrString.add((gestureRecognizer.view as! UILabel).text!)
            }
            selectFilterLocation(cell.btnGurgaon!)
        }
        else if(gestureRecognizer.view?.tag == 2){
            if(cell.btnNoida?.backgroundColor == colorSeeweed){
                arrString.remove((gestureRecognizer.view as! UILabel).text!)
            }
            else{
                arrString.add((gestureRecognizer.view as! UILabel).text!)
            }
            selectFilterLocation(cell.btnNoida!)
            
        }
        else if(gestureRecognizer.view?.tag == 6){
            if(cell.btnWestDelhi?.backgroundColor == colorSeeweed){
                arrString.remove((gestureRecognizer.view as! UILabel).text!)
            }
            else{
                arrString.add((gestureRecognizer.view as! UILabel).text!)
            }
            selectFilterLocation(cell.btnWestDelhi!)
            
        }
        else if(gestureRecognizer.view?.tag == 3){
            if(cell.btnSouthDelhi?.backgroundColor == colorSeeweed){
                arrString.remove((gestureRecognizer.view as! UILabel).text!)
            }
            else{
                arrString.add((gestureRecognizer.view as! UILabel).text!)
            }
            selectFilterLocation(cell.btnSouthDelhi!)
            
        }
        else if(gestureRecognizer.view?.tag == 4){
            if(cell.btnNorthDelhi?.backgroundColor == colorSeeweed){
                arrString.remove((gestureRecognizer.view as! UILabel).text!)
            }
            else{
                arrString.add((gestureRecognizer.view as! UILabel).text!)
            }
            selectFilterLocation(cell.btnNorthDelhi!)
            
        }
        else if(gestureRecognizer.view?.tag == 5){
            if(cell.btnEastDelhi?.backgroundColor == colorSeeweed){
                arrString.remove((gestureRecognizer.view as! UILabel).text!)
            }
            else{
                arrString.add((gestureRecognizer.view as! UILabel).text!)
            }
            selectFilterLocation(cell.btnEastDelhi!)
            
        }
        else if(gestureRecognizer.view?.tag == 7){
            if(cell.btnCentralDelhi?.backgroundColor == colorSeeweed){
                arrString.remove((gestureRecognizer.view as! UILabel).text!)
            }
            else{
                arrString.add((gestureRecognizer.view as! UILabel).text!)
            }
            selectFilterLocation(cell.btnCentralDelhi!)
            
        }
        
    }
    
    func handleTapCost(_ gestureRecognizer: UIGestureRecognizer) {
        let indexPath = IndexPath.init(row: 1, section: 0)
        let cell = tblFilter?.cellForRow(at: indexPath) as! FilterCostTableViewCell
        if(gestureRecognizer.view?.tag == 0){
            if(cell.btnBudget?.backgroundColor == colorSeeweed){
                arrString.remove((gestureRecognizer.view as! UILabel).text!)
            }
            else{
                arrString.add((gestureRecognizer.view as! UILabel).text!)
            }
            selectFilterCost(cell.btnBudget!)
            
        }
        else if(gestureRecognizer.view?.tag == 1){
            if(cell.btnMidRange?.backgroundColor == colorSeeweed){
                arrString.remove((gestureRecognizer.view as! UILabel).text!)
            }
            else{
                arrString.add((gestureRecognizer.view as! UILabel).text!)
            }
            selectFilterCost(cell.btnMidRange!)
            
        }
        else if(gestureRecognizer.view?.tag == 2){
            if(cell.btnSuplre?.backgroundColor == colorSeeweed){
                arrString.remove((gestureRecognizer.view as! UILabel).text!)
            }
            else{
                arrString.add((gestureRecognizer.view as! UILabel).text!)
            }
            selectFilterCost(cell.btnSuplre!)
            
        }
      
    }
    
    func handleTapCousin(_ gestureRecognizer: UIGestureRecognizer) {
        let indexPath = IndexPath.init(row: 3, section: 0)
        let cell = tblFilter?.cellForRow(at: indexPath) as! FilterCousinTableViewCell
        
        let arr = cell.contentView.subviews as NSArray
        for index in 0..<arr.count{
            if(arr.object(at: index) is UIButton){
                let btn = arr.object(at: index) as! UIButton
                if(btn.tag == gestureRecognizer.view?.tag){
                    if(btn.backgroundColor == colorSeeweed){
                        arrString.remove((gestureRecognizer.view as! UILabel).text!)
                    }
                    else{
                        arrString.add((gestureRecognizer.view as! UILabel).text!)
                    }
                 selectFilterCusine(btn)
                    
                }
            }
        }
        
    }
    
    func handleTapOfferType(_ gestureRecognizer: UIGestureRecognizer){
        let indexPath = IndexPath.init(row: 2, section: 0)
        let cell = tblFilter?.cellForRow(at: indexPath) as! OfferTypeTableViewCell
        
        let arr = cell.contentView.subviews as NSArray
        for index in 0..<arr.count{
            if(arr.object(at: index) is UIButton){
                let btn = arr.object(at: index) as! UIButton
                if(btn.tag == gestureRecognizer.view?.tag){
                    if(btn.backgroundColor == colorSeeweed){
                        arrString.remove((gestureRecognizer.view as! UILabel).text!)
                    }
                    else{
                        arrString.add((gestureRecognizer.view as! UILabel).text!)
                    }
                    selectOfferTypes(btn)
                }
            }
        }
    }
    
    func selectFilterLocation(_ sender : UIButton){
        if(sender.backgroundColor == colorSeeweed){
            sender.backgroundColor = UIColor(red: 138/255, green: 179/255, blue: 207/255, alpha: 1.0)
            arrCity.remove(String(format : "%d", sender.tag))
        }
        else{
           sender.backgroundColor = colorSeeweed
            arrCity.add(String(format : "%d", sender.tag))
        }
        
    }
    
    func selectFilterCusine(_ sender : UIButton){
        if(sender.backgroundColor == colorSeeweed){
            sender.backgroundColor = UIColor(red: 138/255, green: 179/255, blue: 207/255, alpha: 1.0)
            arrCusine.remove(String(format : "%d", sender.tag))
        }
        else{
            sender.backgroundColor = colorSeeweed
            arrCusine.add(String(format : "%d", sender.tag))
        }
    }
    
    func selectOfferTypes(_ sender : UIButton){
        if(sender.backgroundColor == colorSeeweed){
            sender.backgroundColor = UIColor(red: 138/255, green: 179/255, blue: 207/255, alpha: 1.0)
            arrOffer.remove(String(format : "%d", sender.tag))
        }
        else{
            sender.backgroundColor = colorSeeweed
            arrOffer.add(String(format : "%d", sender.tag))
        }
    }
    
    func selectFilterCost(_ sender : UIButton){
        if(sender.backgroundColor == colorSeeweed){
            sender.backgroundColor = UIColor(red: 138/255, green: 179/255, blue: 207/255, alpha: 1.0)
            if(sender.tag == 0){
                arrCost.remove("budget")
            }
            else if(sender.tag == 1){
                arrCost.remove("mid")
            }
            else{
                arrCost.remove("splurge")
            }
        }
        else{
            sender.backgroundColor = colorSeeweed
            if(sender.tag == 0){
                arrCost.add("budget")
            }
            else if(sender.tag == 1){
                arrCost.add("mid")
            }
            else{
                arrCost.add("splurge")
            }
        }
        
    }
    
    @IBAction func setBack(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyFilter(_ sender : UIButton){
        if(arrCity.count > 0 || arrCost.count > 0 || arrCusine.count > 0 || arrOffer.count > 0){
        if(arrCity.count > 0){
            cityZone = arrCity.object(at: 0) as! String
            for index in 1..<arrCity.count{
                cityZone = String(format : "%@,%@", cityZone, (arrCity.object(at: index) as! String))
            }
        }
        else{
            cityZone = ""
            }
        if(arrCusine.count > 0){
            cusine = arrCusine.object(at: 0) as! String
            for index in 1..<arrCusine.count{
                cusine = String(format : "%@,%@", cusine, (arrCusine.object(at: index) as! String))
            }
        }
        else{
            cusine = ""
            }
        if(arrCost.count > 0){
            cost = arrCost.object(at: 0) as! String
            for index in 1..<arrCost.count{
                cost = String(format : "%@,%@", cost, (arrCost.object(at: index) as! String))
            }
        }
        else{
            cost = ""
            }
        if(arrOffer.count > 0){
           offer_types = arrOffer.object(at: 0) as! String
            for index in 1..<arrOffer.count{
                offer_types = String(format : "%@,%@", offer_types, (arrOffer.object(at: index) as! String))
            }
        }
        else{
            offer_types = ""
            }
            
        if(arrString.count == 1){
          filterText = arrString.object(at: 0) as! String
        }
        else if(arrString.count == 2){
            filterText = String(format : "%@,%@", arrString.object(at: 0) as! String, arrString.object(at: 1) as! String)
        }
        else if(arrString.count > 2){
            
           filterText = String(format : "%@,%@ + %d filters", arrString.object(at: 0) as! String, arrString.object(at: 1) as! String, arrString.count - 2)
        }
            
        webServiceCallingFilter()
        }
        else{
            self.view.makeToast("Please select some filter")
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
