import Foundation
import UIKit

struct Contact {
    var name: String
    var phone: String
    var sum: [Double]
    var image: UIImage!
}


class DataInTable {
    var contacts = [Contact]()
    
    func createFirstContact() {
        let image = UIImage(named: "contact")
        let me = Contact(name: "Я", phone: "", sum: [], image: image)
        contacts.append(me)
    }
    
    func appendNewContact(name: String, phone: String, image: Unmanaged<CFData>!) {
        let theSameContact = findTheSameContact(name, phone: phone)
        if !theSameContact {
            let imageForContact = convertImage(image)
            let newContact = Contact(name: name, phone: phone, sum: [], image: imageForContact)
            contacts.append(newContact)
        }
    }
    
    func findTheSameContact (name: String, phone: String) -> Bool {
        for person in contacts {
            if person.name == name && person.phone == phone { return true }
        }
        return false
    }
    
    func convertImage (image: Unmanaged<CFData>!) -> UIImage! {
        if image != nil {
            let picTemp2: NSObject? = Unmanaged<NSObject>.fromOpaque(image!.toOpaque()).takeRetainedValue()
            if picTemp2 != nil { return UIImage(data: picTemp2! as! NSData)! }
        }
        return UIImage(named: "contact")!
    }
    
    func getCountOfPerson() -> Int {
        return contacts.count
    }
    
    func getInfoAboutContact (index: Int) -> (String, String, Double, UIImage) {
        let sum = getSumForContact(index)
        return (contacts[index].name, contacts[index].phone, sum, contacts[index].image)
    }
    
    func getSumForContact (index: Int) -> Double {
        var totalSum: Double = 0
        let contact = contacts[index].sum
        for eachSum in contact {
            totalSum += eachSum
        }
        return totalSum
    }
    
    func deleteContact (index: Int) {
        contacts.removeAtIndex(index)
    }
    
    func addFavorite (tabelName: String){
        var permission = AccessToDB.saveDataToTables("TABLES", attributes: ["name":tabelName as String,"status": "Favorite", "sum_bill":0])
        if permission {
            let id = AccessToDB.findDataID("TABLES", value: tabelName, attribute: "name")
            permission = AccessToDB.saveDataToTables("FAVORITE_TABLES", attributes: ["table_id": id])
            if permission {
                for var i = 0; i < contacts.count; i++ {
                    let phone = contacts[i].phone
                    let name = contacts[i].name
                    let image = contacts[i].image!
                    AccessToDB.saveDataToTables("CONTACTS_TABLES", attributes: ["contacts_iphone_id": phone, "image":image, "name":name, "tables_id":id])
                }
            } else { AccessToDB.deleteItemInTable("TABLES", predicate: "table_id == @%", values: [id]) }
        }
    }
    
    func getTotalSumAndPaySum() -> (Double, Double) {
        var totalSum: Double = 0
        var paySum: Double = 0
        for person in contacts {
            for sum in person.sum {
                if person.name == "Я" { paySum += sum }
                else { totalSum += sum }
            }
        }
        paySum = totalSum - paySum
        return (totalSum, paySum)
    }
}

class ContactsOnTheTabel {
    var data = [AnyObject]()        // массив для получение из бд
    var contacts = [Contact]()      // массив для работы и вывода
    
    func appendNewContact(name: String, phone: String, image: Unmanaged<CFData>!, tableID: String) {
        let theSameContact = findTheSameContact(name, phone: phone, tableID: tableID)
        if !theSameContact {
            let imageForContact = convertImage(image)
            let newContact = Contact(name: name, phone: phone, sum: [], image: imageForContact)
             AccessToDB.saveDataToTables("CONTACTS_TABLES", attributes: ["name":name, "contacts_iphone_id": phone, "image": imageForContact, "tables_id": tableID])
            contacts.append(newContact)
        }
    }
    
    func findTheSameContact (name: String, phone: String, tableID: String) -> Bool {
        let matches = AccessToDB.loadData("CONTACTS_TABLES", predicate: "(tables_id == %@) AND (name == %@) AND (contacts_iphone_id == %@)", value: [tableID, name, phone])
        if matches.isEmpty { return false }
        else { return true }
    }
    
    func convertImage (image: Unmanaged<CFData>!) -> UIImage! {
        if image != nil {
            let picTemp2: NSObject? = Unmanaged<NSObject>.fromOpaque(image!.toOpaque()).takeRetainedValue()
            if picTemp2 != nil { return UIImage(data: picTemp2! as! NSData)! }
        }
        return UIImage(named: "contact")!
    }
    
    func setData (tableID: String) {
        contacts = []
        data =  AccessToDB.loadData("CONTACTS_TABLES", predicate: "tables_id == %@", value: tableID)
        for person in data {
            let name = person.valueForKey("name") as! String
            let phone = person.valueForKey("contacts_iphone_id") as! String
            let image = person.valueForKey("image") as! UIImage
            let personContact = Contact(name: name, phone: phone, sum: [], image: image)
            contacts.append(personContact)
        }
    }
    
    func getTotalSumForPerson (indexPath: Int) -> Double {
        var totalSum:Double = 0
        for sum in contacts[indexPath].sum {
            totalSum += sum
        }
        return totalSum
    }
    
    func deleteContact(indexPath: Int, tableID: String)  {
        AccessToDB.deleteItemInTable("CONTACTS_TABLES", predicate: "(tables_id == %@) AND (name == %@) AND (contacts_iphone_id == %@)", values:[tableID, contacts[indexPath].name as String, contacts[indexPath].phone
            as String])
        contacts.removeAtIndex(indexPath)
    }
    
    func getTotalSumAndPaySum() -> (Double, Double) {
        var totalSum: Double = 0
        var paySum: Double = 0
        for person in contacts {
            for sum in person.sum {
                if person.name == "Я" { paySum += sum }
                else { totalSum += sum }
            }
        }
        paySum = totalSum - paySum
        return (totalSum, paySum)
    }

}

class DataInFavoriteTable {
    var data = [AnyObject]()
    private var dataInTable = [AnyObject]()
    
    func getDataFromFavoriteTables () {
        data = AccessToDB.loadData("FAVORITE_TABLES")
    }
    
    func getNameForFavoriteTable (index: Int) -> String {
        var name: String = ""
        dataInTable = AccessToDB.loadData("TABLES")
        for table in dataInTable {
            if table.valueForKey("id") as! String == data[index].valueForKey("table_id") as! String {
                name = table.valueForKey("name") as! String
                return name
            }
        }
        return name
    }
    
    func deleteTable (index: Int) {
        data.removeAtIndex(index)
        AccessToDB.deleteTable(index)
    }

    func adddFavorite (name: String) {
        let checkMatches = AccessToDB.loadData("TABLES", predicate: "name == %@", value: name)
        if checkMatches.count == 0 {
            AccessToDB.saveDataToTables("TABLES", attributes: ["name": name, "status": "favorite"])
            let id = AccessToDB.findDataID("TABLES", value: name, attribute: "name")
            AccessToDB.saveDataToTables("FAVORITE_TABLES", attributes: ["table_id": id]) // check
           // if check {
            let image = UIImage(named: "contact")
            AccessToDB.saveDataToTables("CONTACTS_TABLES", attributes: ["contacts_iphone_id": "", "image":image!, "name":"Я", "tables_id":id])
            //}
        }

    }
}






