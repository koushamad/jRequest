//
//  justCashHandler.swift
//  Rad
//
//  Created by kousha ghodsizad on 7/25/18.
//  Copyright © 2018 kousha ghodsizad. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class justCashHandler: NSObject {
    
    private class func getConText()-> NSManagedObjectContext{
        let appDeligate = UIApplication.shared.delegate as! AppDelegate
        return appDeligate.persistentContainer.viewContext
    }
    
    class func saveObject(id : String , data : Data)->Bool{
        let contex = getConText()
        let entity = NSEntityDescription.entity(forEntityName: "Cash", in: contex)
        let manageObject = NSManagedObject.init(entity: entity!, insertInto: contex)
        manageObject.setValue(id, forKey: "id")
        manageObject.setValue(data, forKey: "binary")
        do{
            try contex.save()
            return true
        }catch{
            return false
        }
    }
    class func fetchObject() -> [Cash]?{
        let contex = getConText()
        var cash:[Cash]? = nil
        do{
            cash = try contex.fetch(Cash.fetchRequest())
            return cash
        }catch{
            return cash
        }
    }
    
    class func deleteObject(cash:Cash)->Bool{
        let conttext = getConText()
        conttext.delete(cash)
        do{
            try conttext.save()
            return true
        }catch{
            return false
        }
    }
    
    class func deleteAll()->Bool{
        let context = getConText()
        let delete = NSBatchDeleteRequest.init(fetchRequest: Cash.fetchRequest())
        do{
            try context.execute(delete)
            return true
        }catch{
            return false
        }
    }
    
    class func filterData(id:String)->[Cash]? {
        let context = getConText()
        let fetchRequest : NSFetchRequest<Cash> = Cash.fetchRequest()
        let predicate = NSPredicate.init(format: "id contains[c] %@", id)
        fetchRequest.predicate = predicate
        var cash : [Cash]? = nil
        do{
            cash = try context.fetch(fetchRequest)
            return cash
        }catch{
            return cash
        }
    }
}
