//
//  jRequest.swift
//  Rad
//
//  Created by kousha ghodsizad on 7/24/18.
//  Copyright © 2018 kousha ghodsizad. All rights reserved.
//

import Foundation
import Just

class jRequest {
    
    
    internal let request : justRequest
    internal var response : justResponce
    
    init(request : justRequest) {
        self.request = request
        self.response = justResponce.init(request: request)
    }
    init (method:justRequest.methods? = justRequest.methods.get,url:String,params:[String:AnyObject]? = nil,data:[String:AnyObject]? = nil,json:[String:Any]? = nil,headers:[String:String]? = nil,files : [String: HTTPFile]? = nil,auth: (String, String)? = nil,cookies: [String: String]? = nil,allowRedirects: Bool? = nil,timeout: Double? = nil,urlQuery: String? = nil,requestBody: Data? = nil,asyncProgressHandler: (TaskProgressHandler)? = nil,cash:Bool? = false , oneRes : Bool? = false , queue : Bool? = false , debug : Bool? = false ,asyncCompletionHandler: ((HTTPResult) -> Void)? = nil ) {
        
        let request = justRequest.init(method: method, url: url, params: params, data: data, json: json, headers: headers, files: files, auth: auth, cookies: cookies, allowRedirects: allowRedirects, timeout: timeout, urlQuery: urlQuery, requestBody: requestBody, asyncProgressHandler: asyncProgressHandler, cash: cash, oneRes: oneRes,queue: queue, debug: debug, asyncCompletionHandler: asyncCompletionHandler)
        self.request = request
        self.response = justResponce.init(request: request)
    }
    
    public func send(CB: @escaping (justResponce)->Void){

        if request.hasCash && !request.oneRes{
            let cash = justCash()
            cash.get(id: self.response.id) { (data) in
                var Res = justResponce.init(request: self.request)
                Res.binery = data
                CB(Res)
            }
        }
        
        if self.request.hasQueue{
                let queue = justQueue(id: self.request.id)
                queue.set(id: self.request.id, data: self.request.binery, sending: false, CB: { (status) in
                    if status{
                        if self.response.debugMod{
                            print("******************************************************Queue********************************************************")
                            print(self.request.binery)
                            print("*******************************************************************************************************************")
                        }
                        queue.run(CB: { (Res) in
                            self.response = Res
                            CB(Res)
                        })
                    }
                })
        }else{
            sendRequest { (Res) in
                if self.response.debugMod{
                    print("******************************************************Request********************************************************")
                    print(self.request)
                    print("**********************************************************************************************************************")
                    print("******************************************************Response********************************************************")
                    print(Res)
                    print("**********************************************************************************************************************")
                }
                if Res.ok{
                    self.response = Res
                    if self.request.hasCash{
                        let cash = justCash()
                        cash.set(id: self.response.id, data: self.response.binery, CB: { (_) in
                            if self.response.debugMod{
                                print("******************************************************Cash*********************************************************")
                                print(self.response.binery)
                                print("*******************************************************************************************************************")
                            }
                        })
                    }
                    CB(Res)
                }else if (self.request.oneRes){
                    let cash = justCash()
                    cash.get(id: self.response.id) { (data) in
                        var Res = justResponce.init(request: self.request)
                        Res.binery = data
                        CB(Res)
                    }
                }
            }
        }
        
    }
    
    private func sendRequest(CB: @escaping (justResponce)->Void){
        
        guard URL(string:request.url) != nil else {
            CB(response)
            return
        }
        
        switch request.method {
        case .get:
            Just.get(self.request.url, params: self.request.params, data: self.request.data, json: self.request.json, headers: self.request.headers, files: self.request.files, auth: self.request.auth, cookies: self.request.cookies, allowRedirects: self.request.allowRedirects, timeout: self.request.timeout, urlQuery: self.request.urlQuery, requestBody: self.request.requestBody, asyncProgressHandler: self.request.asyncProgressHandler){ res in
                
                self.analizResponse(res: res)
                
                CB(self.response)
                
            }
            break
        case .post:
            Just.post(self.request.url, params: self.request.params, data: self.request.data, json: self.request.json, headers: self.request.headers, files: self.request.files, auth: self.request.auth, cookies: self.request.cookies, allowRedirects: self.request.allowRedirects, timeout: self.request.timeout, urlQuery: self.request.urlQuery, requestBody: self.request.requestBody, asyncProgressHandler: self.request.asyncProgressHandler){ res in
                
                self.analizResponse(res: res)
                
                CB(self.response)
                
            }
            break
        case .delete:
            Just.delete(self.request.url, params: self.request.params, data: self.request.data, json: self.request.json, headers: self.request.headers, files: self.request.files, auth: self.request.auth, cookies: self.request.cookies, allowRedirects: self.request.allowRedirects, timeout: self.request.timeout, urlQuery: self.request.urlQuery, requestBody: self.request.requestBody, asyncProgressHandler: self.request.asyncProgressHandler){ res in
                
                self.analizResponse(res: res)
                
                CB(self.response)
                
            }
            break
        case .head:
            Just.head(self.request.url, params: self.request.params, data: self.request.data, json: self.request.json, headers: self.request.headers, files: self.request.files, auth: self.request.auth, cookies: self.request.cookies, allowRedirects: self.request.allowRedirects, timeout: self.request.timeout, urlQuery: self.request.urlQuery, requestBody: self.request.requestBody, asyncProgressHandler: self.request.asyncProgressHandler){ res in
                
                self.analizResponse(res: res)
                
                CB(self.response)
                
            }
            break
        case .options:
            Just.options(self.request.url, params: self.request.params, data: self.request.data, json: self.request.json, headers: self.request.headers, files: self.request.files, auth: self.request.auth, cookies: self.request.cookies, allowRedirects: self.request.allowRedirects, timeout: self.request.timeout, urlQuery: self.request.urlQuery, requestBody: self.request.requestBody, asyncProgressHandler: self.request.asyncProgressHandler){ res in
                
                self.analizResponse(res: res)
                
                CB(self.response)
                
            }
            break
        case .patch:
            Just.patch(self.request.url, params: self.request.params, data: self.request.data, json: self.request.json, headers: self.request.headers, files: self.request.files, auth: self.request.auth, cookies: self.request.cookies, allowRedirects: self.request.allowRedirects, timeout: self.request.timeout, urlQuery: self.request.urlQuery, requestBody: self.request.requestBody, asyncProgressHandler: self.request.asyncProgressHandler){ res in
                
                self.analizResponse(res: res)
                
                CB(self.response)
                
            }
            break
        case .put:
            Just.put(self.request.url, params: self.request.params, data: self.request.data, json: self.request.json, headers: self.request.headers, files: self.request.files, auth: self.request.auth, cookies: self.request.cookies, allowRedirects: self.request.allowRedirects, timeout: self.request.timeout, urlQuery: self.request.urlQuery, requestBody: self.request.requestBody, asyncProgressHandler: self.request.asyncProgressHandler){ res in
                self.analizResponse(res: res)
                CB(self.response)
            }
            break
        }
        
        
        
    }
    public func get(callback: @escaping (Bool)->Void){
        
        Just.get(self.request.url, params: self.request.params, data: self.request.data, json: self.request.json, headers: self.request.headers, files: self.request.files, auth: self.request.auth, cookies: self.request.cookies, allowRedirects: self.request.allowRedirects, timeout: self.request.timeout, urlQuery: self.request.urlQuery, requestBody: self.request.requestBody, asyncProgressHandler: self.request.asyncProgressHandler){ res in
            
            self.analizResponse(res: res)
            
        }
        
    }
    private func analizResponse(res : HTTPResult) {
        self.response.content = res.content
        self.response.text = res.text
        self.response.url = res.url
        self.response.json = res.json
//        self.response.error = res.error
//        self.response.request = res.request
        self.response.isRedirect = res.isRedirect
        self.response.ok = res.ok
        self.response.reason = res.reason
//        self.response.encoding = res.encoding
        
        
        let jinfo = res.json as? [String:AnyObject]
        
        guard jinfo != nil else {
            self.response.status = false
            if self.request.hasQueue{
//                self.response.err = "your request add to queue !  "
                self.response.code = -9
            }else if self.request.hasCash{
//                self.response.err = "your request response from cash ! "
                self.response.code = -8
            }else{
                self.response.err = "can not conect to enternet ! "
                self.response.code = -7
            }
            return
        }
        
        if jinfo!["status"] != nil {
            let status = jinfo!["status"]! as? String ?? String(describing: jinfo!["status"]!)
            if status == "true" || status == "1" {
                self.response.status = true
            }else{
                self.response.status = false
            }
        }
        if jinfo!["error"] != nil {
            let error =  jinfo!["error"]! as? String ?? ""
            self.response.err = error
        }
        if jinfo!["code"] != nil {
            let code = (jinfo!["code"]! as? String != nil) ? Int(jinfo!["code"]! as! String) : jinfo!["code"]! as? Int ?? 0
            self.response.code = code!
        }
        if jinfo!["data"] != nil &&  ((jinfo!["data"] as? [String:AnyObject]) != nil) {
            let info = jinfo!["data"]! as! [String:AnyObject]
            self.response.info = info
            self.response.isObject = true
        }else if jinfo!["data"] != nil{
            let data = jinfo!["data"]! as! [AnyObject]
            self.response.data = data
            self.response.isList = true
        }
    }

}
