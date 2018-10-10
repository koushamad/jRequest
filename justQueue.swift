//
//  justQueue.swift
//  Rad
//
//  Created by kousha ghodsizad on 7/25/18.
//  Copyright © 2018 kousha ghodsizad. All rights reserved.
//

import Foundation
import Just

class justQueue {
    
    var id : String
    public static var count : Int {
        get{
            let queues : [Queue]? = justQueueHandler.fetchObject()
            guard queues != nil else{
                return 0
            }
            return (queues?.count)!
        }
    }
    
    init(id:String) {
        self.id = id
    }
    
    public func add(request:justRequest ,CB:@escaping(Bool)->Void){
        self.set(id: request.id, data: request.binery, sending: request.sending, CB: { (status) in
            CB(status)
        })
    }
    
    public func sendAll ()->Void{
        let queues : [Queue]? = justQueueHandler.fetchObject()
            guard queues != nil else{return}
            var count : Int = 0
            var sended : Int = 0
            for queue in queues! {
            var request = createRequest(data: queue.binary!)
                request.debugMod = false
            self.set(id: request.id, data: request.binery, sending: true, CB: { (_) in
                count = count + 1
                request.hasQueue = false
                let Req = jRequest.init(request: request)
                Req.send { (Res) in
                    if Res.ok && Res.code > -7 {
                        self.del(id: Res.id, CB: {
                            sended = sended + 1
                        })
                    }else{
                        if Res.url == nil{
                            self.del(id: Res.id, CB: {
                                sended = sended + 1
                            })
                        }else{
                            self.set(id: request.id, data: request.binery, sending: false, CB: { (_) in
                                sended = sended + 1
                            })
                        }
                    }
                }

            })
        }
    }
    
    public func run(CB: @escaping (justResponce)->Void){
        let queues : [Queue]? = justQueueHandler.fetchObject()
        guard queues != nil else{return}
        var count : Int = 0
        var sended : Int = 0
        for queue in queues! {
            if !queue.sending{
                var request = createRequest(data: queue.binary!)
                self.set(id: request.id, data: request.binery, sending: true, CB: { (_) in
                    count = count + 1
                    request.hasQueue = false
                    let Req = jRequest.init(request: request)
                    Req.send { (Res) in
                        if Res.id == self.id {
                            self.del(id: Res.id, CB: {
                                sended = sended + 1
                                CB(Res)
                            })
                        }
                        if Res.ok {
                            self.del(id: Res.id, CB: {
                                sended = sended + 1
                            })
                        }else{
                            self.set(id: request.id, data: request.binery, sending: false, CB: { (_) in
                                sended = sended + 1
                            })
                        }
                    }
                })
            }
        }
    }
    public func remove(request:justRequest,CB:@escaping()->Void){
        self.del(id: request.id) {
            CB()
        }
    }
    private func get(id:String , CB: @escaping (Data)->Void){
        let queues : [Queue]? = justQueueHandler.filterData(id: id)
         guard queues != nil else{return}
        for queue in queues! {
            if queue.id == id {
                CB(queue.binary!)
                return
            }
        }
    }
    public func set(id:String,data:Data,sending:Bool, CB : @escaping (Bool)->Void){
        DispatchQueue.main.async {
            self.del(id: id) {
                let status : Bool = justQueueHandler.saveObject(id: id, data: data, sending:sending)
                CB(status)
            }
        }
    }
    public func del(id:String , CB : @escaping ()->Void){
        DispatchQueue.main.async {
            let queues : [Queue]? = justQueueHandler.filterData(id: id)
            for queue in queues! {
                _ = justQueueHandler.deleteObject(queue: queue)
            }
            CB()
        }
    }
    private func createRequest(data: Data)->justRequest{
        let info: Dictionary = (NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : AnyObject])
        let url = info["url"] as! String
        var Req = justRequest.init(url:url)
        Req.binery = data
        return Req
    }
}
