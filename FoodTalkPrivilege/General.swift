//
//  General.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 20/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

var baseUrl = "http://api.foodtalk.in/"
//var baseUrl = "http://stg-api.foodtalk.in/"

var colorBattleShipGray = UIColor(red: 116/255, green: 117/255, blue: 118/255, alpha: 1.0)
var colorBrightSkyBlue = UIColor(red: 31/255, green: 182/255, blue: 255/255, alpha: 1.0)
var colorPaleGray = UIColor(red: 249/255, green: 250/255, blue: 252/255, alpha: 1.0)
var colorLightGold = UIColor(red: 248/255, green: 141/255, blue: 23/255, alpha: 1.0)
var colorDarkGray = UIColor(red: 37/255, green: 38/255, blue: 40/255, alpha: 1.0)
var colorSeeweed = UIColor(red: 19/255, green: 206/255, blue: 102/255, alpha: 1.0)
var colorBtnDown = UIColor(red: 168/255, green: 104/255, blue: 0/255, alpha: 1.0)

var fontAbril = "BodoniSvtyTwoITCTT-Bold"
var fontFuturaBold = "Futura-bold"

var indicatorView = DotActivityIndicatorView()

var viewAlert = UIView()
var alerButton = UIButton()
var viewSpinner = UIView()
var problemArise = ""
var latitude = ""
var longitude = ""
var city_id = ""
var isTrailExpired : Bool = false

func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        return false
    }
    
    /* Only Working for WIFI
     let isReachable = flags == .reachable
     let needsConnection = flags == .connectionRequired
     
     return isReachable && !needsConnection
     */
    
    // Working for Cellular and WIFI
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    let ret = (isReachable && !needsConnection)
    if(ret == false){
        problemArise = "internet"
    }
    return ret
    
}

func openAlertScreen(_ view : UIView){
    viewAlert.frame = CGRect(x: 0, y: 95, width: view.frame.size.width, height : view.frame.size.height - 95)
    viewAlert.backgroundColor = .white
    view.addSubview(viewAlert)
    let img = UIImageView(frame : CGRect(x: view.frame.size.width/2 - 50, y: 200, width: 100, height : 80))
    img.contentMode = .scaleAspectFit
    viewAlert.addSubview(img)
    
    let lblMsg = UILabel(frame : CGRect(x: 15, y: img.frame.origin.y + img.frame.size.height + 30, width : view.frame.size.width - 30, height : 60))
    lblMsg.font = UIFont(name : fontFuturaBold, size : 14)
    lblMsg.numberOfLines = 0
    lblMsg.textAlignment = .center
    lblMsg.textColor = colorDarkGray
    viewAlert.addSubview(lblMsg)
    
    alerButton = UIButton()
    alerButton.frame = CGRect(x: view.frame.size.width/2 - 70, y: lblMsg.frame.origin.y + lblMsg.frame.size.height + 30, width : 140, height : 44)
    alerButton.layer.borderWidth = 2
    alerButton.layer.cornerRadius = 3
    alerButton.layer.borderColor = colorBrightSkyBlue.cgColor
    alerButton.setTitleColor(colorBrightSkyBlue, for: .normal)
    alerButton.titleLabel?.font = UIFont(name : "Futura-Medium", size : 16)
    viewAlert.addSubview(alerButton)
    
    if(problemArise == "internet"){
        img.image = UIImage(named : "wireless3.png")
        lblMsg.text = "Uh-oh. Looks like you’re not connected to the Internet. Please check your connection and try again"
        alerButton.setTitle("retry", for: .normal)
    }
    else if(problemArise == "history"){
        img.image = UIImage(named : "emptyHistory.png")
        lblMsg.text = "All your redemptions will appear here. You haven’t used any coupons yet"
        alerButton.setTitle("Browse offers", for: .normal)
    }
    else if(problemArise == "fav"){
        img.image = UIImage(named : "favBlack.png")
        lblMsg.text = "All your favorites will appear here"
        alerButton.setTitle("Browse offers", for: .normal)
    }
    else if(problemArise == "filter"){
        img.image = UIImage(named : "filter3.png")
        lblMsg.text = "We couldn’t find any results that match your search. Please try again with different filters."
        alerButton.setTitle("Edit filters", for: .normal)
    }
}

func setDownLine(_ button : UIButton){
    let border = CALayer()
    border.frame = CGRect.init(x: 0, y: button.frame.height - 4, width: button.frame.width, height: 4)
    border.backgroundColor = colorBtnDown.cgColor;
    
    button.layer.addSublayer(border)
}

func showActivityIndicator(view : UIView){
    viewSpinner = view
    indicatorView = DotActivityIndicatorView()
    indicatorView.frame = CGRect(x: view.frame.size.width/2 - 30, y: view.frame.size.height/2 - 80, width : 60, height : 40)
    let indicator = DotActivityIndicatorParms()
    indicator.activityViewWidth = indicatorView.frame.size.width
    indicator.activityViewHeight = indicatorView.frame.size.height
    indicator.defaultColor = colorBrightSkyBlue
    indicator.numberOfCircles = 3;
    indicator.internalSpacing = 5;
    indicator.animationDelay = 0.2;
    indicator.animationDuration = 0.6;
    indicator.animationFromValue = 0.3;
    indicator.isDataValidationEnabled = true;
    indicatorView.dotParms = indicator
    view.addSubview(indicatorView)
    indicatorView.startAnimating()
    viewSpinner.isUserInteractionEnabled = false
}

func showAnimationWithFrame(x : CGFloat, y : CGFloat, view : UIView){
    viewSpinner = view
    
    indicatorView.frame = CGRect(x: x, y: y, width : 60, height : 40)
    let indicator = DotActivityIndicatorParms()
    indicator.activityViewWidth = indicatorView.frame.size.width
    indicator.activityViewHeight = indicatorView.frame.size.height
    indicator.defaultColor = colorBrightSkyBlue
    indicator.numberOfCircles = 3;
    indicator.internalSpacing = 5;
    indicator.animationDelay = 0.2;
    indicator.animationDuration = 0.6;
    indicator.animationFromValue = 0.3;
    indicator.isDataValidationEnabled = true;
    indicatorView.dotParms = indicator
    view.addSubview(indicatorView)
    indicatorView.startAnimating()
    viewSpinner.isUserInteractionEnabled = false
}

func stopAnimation(view : UIView){
    if view.subviews.contains(indicatorView) {
        indicatorView.removeFromSuperview() // Remove it
    }
 //   indicatorView.removeFromSuperview()
    viewSpinner.isUserInteractionEnabled = true
    indicatorView.stopAnimating()
}
