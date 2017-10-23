//
//  FilterResultViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 15/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class FilterResultViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, WebServiceCallingDelegate {
    
    fileprivate let barSize : CGFloat = 44.0
    fileprivate let kCellReuse : String = "PackCell"
    fileprivate let kCellheaderReuse : String = "PackHeader"
    var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    @IBOutlet var viewBase : UIView?
    @IBOutlet var lblFilter : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(arrFilteredData.count > 0){
         self.setCollectionView()
        }
        else{
            problemArise = "filter"
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(FilterResultViewController.alertFav), for: .touchUpInside)
        }
        lblFilter?.text = String(format : "  Displaying: %@", filterText)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        let defaultColorLight = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        let defaultColorDark = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)
        
        gradient.colors = [defaultColorLight.cgColor, defaultColorDark.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func alertFav(){
        viewAlert.subviews.forEach({ $0.removeFromSuperview() })
        viewAlert.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }

    
    func setCollectionView(){
        if(UIScreen.main.bounds.size.height > 670){
            self.collectionView.frame = CGRect(x: 20, y: 5, width: self.view.frame.size.width - 40,height: (viewBase?.frame.size.height)! + 50)
        }
        else if(UIScreen.main.bounds.size.height < 500){
            self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)! - 200)
        }
        else if(UIScreen.main.bounds.size.height < 570){
            self.collectionView.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20,height: (viewBase?.frame.size.height)! - 100)
        }
        else{
          self.collectionView.frame = CGRect(x: 20, y: 2, width: self.view.frame.size.width - 40,height: (viewBase?.frame.size.height)! - 2)
        }
        self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(PackCollectionViewCell.self, forCellWithReuseIdentifier: kCellReuse) // UICollectionViewCell
        
        let nipName=UINib(nibName: "PackCollectionViewCell", bundle:nil)
        
        collectionView.register(nipName, forCellWithReuseIdentifier: "PackCell")
        // UICollectionReusableView
        
        viewBase?.addSubview(self.collectionView)
    }
    
    // MARK:- UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : PackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuse, for: indexPath) as! PackCollectionViewCell
        cell.backgroundColor = .white
        let imgCell = (arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "card_image") as! String
        setImageWithUrl(imgCell, imgView: cell.packCellImage!)
        
        cell.lblRestaurant?.text = (arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
        
       // cell.lblDistance?.isHidden = true
        
        if(((arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance")) != nil){
            cell.lblDistance?.isHidden = false
            var distance = ((arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance") as! NSString).doubleValue
            distance = distance / 1000
            cell.lblDistance?.text = String(format : "%.1f KM", distance)
        }
        else{
            cell.lblDistance?.isHidden = true
        }
        
        let outletCount = (arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "primary_cuisine") as? String
        

            cell.lblLocation?.text = outletCount
     
        let amount = ((arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "cost") as! NSString).intValue
        if(amount < 500){
            cell.lblMoney?.text = String(format : "%@", "\u{20B9}")
        }
        else if(amount < 1200){
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1  // Number of section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrFilteredData.count
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
            return CGSize(width: 170, height: 220)
        }
        else if(UIScreen.main.bounds.size.height < 570){
            return CGSize(width: 140, height: 190);
        }
        else{
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if(UIScreen.main.bounds.size.height > 670){
            return 18
        }
        else if(UIScreen.main.bounds.size.height < 570){
            return 5
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        strOneLiner = ((arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "one_liner") as? String)!
        restaurantName = ((arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String)!
        restaurantDetails = arrFilteredData.object(at: indexPath.row) as! NSDictionary
        restaurantId = ((arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "rid") as? String)!
        let outletCount = ((arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "outlet_count") as? NSString)?.intValue
        
        let offerCount = ((arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "offer_count") as? NSString)?.intValue
        
        if(outletCount! > 1){
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOutlet") as! SelectOutletViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
        else if(offerCount! > 1){
            outletId = ((arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "outlet_ids") as? String)!
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOffer") as! SelectOfferViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
        else{
            outletId = ((arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "outlet_ids") as? String)!
            offerIds = ((arrFilteredData.object(at: indexPath.row) as! NSDictionary).object(forKey: "offer_ids") as? String)!
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "StoreDetails") as! StoreDetailsViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }

    }
    
    //MARK:- scrollview delegate
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if(nextUrlFilter.characters.count > 0){
//            callWebNextUrl()
//        }
//    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(nextUrlFilter.characters.count > 0){
            callWebNextUrl()
        }
    }
    
    func callWebNextUrl(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            var url = ""
            
            url = String(format : "%@&%@", nextUrlFilter, selectedFilterUrl)
            if(latitude == ""){
                
            }
            else{
                url = String(format : "%@&latitude=%@&longitude=%@", url, latitude, longitude)
            }
            webServiceGet(url)
            delegate = self
        }
        else{
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict : NSMutableDictionary){
        stopAnimation(view: self.view)
        if(dict.object(forKey: "status") as! String == "OK"){
        nextUrlFilter = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "next_page_url") as! String
        let arr = ((dict.object(forKey: "result") as! NSDictionary).object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
        for index in 0..<arr.count{
            arrFilteredData.add(arr[index] as! NSDictionary)
        }
        collectionView.reloadData()
        }
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

    //MARK:- edit filter
    
    @IBAction func editFilter(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
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
