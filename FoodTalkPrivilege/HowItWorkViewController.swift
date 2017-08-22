//
//  HowItWorkViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 26/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class HowItWorkViewController: UIViewController , UIScrollViewDelegate{
    
    @IBOutlet var pageControl : UIPageControl?
    @IBOutlet var scrollView : UIScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let btnCross = UIButton(frame : CGRect(x: 20, y: 25, width : 44, height: 44))
        btnCross.setImage(UIImage(named : "cancelMaterial.png"), for: .normal)
        btnCross.addTarget(self, action: #selector(HowItWorkViewController.cross(_:)), for: .touchUpInside)
        self.view.addSubview(btnCross)
        FBSDKAppEvents.logEvent("howitwork_view")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureScrollView()
        configurePageControl()
    }
    
    func cross(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
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
        scrollView!.contentSize = CGSize(width: scrollView!.frame.size.width * CGFloat(5),height: 0);
        
        // Set self as the delegate of the scrollview.
        scrollView!.delegate = self
        
        // Load the TestView view from the TestView.xib file and configure it properly.
        if(5 > 0){
            for i in 0..<5 {
                // Load the TestView view.
                let testView = UIView()
                
                // Set its frame and the background color.
                testView.frame = CGRect(x: CGFloat(i) * scrollView!.frame.size.width, y: 0, width: scrollView!.frame.size.width, height: scrollView!.frame.size.height - 50)
                createViewOnPage(testView: testView, i : i)
                // Add the test view as a subview to the scrollview.
                scrollView!.addSubview(testView)
            }
        }
        else{
            let testView = UIView()
            
            // Set its frame and the background color.
            testView.frame = CGRect(x: 0, y: 0, width: scrollView!.frame.size.width, height: scrollView!.frame.size.height - 50)
            //   placeHolder(testView: testView)
            // Add the test view as a subview to the scrollview.
            scrollView!.addSubview(testView)
        }
    }
    
    func createViewOnPage(testView : UIView, i : Int){
        let lblHeader = UILabel(frame : CGRect(x: 0, y: 18, width : testView.frame.size.width, height: 24))
        lblHeader.textColor = colorLightGold
        lblHeader.font = UIFont(name : fontAbril, size : 18)
        lblHeader.textAlignment = .center
        testView.addSubview(lblHeader)
        
        let lblDescb = UILabel()
        if(UIScreen.main.bounds.size.height < 570){
            lblDescb.frame = CGRect(x: 10, y: lblHeader.frame.origin.y + lblHeader.frame.size.height + 12, width: testView.frame.size.width - 20, height : 40)
        }
        else{
            lblDescb.frame = CGRect(x: 40, y: lblHeader.frame.origin.y + lblHeader.frame.size.height + 12, width: testView.frame.size.width - 80, height : 40)
        }

        
        lblDescb.numberOfLines = 0
        lblDescb.font = UIFont.systemFont(ofSize: 16)
        lblDescb.textColor = UIColor.white
        lblDescb.textAlignment = .center
        testView.addSubview(lblDescb)
        
        let img = UIImageView(frame : CGRect(x: 31, y: lblDescb.frame.origin.y + lblDescb.frame.size.height + 23, width: testView.frame.size.width - 62, height : self.view.frame.size.height - 100))
        testView.addSubview(img)
        
        if(i == 0){
            lblHeader.text = "EXPLORE"
            lblDescb.text = "Browse through our list of hand picked restaurants to find a deal"
            img.image = UIImage(named : "explore.png")
        }
        else if(i == 1){
            
            lblHeader.text = "SEARCH"
            lblDescb.text = "Our filters to narrow down on a restaurant based on your preferences"
            img.image = UIImage(named : "Filter.png")
        }
        else if(i == 2){
            lblHeader.text = "SELECT  YOUR  OFFER"
            lblDescb.text = "Select an offer you want & hit redeem coupon(s)"
            img.image = UIImage(named : "Dine.png")
        }
        else if(i == 3){
            lblHeader.text = "CONFIRM  OFFER"
            lblDescb.text = "Present your app to the restaurant & ask them to punch in the PIN"
            img.image = UIImage(named : "confirm.png")
        }
        else if(i == 4){
            lblHeader.text = "PURCHASE"
            lblDescb.text = String(format : "Buy Food Talk Privilage for %@ 1200 only to enjoy deals and more for 1 full year.", "\u{20B9}")
            img.image = UIImage(named : "payment.png")
        }
    }
    
    func configurePageControl() {
        // Set the total pages to the page control.
        pageControl!.numberOfPages = 5
        
        // Set the initial page.
        pageControl!.currentPage = 0
        pageControl!.pageIndicatorTintColor = colorBrightSkyBlue
    }
    
    // MARK: UIScrollViewDelegate method implementation
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the new page index depending on the content offset.
        let currentPage = floor(scrollView.contentOffset.x / UIScreen.main.bounds.size.width);
        
        // Set the new page index to the page control.
        pageControl!.currentPage = Int(currentPage)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
