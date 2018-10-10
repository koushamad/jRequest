//
//  justRequest.swift
//  Rad
//
//  Created by kousha ghodsizad on 7/25/18.
//  Copyright © 2018 kousha ghodsizad. All rights reserved.
//

import Foundation
import Just
import CryptoSwift

struct justRequest {
    public enum methods: String {
        case delete = "DELETE"
        case get = "GET"
        case head = "HEAD"
        case options = "OPTIONS"
        case patch = "PATCH"
        case post = "POST"
        case put = "PUT"
    }
    internal var id : String
    internal var method : methods = methods.get
    internal var url : String! = ""
    internal var params : [String:Any] = [:]
    internal var data : [String:Any] = [:]
    internal var json : [String:Any]? = nil {
        willSet{
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: newValue ?? [:], options: .prettyPrinted)
                self.jsonCode = jsonData
            } catch {
                self.jsonCode = nil
            }
        }
    }
    internal var jsonCode : Data?  = nil
    internal var headers : [String:String] = [:]
    internal var files : [String: HTTPFile] = [:]
    internal var auth: (String, String)? = nil
    internal var cookies: [String: String] = [:]
    internal var allowRedirects: Bool = true
    internal var timeout: Double? = nil
    internal var urlQuery: String? = nil
    internal var requestBody: Data? = nil
    internal var asyncProgressHandler: (TaskProgressHandler)? = nil
    internal var asyncCompletionHandler: ((HTTPResult) -> Void)? = nil
    internal var hasCash : Bool = false
    internal var hasQueue : Bool = false
    internal var oneRes : Bool = false
    internal var debugMod : Bool = true
    internal var sending : Bool = false
    internal var binery : Data {
        get {
            let data = self.get()
            return  NSKeyedArchiver.archivedData(withRootObject: data)
        }
        set{
            let data: Dictionary = (NSKeyedUnarchiver.unarchiveObject(with: newValue) as! [String : AnyObject])
            set(request: data)
        }
    }
    
    init(method:methods? = methods.get,url:String,params:[String:AnyObject]? = nil,data:[String:AnyObject]? = nil,json:[String:Any]? = nil,headers:[String:String]? = nil,files : [String: HTTPFile]? = nil,auth: (String, String)? = nil,cookies: [String: String]? = nil,allowRedirects: Bool? = nil,timeout: Double? = nil,urlQuery: String? = nil,requestBody: Data? = nil,asyncProgressHandler: (TaskProgressHandler)? = nil, cash : Bool? = false , oneRes : Bool? = false , queue : Bool? = false , debug : Bool? = false , asyncCompletionHandler: ((HTTPResult) -> Void)? = nil){
        
        self.url = url
        self.method = method ?? methods.get
        self.params = params ?? [:]
        self.data = data ?? [:]
        self.cookies = cookies ?? [:]
        self.headers = headers ?? [:]
        self.allowRedirects = allowRedirects ?? true
        self.json = json
        self.auth = auth
        self.timeout = timeout
        self.urlQuery = urlQuery
        self.requestBody = requestBody
        self.asyncProgressHandler = asyncProgressHandler
        self.asyncCompletionHandler = asyncCompletionHandler
        self.hasCash = cash ?? false
        self.oneRes = oneRes ?? false
        self.hasQueue = queue ?? false
        self.debugMod = debug ?? false
        self.id = ""
        
        var str = self.url + self.method.rawValue + ((self.urlQuery != nil) ? self.urlQuery! : "")
        if self.params.count > 0 {
            for (key, value) in self.params{
                let sValue = value as? String != nil ? value as! String : ""
                str += key + sValue
            }
        }
        if self.data.count > 0{
            for (key, value) in self.data{
                let sValue = (value as? String != nil) ? value as! String : ""
                str += key + sValue
            }
        }
        if self.files.count > 0{
            for (key, _) in self.files{
                str += key
            }
        }
        if self.cookies.count > 0{
            for (key, value) in self.cookies{
                str += key + value
            }
        }
        if self.headers.count > 0{
            for (key, value) in self.headers{
                str += key + value
            }
        }
        if self.headers.count > 0{
            for (key, value) in self.json!{
                let sValue = value as? String != nil ? value as! String : ""
                str += key + sValue
            }
        }
        self.id = str.md5()
        
        
        if self.debugMod {
            print("******************************************************Request*********************************************************")
            print(self)
            print("*******************************************************************************************************************")
        }
        
    }
    internal func get()->[String:AnyObject]{
        return [
            "id" : self.id as AnyObject ,
            "method" : self.method.rawValue as AnyObject ,
            "url" : self.url as AnyObject ,
            "params" : self.params as AnyObject ,
            "data" : self.data as AnyObject ,
            "json" : self.json as AnyObject ,
            "headers" : self.headers as AnyObject ,
            "files" : self.files as AnyObject ,
            "auth" : self.auth as AnyObject ,
            "cookies" : self.cookies as AnyObject ,
            "allowRedirects" : self.allowRedirects as AnyObject ,
            "timeout" : self.timeout as AnyObject ,
            "urlQuery" : self.urlQuery as AnyObject ,
            "requestBody" : self.requestBody as AnyObject ,
            "asyncProgressHandler" : self.asyncProgressHandler as AnyObject ,
//            "asyncCompletionHandler" : self.asyncCompletionHandler as AnyObject ,
            "hasCash" : self.hasCash as AnyObject ,
            "hasQueue" : self.hasQueue as AnyObject ,
            "oneRes" : self.oneRes as AnyObject ,
            "debugMod" : self.debugMod as AnyObject ,
        ]
    }
    internal mutating func set(request : [String:AnyObject]){
        self.id = request["id"] as! String
        self.method = (methods.init(rawValue: request["method"] as! String)!)
        self.url = (request["url"] as! String)
        self.params = request["params"] as! [String:Any]
        self.data = request["data"] as! [String:Any]
        self.json = request["json"] as? [String:Any]
        self.headers = request["headers"] as! [String:String]
        self.files = request["files"] as! [String: HTTPFile]
        self.auth = request["auth"] as? (String, String)
        self.cookies = request["cookies"] as! [String: String]
        self.allowRedirects = request["allowRedirects"] as! Bool
        self.timeout = request["timeout"] as? Double
        self.urlQuery = request["urlQuery"] as? String
        self.requestBody = request["requestBody"] as? Data
        self.asyncProgressHandler = request["asyncProgressHandler"] as? (TaskProgressHandler)
//        self.asyncCompletionHandler = request["asyncCompletionHandler"] as? ((HTTPResult) -> Void)
        self.hasCash = request["hasCash"] as! Bool
        self.oneRes = request["oneRes"] as! Bool
        self.hasQueue = request["hasQueue"] as! Bool
        self.debugMod = request["debugMod"] as! Bool
    }
    
}
