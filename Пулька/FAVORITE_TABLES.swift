
import Foundation
import CoreData

@objc(FAVORITE_TABLES)
class FAVORITE_TABLES: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var tables_id: NSNumber
    @NSManaged var id_tables: TABLES

}
