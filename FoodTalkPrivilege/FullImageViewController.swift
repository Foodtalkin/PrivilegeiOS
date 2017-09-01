//
//  FullImageViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 18/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController, iCarouselDataSource, iCarouselDelegate{
    
    @IBOutlet var carousal : iCarousel?
    @IBOutlet var lblNumber : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        carousal?.backgroundColor = .clear
        carousal?.type = .linear
        carousal?.isPagingEnabled = true
        carousal?.currentItemIndex = indexSelectedImage
        
        lblNumber?.frame = CGRect(x: self.view.frame.size.width/2 - 64, y: self.view.frame.size.height - 50, width : 127, height : 30)
        lblNumber?.text = String(format : "%d/%d", indexSelectedImage + 1, arrImages.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        carousal?.isHidden = false
    }
    
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
            itemView = UIView(frame:CGRect(x: 0, y:self.view.frame.size.height/2 - 250, width:carousel.frame.size.width, height:400))
            itemView.backgroundColor = .clear
            let img = UIImageView(frame : CGRect(x: 0, y: 0, width: itemView.frame.size.width, height: itemView.frame.size.height))
            img.contentMode = .scaleAspectFit
            itemView.addSubview(img)
            var url = ""
            if(arrImages.count > 0){
                url = (arrImages.object(at: index) as! NSDictionary).object(forKey: "url") as! String
                setImageWithUrl(url, imgView: img)
            }
            
        }
        else{
           // itemView = view!;
            itemView = UIView(frame:CGRect(x: 0, y:self.view.frame.size.height/2 - 250, width:carousel.frame.size.width, height:400))
            itemView.backgroundColor = .clear
            let img = UIImageView(frame : CGRect(x: 0, y: 0, width: itemView.frame.size.width, height: itemView.frame.size.height))
            img.contentMode = .scaleAspectFit
            itemView.addSubview(img)
            var url = ""
            if(arrImages.count > 0){
                url = (arrImages.object(at: index) as! NSDictionary).object(forKey: "url") as! String
                setImageWithUrl(url, imgView: img)
            }
        }
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .spacing)
        {
            return value * 1.1
        }
        if (option == .wrap)
        {
            return 0
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        lblNumber?.text = String(format : "%d/%d", carousel.currentItemIndex + 1, arrImages.count)
    }

    @IBAction func backButtonPressed(_ sender : UIButton){
        carousal?.isHidden = true
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
