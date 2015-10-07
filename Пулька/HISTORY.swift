
import Foundation
import CoreData

@objc(HISTORY)
class HISTORY: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var tables_id: NSNumber
    @NSManaged var time_payment: NSDate
    @NSManaged var id_tables: TABLES

}
