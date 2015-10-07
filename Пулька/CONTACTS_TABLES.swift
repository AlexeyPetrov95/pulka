
import Foundation
import CoreData

@objc(CONTACTS_TABLES)
class CONTACTS_TABLES: NSManagedObject {
    @NSManaged var contacts_iphone_id: NSNumber
    @NSManaged var id: NSNumber
    @NSManaged var tables_id: NSNumber
    @NSManaged var contact_table_id: NSSet
    @NSManaged var id_tables: TABLES

}
