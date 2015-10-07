import Foundation
import UIKit

struct Contact {
    var name: String
    var phone: String
    var sum: [Double]
    var image: UIImage!
}

class DataInTable {
    var data = [Contact]()
    
    func createFirstContact() {
        let image = UIImage(named: "contact")
        let me = Contact(name: "Я", phone: "", sum: [], image: image)
        data.append(me)
    }
    
    func appendNewContact(name: String, phone: String, image: Unmanaged<CFData>!) {
        let theSameContact = findTheSameContact(name, phone: phone)
        if !theSameContact {
            let imageForContact = convertImage(image)
            let newContact = Contact(name: name, phone: phone, sum: [], image: imageForContact)
            data.append(newContact)
        }
    }
    
    func findTheSameContact (name: String, phone: String) -> Bool {
        for person in data {
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
        return data.count
    }
    
    func getInfoAboutContact (index: Int) -> (String, String, Double, UIImage) {
        let sum = getSumForContact(index)
        return (data[index].name, data[index].phone, sum, data[index].image)
    }
    
    func getSumForContact (index: Int) -> Double {
        var totalSum: Double = 0
        let contact = data[index].sum
        for eachSum in contact {
            totalSum += eachSum
        }
        return totalSum
    }
    
    func deleteContact (index: Int) {
        data.removeAtIndex(index)
    }
    
    func addFavorite (tabelName: String){
        var permission = AccessToDB.saveDataToTables("TABLES", attributes: ["name":tabelName as String,"status": "Favorite", "sum_bill":0])
        if permission {
            let id = AccessToDB.findDataID("TABLES", value: tabelName, attribute: "name")
            permission = AccessToDB.saveDataToTables("FAVORITE_TABLES", attributes: ["table_id": id])
            if permission {
                for var i = 0; i < data.count; i++ {
                    let phone = data[i].phone
                    let name = data[i].name
                    let image = data[i].image!
                    AccessToDB.saveDataToTables("CONTACTS_TABLES", attributes: ["contacts_iphone_id": phone, "image":image, "name":name, "tables_id":id])
                }
            } else {
                AccessToDB.deleteItemInTable("TABLES", predicate: "table_id == @%", values: [id])
            }

        }
    }
    
    
}