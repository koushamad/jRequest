//
//  justQueueHandler.swift
//  Rad
//
//  Created by kousha ghodsizad on 7/25/18.
//  Copyright © 2018 kousha ghodsizad. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class justQueueHandler: NSObject {
    
    private class func getConText()-> NSManagedObjectContext{
        let appDeligate = UIApplication.shared.delegate as! AppDelegate
        return appDeligate.persistentContainer.viewContext
    }
    
    class func saveObject(id : String , data : Data , sending : Bool)->Bool{
        let contex = getConText()
        let entity = NSEntityDescription.entity(forEntityName: "Queue", in: contex)
        let manageObject = NSManagedObject.init(entity: entity!, insertInto: contex)
        manageObject.setValue(id, forKey: "id")
        manageObject.setValue(data, forKey: "binary")
        manageObject.setValue(sending, forKey: "sending")
        
        do{
            try contex.save()
            return true
        }catch{
            return false
        }
    }
    class func fetchObject() -> [Queue]?{
        let contex = getConText()
        var queue:[Queue]? = nil
        do{
            queue = try contex.fetch(Queue.fetchRequest())
            return queue
        }catch{
            return queue
        }
    }
    
    class func deleteObject(queue:Queue)->Bool{
        let conttext = getConText()
        conttext.delete(queue)
        do{
            try conttext.save()
            return true
        }catch{
            return false
        }
    }
    
    class func deleteAll()->Bool{
        let context = getConText()
        let delete = NSBatchDeleteRequest.init(fetchRequest: Queue.fetchRequest())
        do{
            try context.execute(delete)
            return true
        }catch{
            return false
        }
    }
    
    class func filterData(id:String)->[Queue]? {
        let context = getConText()
        let fetchRequest : NSFetchRequest<Queue> = Queue.fetchRequest()
        let predicate = NSPredicate.init(format: "id contains[c] %@", id)
        fetchRequest.predicate = predicate
        var queue : [Queue]? = nil
        do{
            queue = try context.fetch(fetchRequest)
            return queue
        }catch{
            return queue
        }
    }
}
