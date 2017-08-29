//
//  WebServices.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 01/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol WebServiceCallingDelegate {
    func getDataFromWebService(_ dict : NSMutableDictionary)
    func serviceFailedWitherror(_ error : NSError)
    func serviceUploadProgress(_ myprogress : float_t)
}

var delegate : WebServiceCallingDelegate?
var request = Alamofire.Request

func webServiceCallingPost (_ url : String, parameters : NSDictionary){
    
    let headers = [
        "Authorization": "iOS"
    ]
    
    Alamofire.request(url, method: .post, parameters: parameters as? Parameters, encoding: JSONEncoding.default, headers: headers as? HTTPHeaders).responseJSON { response in
        if(response.result.isFailure){
            print(response.description);
         //   delegate?.serviceFailedWitherror(response.result.error! as NSError)
        }else{
            if let JSON = response.result.value {
                
//                delegate?.getDataFromWebService((JSON as! NSDictionary).mutableCopy() as! NSMutableDictionary)
                
                let dictResponse = JSON as! NSDictionary
                    
                    if((dictResponse.object(forKey: "code")! as! String) == "401"){
                        webServiceForRefreshToken(url, parameters: parameters)
                    }
                else{
                    delegate?.getDataFromWebService((JSON as! NSDictionary).mutableCopy() as! NSMutableDictionary)
                }
                
            }
        }
    }
}

func webServiceCallingPut (_ url : String, parameters : NSDictionary){
    
    let headers = [
        "Authorization": "iOS"
    ]
    
    Alamofire.request(url, method: .put, parameters: parameters as? Parameters, encoding: JSONEncoding.default, headers: headers as? HTTPHeaders).responseJSON { response in
        if(response.result.isFailure){
            print(response.description);
            //   let error = NSError()
            //   delegate?.serviceFailedWitherror(error)
        }else{
            if let JSON = response.result.value {
                
           //     delegate?.getDataFromWebService((JSON as! NSDictionary).mutableCopy() as! NSMutableDictionary)
                
                let dictResponse = JSON as! NSDictionary
                
                if((dictResponse.object(forKey: "code")! as! String) == "401"){
                    webServiceForRefreshToken(url, parameters: parameters)
                }
                else{
                    delegate?.getDataFromWebService((JSON as! NSDictionary).mutableCopy() as! NSMutableDictionary)
                }
            }
        }
    }
    
}

func webServiceForRefreshToken(_ url : String, parameters : NSDictionary){

    var request = URLRequest(url: URL(string: String(format: "%@%@", baseUrl, "refreshsession"))!)
    request.httpMethod = "POST"
    var token = ""
    if((UserDefaults.standard.object(forKey: "token")) != nil){
        token = UserDefaults.standard.object(forKey: "token") as! String
    
    
    let postString = ["refresh_token" : token] as Dictionary<String, String>
    do {
        let jsonData = try? JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        request.httpBody = jsonData
    } catch let error {
        print(error.localizedDescription)
    }
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            print("error=\(error)")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
        }
        
        let responseString = String(data: data, encoding: .utf8)
        print("responseString = \(responseString)")
        if let data = responseString?.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                
                if((json?.object(forKey: "api") as! String).contains("refreshsession")){
                    if(json?.object(forKey: "status") as! String == "OK"){
                        let dict = parameters.mutableCopy() as! NSMutableDictionary
                        let sessionId = (json?.object(forKey: "result") as! NSDictionary).object(forKey: "session_id") as! String
                        let token = (json?.object(forKey: "result") as! NSDictionary).object(forKey: "refresh_token") as! String
                        let session = json?.object(forKey: "result") as! NSDictionary
                        dict.setValue(sessionId, forKey: "sessionId")
                        UserDefaults.standard.setValue(session, forKey: "session")
                        UserDefaults.standard.setValue(sessionId, forKey: "sessionId")
                        UserDefaults.standard.set(token, forKey: "token")
                        
                        if(url.contains("sessionid=")){
                        let fullNameArr = url.components(separatedBy: "sessionid=")
                        
                        let name    = fullNameArr[0]
                        
                        
                        let strFull = String(format : "%@%@%@", name, "sessionid=", sessionId)
                            
                        webServiceCallingPost(strFull, parameters: dict)
                        }
                        else{
                        webServiceCallingPost(url, parameters: dict)
                        }
                        
                        
                        
                    }
                    else{
                        let error = NSError()
                        delegate?.serviceFailedWitherror(error)
                    }
                }
            } catch {
                print("Something went wrong")
            }
        }
    }
    task.resume()
    }
    else{
        let error = NSError()
        delegate?.serviceFailedWitherror(error)
    }
    
}

func webServiceForGetRefreshToken(_ url : String){

    var request = URLRequest(url: URL(string: String(format: "%@%@", baseUrl, "refreshsession"))!)
    request.httpMethod = "POST"
    var token = ""
    if((UserDefaults.standard.object(forKey: "token")) != nil){
    token = UserDefaults.standard.object(forKey: "token") as! String
    
    
    let postString = ["refresh_token" : token] as Dictionary<String, String>
    do {
        let jsonData = try? JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        request.httpBody = jsonData
    } catch let error {
        print(error.localizedDescription)
    }
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            print("error=\(error)")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
        }
        
        let responseString = String(data: data, encoding: .utf8)
        print("responseString = \(responseString)")
        if let data = responseString?.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                if((json?.object(forKey: "api") as! String).contains("refreshsession")){
                    if(json?.object(forKey: "status") as! String == "OK"){
                        
                        let sessionId = (json?.object(forKey: "result") as! NSDictionary).object(forKey: "session_id") as! String
                        let token = (json?.object(forKey: "result") as! NSDictionary).object(forKey: "refresh_token") as! String
                        let session = json?.object(forKey: "result") as! NSDictionary
                        let fullNameArr = url.components(separatedBy: "sessionid=")
                        
                        let name    = fullNameArr[0]
                        let surname = fullNameArr[1]
                        
                        let strFull = String(format : "%@%@%@", name, "sessionid=", sessionId)
                        UserDefaults.standard.setValue(session, forKey: "session")
                        UserDefaults.standard.setValue(sessionId, forKey: "sessionId")
                        UserDefaults.standard.set(token, forKey: "token")
                      //  UserDefaults.standard.setValue(0, forKey: "counterSessionExpire")
                        webServiceGet(strFull)
                    }
                    else{
                        let error = NSError()
                        delegate?.serviceFailedWitherror(error)
                    }
                }
            } catch {
                print("Something went wrong")
            }
        }
    }
    task.resume()

    }
    else{
        let error = NSError()
        delegate?.serviceFailedWitherror(error)
    }
}



func webServiceCallingDelete (_ url : String, parameters : NSDictionary){
    
    let headers = [
        "Authorization": "iOS"
    ]
    
    Alamofire.request(url, method: .delete, parameters: parameters as? Parameters, encoding: JSONEncoding.default, headers: headers as? HTTPHeaders).responseJSON { response in
        if(response.result.isFailure){
            print(response.description);
            //   let error = NSError()
            //   delegate?.serviceFailedWitherror(error)
        }else{
            if let JSON = response.result.value {
                
                delegate?.getDataFromWebService((JSON as! NSDictionary).mutableCopy() as! NSMutableDictionary)
            }
        }
    }
    
}


func webServiceGet(_ urlTo : String){
    
    let headers = [
        "Authorization": "iOS"
    ]
    //   var dict = NSMutableDictionary()
    Alamofire.request(urlTo, headers: headers as? HTTPHeaders).responseJSON { response in
        // result of response serialization
        
        if let JSON = response.result.value {
            
        //    delegate?.getDataFromWebService((JSON as! NSDictionary).mutableCopy() as! NSMutableDictionary)
            
            let dictResponse = JSON as! NSDictionary
            
            if((dictResponse.object(forKey: "code") as! String) == "401"){
                webServiceForGetRefreshToken(urlTo)
            }
            else{
                delegate?.getDataFromWebService((JSON as! NSDictionary).mutableCopy() as! NSMutableDictionary)
            }
        }
        else{
            
        }
    }
}

func setImageWithUrl(_ urlTo : String, imgView : UIImageView){
    let url = URL(string: urlTo)!
    imgView.af_setImage(withURL: url)
}

func setPlaceHolderImage(with URLString: String, placeholderImage: UIImage, imgView : UIImageView) {
    
    imgView.af_setImage(
        withURL: URL(string: URLString)!,
        placeholderImage: placeholderImage,
        filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: imgView.frame.size, radius: 0.0),
        imageTransition: .crossDissolve(0.2)
    )
}

func cancelRequest(){
    
    Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
        sessionDataTask.forEach { $0.cancel() }
        uploadData.forEach { $0.cancel() }
        downloadData.forEach { $0.cancel() }
    }
}

