//
//  justCash.swift
//  Rad
//
//  Created by kousha ghodsizad on 7/25/18.
//  Copyright © 2018 kousha ghodsizad. All rights reserved.
//

import Foundation

class justCash {
    
    public static var count : Int {
        get{
            let cashs : [Cash]? = justCashHandler.fetchObject()
            guard cashs != nil else {
                return 0
            }
            return (cashs?.count)!
        }
    }
    
    public func get(id:String , CB: @escaping (Data)->Void){
        let cashs : [Cash]? = justCashHandler.filterData(id: id)
        guard cashs != nil else{return}
        for cash in cashs! {
            if cash.id == id {
                CB(cash.binary!)
                return
            }
        }
    }
    
    public func set(id:String,data:Data, CB : @escaping (Bool)->Void){
        DispatchQueue.main.async {
            self.del(id: id) {
                let status : Bool = justCashHandler.saveObject(id: id, data: data)
                CB(status)
            }
        }
    }
    
    public func del(id:String , CB : @escaping ()->Void){
        DispatchQueue.main.async {
            let cashs : [Cash]? = justCashHandler.filterData(id: id)
            for cash in cashs! {
                _ = justCashHandler.deleteObject(cash: cash)
            }
            CB()
        }
    }
    
}
