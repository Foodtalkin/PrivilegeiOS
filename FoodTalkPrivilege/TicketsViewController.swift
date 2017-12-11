//
//  TicketsViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 08/11/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class TicketsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WebServiceCallingDelegate {
    
    @IBOutlet var tblTickets : UITableView?
    
    var arrTickets = NSMutableArray()
    
    var viewEmpty = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblTickets!.register(UINib(nibName: "TicketsTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketsTableViewCell")
        
        tblTickets?.tableFooterView = UIView()
        
        self.title = "PURCHASES"
        DispatchQueue.main.async{
        self.callWebServiceHistory()
        }
        
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [ NSFontAttributeName: UIFont(name: fontAbril, size: 18)!, NSForegroundColorAttributeName: colorLightGold]
        
        
        var backImage: UIImage = UIImage(named: "fill301.png")!
        backImage = backImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        
        setEmptyCredentials()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func back(_ sender : UIButton){
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
    }
    
    func setEmptyCredentials(){
        viewEmpty.frame = CGRect(x: 0, y: self.view.frame.size.height/2 - 75, width: self.view.frame.size.width, height: 150)
        viewEmpty.isUserInteractionEnabled = true
        let img = UIImageView(frame : CGRect(x: viewEmpty.frame.size.width/2 - 44, y: 5, width: 87, height: 77))
        img.image = UIImage(named: "ticketBlack.png")
        viewEmpty.addSubview(img)
        let lblText = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100,y: 82, width: 200, height: 40))
        lblText.text = "Your tickets will be listed here"
        lblText.numberOfLines = 0
        lblText.textAlignment = .center
        lblText.font = UIFont(name : fontFuturaBold, size : 15)
        viewEmpty.addSubview(lblText)
        
        self.view.addSubview(viewEmpty)
        viewEmpty.isHidden = true
    }
    
    //MARK:- tableview datasource and delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketsTableViewCell", for: indexPath) as! TicketsTableViewCell
        cell.selectionStyle = .none
        
        cell.lblTitle?.text = (arrTickets.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String
        cell.lblAddress?.text = (arrTickets.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as! String
     //   cell.lblDate?.text = (arrTickets.object(at: indexPath.row) as! NSDictionary).object(forKey: "display_time") as! String
        
        let str = (arrTickets.object(at: indexPath.row) as! NSDictionary).object(forKey: "display_time") as! String
        
        if let range = str.range(of: "\n") {
            let startPos = str.distance(from: (str.startIndex), to: range.lowerBound)
            let myMutableString = NSMutableAttributedString(string: str, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:startPos,length: (str.characters.count) - startPos))
            
            myMutableString.addAttribute(NSFontAttributeName, value : UIFont.systemFont(ofSize: 10), range: NSRange(location:startPos,length: (str.characters.count) - startPos))
            
            cell.lblDate?.attributedText = myMutableString
        }
        else {
         //   print("String not present")
            cell.lblDate?.text = (arrTickets.object(at: indexPath.row) as! NSDictionary).object(forKey: "display_time") as! String
        }
        
        cell.lblNumberTickets?.text = String(format : "%@ Tickets", (arrTickets.object(at: indexPath.row) as! NSDictionary).object(forKey: "total_tickets") as! String)
        cell.lblTransactionId?.text = (arrTickets.object(at: indexPath.row) as! NSDictionary).object(forKey: "txn_id") as! String
        
        cell.btnEvent?.tag = Int((arrTickets.object(at: indexPath.row) as! NSDictionary).object(forKey: "exp_id") as! String)!
            
        cell.btnEvent?.addTarget(self, action: #selector(TicketsViewController.openEventDetails(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158
    }
    
    func openEventDetails(_ sender : UIButton){
        idExperience = String(format : "%d", sender.tag)
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "ExperienceDetails") as! ExperienceDetailsViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    //MARK:- webServiceCalling
    
    func callWebServiceHistory(){
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@%@sessionid=%@", baseUrl,"experiences/", "history?", session)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(TicketsViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        
        if((dict.object(forKey: "api") as! String).contains("history")){
        if(dict.object(forKey: "status") as! String == "OK"){
            arrTickets = (dict.object(forKey: "result") as! NSArray).mutableCopy() as! NSMutableArray
        }
        if(arrTickets.count > 0){
           viewEmpty.isHidden = true
        }
        else{
            viewEmpty.isHidden = false
        }
        }
        tblTickets?.reloadData()
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation(view: self.view)
        self.view.isUserInteractionEnabled = true
        UserDefaults.standard.setValue(nil, forKey: "userDetails")
        UserDefaults.standard.setValue(nil, forKey: "session")
        UserDefaults.standard.setValue(nil, forKey: "expiry")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func alertTap(_ sender : UIButton){
        callWebServiceHistory()
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
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
