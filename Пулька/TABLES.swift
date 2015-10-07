
import Foundation
import CoreData

@objc(TABLES)
class TABLES: NSManagedObject {
    @NSManaged var code: String
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var status: String
    @NSManaged var sum_bill: NSDecimalNumber
    @NSManaged var sum_compensation: NSDecimalNumber
    @NSManaged var tables_id_contacts_tables: NSSet
    @NSManaged var tables_id_dishes: NSSet
    @NSManaged var tables_id_favorite_tables: NSSet
    @NSManaged var tables_id_history: NSSet
}
