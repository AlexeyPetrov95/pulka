import Foundation
import CoreData
import UIKit



class AccessToDB {
    
    static let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    static var dataRequest = [AnyObject]()
    
    static func saveDataToTables (entity: String, attributes:[String:AnyObject]) -> Bool{                 // через throw!!! удобнее
        var requestPredicate = false
        let request = NSFetchRequest(entityName: entity)
        
        switch entity {
        case "TABLES":
            request.predicate = NSPredicate(format: "name == %@", attributes["name"] as! String)
            requestPredicate = true
            break
        case "HISTORY":
            break
        case "FAVORITE_TABLES":
            request.predicate = NSPredicate(format: "table_id == %@", attributes["table_id"] as! String)
            requestPredicate = true
            break
        case "DISHES":
            break
        case "CONTACTS_TABLES":
            requestPredicate = false
            break
        default:
            break
        }
        
        do {
            try dataRequest = self.context.executeFetchRequest(request)
            if dataRequest.count >= 1 && requestPredicate { return  false }
        } catch {
            print("something wrong")
        }
        
        let saveData = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: context)
        let id = NSManagedObjectIDToString(saveData.objectID)
        for attribute in attributes {
            saveData.setValue(attribute.1 , forKey: attribute.0)
        }
        saveData.setValue(id, forKey: "id")
        do {
            try context.save()
            dataRequest = []
            return true
        } catch {
            print("something wrong")
            dataRequest = []
            return false
        }
    }
    
    static func loadData (entity: String) -> [AnyObject]{
        let request = NSFetchRequest(entityName: entity)
       // var dataRequest:[AnyObject] = []
        do {
            try dataRequest = context.executeFetchRequest(request)
        } catch {
            return dataRequest
        }
        return dataRequest
    }
    
    static func loadData(entity: String, predicate: String, value:String) -> [AnyObject]{
        let request = NSFetchRequest(entityName: entity)
      //  var dataRequest:[AnyObject] = []
        request.predicate = NSPredicate(format: predicate, value)
        do {
            try dataRequest = context.executeFetchRequest(request)
        } catch {
            print ("faild")
        }
        return dataRequest
    }
    
    static func loadData (entity: String, predicate: String, value: [String]) -> [AnyObject]{
        let request = NSFetchRequest(entityName: entity)
     //   var dataRequest:[AnyObject] = []
        request.predicate = NSPredicate(format: predicate, argumentArray: value)
        do {
            try dataRequest = context.executeFetchRequest(request)
        } catch {
            
        }
        return dataRequest
    }
    
    static func printData (entity:String, atributes:String...) {
        let request = NSFetchRequest(entityName: entity)
    //    var dataRequest:[AnyObject] = []
        do {
            try dataRequest = context.executeFetchRequest(request)
        } catch {
            
        }
        for data in dataRequest{
            for attribute in atributes {
                print ("\(entity) \t\t  \(attribute) ===== \(data.valueForKey(attribute))")
            }
            print ("\n")
        }
    }
    
    static func findDataID(entity: String, value: AnyObject, attribute:String) -> String{
        let request = NSFetchRequest(entityName: entity)
        var findDataObject:String = ""
       // var dataRequest:[AnyObject] = []
        
        do {
            try dataRequest = context.executeFetchRequest(request)
        } catch {
            print(":(")
        }
        
        for data in dataRequest {
            print (data.valueForKey(attribute))
            if data.valueForKey(attribute)! as! String == value as! String {
                findDataObject = data.valueForKey("id") as! String
            }
        }
        return findDataObject
    }
    
    static func NSManagedObjectIDToString (id: NSManagedObjectID) -> String {
        let instanseURL = id.URIRepresentation()
        let classURL = instanseURL.URLByDeletingLastPathComponent
        let instanseID = instanseURL.lastPathComponent
        let instanseTable = classURL?.lastPathComponent
        let id = instanseTable! + "/" + instanseID!
        return id
    }
    
    static func deleteItemInTable (entity:String, predicate:String, values:[String]) {
        var request = NSFetchRequest(entityName: entity)
        request.predicate = NSPredicate(format: predicate, argumentArray: values)
        do {
            try dataRequest = context.executeFetchRequest(request)
        } catch {
        }
        print (dataRequest.count)
        print("con_n: " + (dataRequest[0].valueForKey("name") as! String))
        print("con_i: " + (dataRequest[0].valueForKey("tables_id") as! String))
        print("con_phone: " + (dataRequest[0].valueForKey("contacts_iphone_id") as! String))
        

        context.deleteObject(dataRequest[0] as! NSManagedObject)
        do { // делать ли context.save?
            try context.save()
        } catch {
            print("something wrong")
        }


    }
    
    static func deleteTable(index:Int) {
 //       var data:[AnyObject] = []
        var id:String = String()
        
        var request = NSFetchRequest(entityName: "FAVORITE_TABLES")
        
        do {
            try dataRequest = self.context.executeFetchRequest(request)
            id = dataRequest[index].valueForKey("table_id") as! String
            context.deleteObject(dataRequest[index] as! NSManagedObject)
            print("fav: " + (dataRequest[index].valueForKey("table_id") as! String))
            do { // делать ли context.save?
                try context.save()
            } catch {
                print("something wrong")
            }
            
        } catch {
            print("in DELETE something is wrong")
        }
        
        request = NSFetchRequest(entityName: "TABLES")
        do {
            try dataRequest = self.context.executeFetchRequest(request)
            for table in dataRequest {                                                                                                       // надо бы в модель!!!
                if table.valueForKey("id") as! String == id {
                    context.deleteObject(table as! NSManagedObject)
                    print("tab: " + (table.valueForKey("id") as! String))
                }
            }
            do { // делать ли context.save?
                try context.save()
            } catch {
                print("something wrong")
            }
            
        } catch {
            print("in DELETE something is wrong")
        }
        
        request = NSFetchRequest(entityName: "CONTACTS_TABLES")
        do {
            try dataRequest = self.context.executeFetchRequest(request)
            for contact in dataRequest {                                                                                                       // надо бы в модель!!!
                if contact.valueForKey("tables_id") as! String == id {
                    context.deleteObject(contact as! NSManagedObject)
                    print("con_n: " + (contact.valueForKey("name") as! String))
                    print("con_i: " + (contact.valueForKey("tables_id") as! String))
                }
            }
            do { // делать ли context.save?
                try context.save()
            } catch {
                print("something wrong")
            }
        } catch {
            print("in DELETE something is wrong")
        }
    }
}