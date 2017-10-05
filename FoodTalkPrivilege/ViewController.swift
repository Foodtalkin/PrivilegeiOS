//
//  ViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 20/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

var loginAs = ""
var strOtp = ""
var dictUserDetails = NSDictionary()
var otpFrom = ""
//var counterSessionExpire = 0
//var isPaymentComplete : Bool = false

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var pageControl : UIPageControl?
    @IBOutlet var scrollView : UIScrollView?
    @IBOutlet var lblDetails : UILabel?
    @IBOutlet var viewDetails : UIView?
    @IBOutlet var lblAlready : UILabel?
    @IBOutlet var btnSignIn : UIButton?
    @IBOutlet var btnNext : UIButton?
    
    var btnEnter = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUp(viewDetails!)

    }
    
    func setUp(_ viewDeatils : UIView){
        viewDeatils.frame = CGRect(x: 0, y : self.view.frame.size.height - 145, width : self.view.frame.size.width, height : 145)
        lblDetails?.frame = CGRect(x: 20, y : 0, width : self.view.frame.size.width - 40, height : 90)
        pageControl?.frame = CGRect(x: 20, y: 80, width : 100, height : 37)
        lblAlready?.frame = CGRect(x: 20, y : 117, width : 160, height : 20)
        btnSignIn?.frame = CGRect(x: 170, y : 117, width : 80, height : 20)
        btnNext?.frame = CGRect(x: self.view.frame.size.width - 80, y : 117, width : 80, height : 20)
        btnSignIn?.titleLabel?.textAlignment = .left
    }
    
    
    func paymentCompletionCallBack() {
    //    isPaymentComplete = true
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "BuySignup") as! BuySignupViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureScrollView()
        configurePageControl()
        scrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Custom method implementation
    
    func configureScrollView() {
        // Enable paging.
        scrollView!.isPagingEnabled = true
        
        // Set the following flag values.
        scrollView!.showsHorizontalScrollIndicator = false
        scrollView!.showsVerticalScrollIndicator = false
        scrollView!.scrollsToTop = false
        self.automaticallyAdjustsScrollViewInsets = false;
        
        // Set the scrollview content size.
        //        scrollView!.contentSize = CGSizeMake(scrollView!.frame.size.width * CGFloat(totalPages), scrollView!.frame.size.height)
        scrollView!.contentSize = CGSize(width: scrollView!.frame.size.width * CGFloat(6),height: 0);
        
        // Set self as the delegate of the scrollview.
        scrollView!.delegate = self
        
        // Load the TestView view from the TestView.xib file and configure it properly.
        if(6 > 0){
            for i in 0..<6 {
                // Load the TestView view.
                let testView = UIView()
                
                // Set its frame and the background color.
                testView.frame = CGRect(x: CGFloat(i) * scrollView!.frame.size.width, y: 0, width: scrollView!.frame.size.width, height: scrollView!.frame.size.height - 145)
                createViewOnPage(testView: testView, i : i)
                // Add the test view as a subview to the scrollview.
                scrollView!.addSubview(testView)
            }
        }
        else{
            let testView = UIView()
            
            // Set its frame and the background color.
            testView.frame = CGRect(x: 0, y: 0, width: scrollView!.frame.size.width, height: scrollView!.frame.size.height - 145)
            //   placeHolder(testView: testView)
            // Add the test view as a subview to the scrollview.
            scrollView!.addSubview(testView)
        }
    }
    
    func createViewOnPage(testView : UIView, i : Int){
        
        if(i == 0){
            
        testView.frame.size.height = self.view.frame.size.height - 145
            let lblExclusive = UILabel()
            lblExclusive.frame = CGRect(x: 30, y : testView.frame.size.height/2 + 20, width : self.view.frame.size.width - 60, height : 50)
            lblExclusive.text = "An Exclusive Dining & Experiences Club"
            lblExclusive.numberOfLines = 0
            lblExclusive.textAlignment = .center
            lblExclusive.font = UIFont(name: "AmericanTypewriter", size: 17)
            lblExclusive.textColor = .white
            
            
            let imgBig = UIImageView(frame : CGRect(x: 0, y: 0, width : testView.frame.size.width, height : testView.frame.size.height))
         //   imgBig.contentMode = .scaleAspectFit
            if(UIScreen.main.bounds.size.height < 570){
             imgBig.image = UIImage(named : "landing.jpg")
            }
            else{
             imgBig.image = UIImage(named : "landing.jpg")
            }
            lblDetails?.text = "Swipe to know more"
            testView.addSubview(imgBig)
            imgBig.addSubview(lblExclusive)
        }
        else{
   //    lblExclusive.removeFromSuperview()
        testView.frame.size.height = self.view.frame.size.height - 170
        let lblHeader = UILabel(frame : CGRect(x: 0, y: 18, width : testView.frame.size.width, height: 24))
        lblHeader.textColor = .white
        lblHeader.font = UIFont(name : fontFuturaBold, size : 16)
        lblHeader.textAlignment = .center
        testView.addSubview(lblHeader)
        
            if(i == 2){
                if(UIScreen.main.bounds.size.height < 570){
                 testView.frame.size.height = self.view.frame.size.height - 225
                }
                else{
               testView.frame.size.height = self.view.frame.size.height - 190
                }
            }
        
        let img = UIImageView(frame : CGRect(x: 20, y: lblHeader.frame.origin.y + lblHeader.frame.size.height + 23, width: testView.frame.size.width - 40, height : testView.frame.size.height))
            
        testView.addSubview(img)
            
        img.contentMode = .scaleAspectFit
        
        if(i == 1){
         
            lblHeader.text = "Privilege Experiences"
            lblDetails?.text = "Book a seat at the most exciting events in the city, curated by Food Talk. Exclusively for Privilege members."
            img.image = UIImage(named : "screen2.png")
        }
        else if(i == 2){
         
            lblHeader.text = "Privilege Dining"
            lblDetails?.text = "Choose from six different deals. Unlock minimum six coupons per restaurant. Enjoy a year full of dining privileges."
            img.image = UIImage(named : "screen3.png")
        }
        else if(i == 3){
       
            lblHeader.text = "Browse Offers"
            lblDetails?.text = "Search for your favourite restaurants or discover a restaurant you haven’t tried before!"
            img.image = UIImage(named : "screen4.png")
        }
        else if(i == 4){
      
            lblHeader.text = "Redeem"
            lblDetails?.text = "Just ask your server to enter the unique PIN to redeem your offer."
            img.image = UIImage(named : "screen5.png")
        }
        else if(i == 5){
            testView.frame.size.height = self.view.frame.size.height - 250
            lblHeader.text = "Enter Privilege"
            lblDetails?.text = "Swipe to know more"
            let lblPrivilege = UILabel(frame : CGRect(x: 0, y: lblHeader.frame.origin.y + lblHeader.frame.size.height + 30, width: testView.frame.size.width, height : 20))
            lblPrivilege.text = "Privilege Membership"
            lblPrivilege.textAlignment = .center
            lblPrivilege.textColor = colorLightGold
            lblPrivilege.font = UIFont.boldSystemFont(ofSize: 14)
            testView.addSubview(lblPrivilege)
            
            let lblRupee = UILabel(frame : CGRect(x: 0, y: lblPrivilege.frame.origin.y + lblPrivilege.frame.size.height + 10, width: testView.frame.size.width, height : 20))
            lblRupee.textAlignment = .center
            lblRupee.text = String(format : "%@ 1200", "\u{20B9}")
            lblRupee.textColor = colorLightGold
            lblRupee.font = UIFont.boldSystemFont(ofSize: 28)
            testView.addSubview(lblRupee)
            
            let lblPeryear = UILabel(frame : CGRect(x: 0, y: lblRupee.frame.origin.y + lblRupee.frame.size.height + 10, width: testView.frame.size.width, height : 20))
            lblPeryear.textAlignment = .center
            lblPeryear.text = "Per Year"
            lblPeryear.textColor = colorLightGold
            lblPeryear.font = UIFont.boldSystemFont(ofSize: 14)
            testView.addSubview(lblPeryear)
            
            
            let lblText2 = UILabel(frame : CGRect(x: 30, y: (testView.frame.size.height - lblPeryear.frame.size.height)/2 + 70, width: testView.frame.size.width - 60, height : 20))
            lblText2.textAlignment = .center
            lblText2.text = "1+1 Deals & Discounts to choose from"
            lblText2.textColor = .white
            lblText2.font = UIFont.systemFont(ofSize: 15)
            testView.addSubview(lblText2)
            
            let lblText1 = UILabel()
            if(UIScreen.main.bounds.size.height < 570){
                lblText1.frame = CGRect(x: 40, y: lblText2.frame.origin.y - 50, width: testView.frame.size.width - 80, height : 45)
            }
            else{
                lblText1.frame = CGRect(x: 20, y: lblText2.frame.origin.y - 50, width: testView.frame.size.width - 40, height : 40)
            }
            lblText1.textAlignment = .center
            lblText1.numberOfLines = 0
            lblText1.text = "A handpicked list of the 100 best restaurants in Delhi NCR"
            lblText1.textColor = .white
            lblText1.font = UIFont.systemFont(ofSize: 15)
            testView.addSubview(lblText1)
            
            let lblText3 = UILabel(frame : CGRect(x: 30, y: lblText2.frame.origin.y + lblText2.frame.size.height + 20, width: testView.frame.size.width - 60, height : 20))
            lblText3.textAlignment = .center
            lblText3.text = "Exclusive access to curated experiences"
            lblText3.textColor = .white
            lblText3.font = UIFont.systemFont(ofSize: 15)
            testView.addSubview(lblText3)
         }
        }
    }
    
    func configurePageControl() {
        // Set the total pages to the page control.
        pageControl!.numberOfPages = 6
        
        // Set the initial page.
        pageControl!.currentPage = 0
        pageControl!.pageIndicatorTintColor = colorBrightSkyBlue
    }
    
    // MARK: UIScrollViewDelegate method implementation
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the new page index depending on the content offset.
        let currentPage = floor(scrollView.contentOffset.x / UIScreen.main.bounds.size.width);
        lblDetails?.textAlignment = .left
        btnEnter.removeFromSuperview()
        btnNext?.isHidden = false
        if(currentPage == 0){
            viewDetails?.frame = CGRect(x: 0, y : self.view.frame.size.height - 145, width : self.view.frame.size.width, height : 145)
            lblDetails?.frame = CGRect(x: 20, y : 0, width : self.view.frame.size.width - 40, height : 90)
            pageControl?.frame = CGRect(x: 20, y: 80, width : 100, height : 37)
            lblAlready?.frame = CGRect(x: 20, y : 117, width : 160, height : 20)
            btnSignIn?.frame = CGRect(x: 170, y : 117, width : 80, height : 20)
            btnNext?.frame = CGRect(x: self.view.frame.size.width - 80, y : 117, width : 80, height : 20)
            lblDetails?.text = "Swipe to know more"
        }
        else if(currentPage == 1){
            viewDetails?.frame = CGRect(x: 0, y : self.view.frame.size.height - 170, width : self.view.frame.size.width, height : 170)
            lblDetails?.frame = CGRect(x: 20, y : 0, width : self.view.frame.size.width - 40, height : 110)
            pageControl?.frame = CGRect(x: 20, y: 110, width : 100, height : 37)
            lblAlready?.frame = CGRect(x: 20, y : 147, width : 160, height : 20)
            btnSignIn?.frame = CGRect(x: 170, y : 147, width : 80, height : 20)
            btnNext?.frame = CGRect(x: self.view.frame.size.width - 80, y : 147, width : 80, height : 20)
            lblDetails?.text = "Book a seat at the most exciting events in the city, curated by Food Talk. Exclusively for Privilege members."
            
        }
        else if(currentPage == 2){
            
            viewDetails?.frame = CGRect(x: 0, y : self.view.frame.size.height - 170, width : self.view.frame.size.width, height : 170)
            lblDetails?.frame = CGRect(x: 20, y : 0, width : self.view.frame.size.width - 40, height : 110)
            pageControl?.frame = CGRect(x: 20, y: 110, width : 100, height : 37)
            lblAlready?.frame = CGRect(x: 20, y : 147, width : 160, height : 20)
            btnSignIn?.frame = CGRect(x: 170, y : 147, width : 80, height : 20)
            btnNext?.frame = CGRect(x: self.view.frame.size.width - 80, y : 147, width : 80, height : 20)
            lblDetails?.text = "Choose from six different deals. Unlock minimum six coupons per restaurant. Enjoy a year full of dining privileges."
            
        }
        else if(currentPage == 3){
            viewDetails?.frame = CGRect(x: 0, y : self.view.frame.size.height - 170, width : self.view.frame.size.width, height : 170)
            lblDetails?.frame = CGRect(x: 20, y : 0, width : self.view.frame.size.width - 40, height : 110)
            pageControl?.frame = CGRect(x: 20, y: 110, width : 100, height : 37)
            lblAlready?.frame = CGRect(x: 20, y : 147, width : 160, height : 20)
            btnSignIn?.frame = CGRect(x: 170, y : 147, width : 80, height : 20)
            btnNext?.frame = CGRect(x: self.view.frame.size.width - 80, y : 147, width : 80, height : 20)
            lblDetails?.text = "Search for your favourite restaurants or discover a restaurant you haven’t tried before!"
            
        }
        else if(currentPage == 4){
            viewDetails?.frame = CGRect(x: 0, y : self.view.frame.size.height - 170, width : self.view.frame.size.width, height : 170)
            lblDetails?.frame = CGRect(x: 20, y : 0, width : self.view.frame.size.width - 40, height : 110)
            pageControl?.frame = CGRect(x: 20, y: 110, width : 100, height : 37)
            lblAlready?.frame = CGRect(x: 20, y : 147, width : 160, height : 20)
            btnSignIn?.frame = CGRect(x: 170, y : 147, width : 80, height : 20)
            btnNext?.frame = CGRect(x: self.view.frame.size.width - 80, y : 147, width : 80, height : 20)
            lblDetails?.text = "Just ask your server to enter the unique PIN to redeem your offer."
            
        }
        else if(currentPage == 5){
            btnNext?.isHidden = true
            viewDetails?.frame = CGRect(x: 0, y : self.view.frame.size.height - 220, width : self.view.frame.size.width, height : 250)
            
            btnEnter = UIButton()
            btnEnter.frame = CGRect(x: self.view.frame.size.width/2 - 140, y: 15, width : 280, height : 64)
            btnEnter.backgroundColor = colorLightGold
            btnEnter.setTitle("ENTER", for: .normal)
            btnEnter.addTarget(self, action: #selector(ViewController.exploreTapped(_:)), for: .touchUpInside)
            btnEnter.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            btnEnter.setTitleColor(colorDarkGray, for: .normal)
            setDownLine(btnEnter)
            viewDetails?.addSubview(btnEnter)
            
            lblDetails?.frame = CGRect(x: self.view.frame.size.width/2 - 140, y : 80, width : 280, height : 80)
            pageControl?.frame = CGRect(x: 20, y: 164, width : 100, height : 37)
            lblAlready?.frame = CGRect(x: 20, y : 197, width : 160, height : 20)
            btnSignIn?.frame = CGRect(x: 170, y : 197, width : 80, height : 20)
            btnNext?.frame = CGRect(x: self.view.frame.size.width - 80, y : 197, width : 80, height : 20)
            lblDetails?.text = "Press 'ENTER' to start exploring offers. Signup when you're ready."
            lblDetails?.textAlignment = .center
        }
        // Set the new page index to the page control.
        pageControl!.currentPage = Int(currentPage)
    }
    
    //MARK:- exploreButton
    
    func exploreTapped(_ sender : UIButton){
        loginAs = "guest"
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    func loginTapped(_ sender : UIButton){
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "LoginNumber") as! LoginNumberViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
     
    }
    
    @IBAction func signIn(_ sender : UIButton){
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "LoginNumber") as! LoginNumberViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    @IBAction func next(_ sender : UIButton){
       scrollView?.setContentOffset(CGPoint(x: (scrollView?.frame.size.width)! * CGFloat(((pageControl?.currentPage)! + 1)), y: 0), animated: true)
    }
    

    // MARK: IBAction method implementation
    
    @IBAction func changePage(_ sender: AnyObject) {
        // Calculate the frame that should scroll to based on the page control current page.
        var newFrame = scrollView!.frame
        newFrame.origin.x = newFrame.size.width * CGFloat(pageControl!.currentPage)
        
        scrollView!.scrollRectToVisible(newFrame, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

