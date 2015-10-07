
import Foundation
import CoreData


@objc(DISHES)
class DISHES: NSManagedObject {
    @NSManaged var contacts_tables_id: NSNumber
    @NSManaged var id: NSNumber
    @NSManaged var sum_dish: NSDecimalNumber
    @NSManaged var tables_id: NSNumber
    @NSManaged var id_contact_tables: CONTACTS_TABLES
    @NSManaged var id_tables: TABLES

}
