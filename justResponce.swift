//
//  justResponce.swift
//  Rad
//
//  Created by kousha ghodsizad on 7/25/18.
//  Copyright © 2018 kousha ghodsizad. All rights reserved.
//

import Foundation
import Just

struct justResponce {
    
    internal var id : String
    internal var debugMod : Bool
    
    internal var headers : [String:String] = [:]
    internal var content : Data? = nil
    internal var text : String? = nil
    internal var url : URL? = nil
    internal var json : Any? = nil
//    internal var error : Error? = nil
//    internal var request : URLRequest? = nil
    internal var isRedirect : Bool = false
    internal var ok : Bool = false
    internal var reason : String = ""
//    internal var encoding = String.Encoding.utf8
    internal var binery : Data {
        get {
            let data = self.get()
            return NSKeyedArchiver.archivedData(withRootObject: data)
        }
        set{
            let data: Dictionary = (NSKeyedUnarchiver.unarchiveObject(with: newValue) as! [String : AnyObject])
            set(response: data)
        }
    }
    
    internal var status : Bool = false
    internal var isList : Bool = false
    internal var isObject : Bool = false
    internal var code : Int = -10
    internal var err : String = ""
    internal var data : [AnyObject]?
    internal var info : [String:AnyObject]?
    
    
    
    init(request : justRequest) {
        
        self.id = request.id
        self.debugMod = request.debugMod
        
    }
    
    internal func get()->[String:AnyObject]{
        return [
            "id" : self.id as AnyObject ,
            "debugMod" : self.debugMod as AnyObject ,
            "headers" : self.headers as AnyObject ,
            "content" : self.content as AnyObject ,
            "text" : self.text as AnyObject ,
            "url" : self.url as AnyObject ,
            "json" : self.json as AnyObject ,
//            "error" : self.error as AnyObject ,
//            "request" : self.request as AnyObject ,
            "isRedirect" : self.isRedirect as AnyObject ,
            "ok" : self.ok as AnyObject ,
            "reason" : self.reason as AnyObject ,
//            "encoding" : self.encoding as AnyObject ,
            "status" : self.status as AnyObject ,
            "isList" : self.isList as AnyObject ,
            "isObject" : self.isObject as AnyObject ,
            "code" : self.code as AnyObject ,
            "err" : self.err as AnyObject ,
            "data" : self.data as AnyObject ,
            "info" : self.info as AnyObject
        ]
    }
    internal mutating func set(response:[String:AnyObject])->Void{
        self.id = response["id"] as! String
        self.debugMod = response["debugMod"] as! Bool
        self.headers = response["headers"] as! [String:String]
        self.content = response["content"] as? Data
        self.text = response["text"] as? String
        self.url = response["url"] as? URL
        self.json =  jsonToString(json: response["json"]!)
//        self.error = request["error"] as? Error
//        self.request = request["request"] as? URLRequest
        self.isRedirect = response["isRedirect"] as! Bool
        self.ok = response["ok"] as! Bool
        self.reason = response["reason"] as! String
//        self.encoding = request["encoding"] as! String.Encoding
        self.status = response["status"] as! Bool
        self.isList = response["isList"] as! Bool
        self.isObject = response["isObject"] as! Bool
        self.code = response["code"] as! Int
        self.err = response["err"] as! String
        self.data = response["data"] as? [AnyObject]
        self.info = response["info"] as? [String:AnyObject]
    }
    
    private func jsonToString(json: AnyObject)->String{
        
        do {
            guard ((json as? NSNull)  == nil ) else{
                return ""
            }
            
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString!
        } catch let myJSONError {
            print(myJSONError)
            return ""
        }
    }
}
