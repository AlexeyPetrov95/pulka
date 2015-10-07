
import UIKit

class FirstViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var data:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        data = []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data = AccessToDB.loadData("FAVORITE_TABLES")
        return data.count 
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteTableNames")
        var name:String = ""
        let tablesData = AccessToDB.loadData("TABLES")
        for table in tablesData {                                                                                                       // надо бы в модель!!!
            if table.valueForKey("id") as! String == data[indexPath.row].valueForKey("table_id") as! String {
                name = table.valueForKey("name") as! String
            }
        }
        cell?.textLabel?.text = name
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
          //  удалить данные перед строкой tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            data.removeAtIndex(indexPath.row)
            AccessToDB.deleteTable(indexPath.row)
          //  data = AccessToDB.loadData("FAVORITE_TABLES")
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "favoriteDetail" {
            let viewController:FavoriteTableController = segue.destinationViewController as! FavoriteTableController
            let indexPath = self.tableView.indexPathForSelectedRow
            let tableId = self.data[(indexPath?.row)!].valueForKey("table_id") as! String
            viewController.tableID = tableId
            viewController.data = AccessToDB.loadData("CONTACTS_TABLES", predicate: "tables_id == %@", value: tableId)
            viewController.getData()
        }
    }
    
    @IBAction func addFavorite(sender: UIBarButtonItem) {
        var alert:UIAlertController! = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
             textField.placeholder = "Стол"
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action) -> Void in // убрать клаву
            
            alert = nil
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0].text!
            var checkMatches = AccessToDB.loadData("TABLES", predicate: "name == %@", value: textField)
            if checkMatches.count == 0 {
                AccessToDB.saveDataToTables("TABLES", attributes: ["name": textField, "status": "favorite"])
                let id = AccessToDB.findDataID("TABLES", value: textField, attribute: "name")
                let check = AccessToDB.saveDataToTables("FAVORITE_TABLES", attributes: ["table_id": id])
                if check {
                    let image = UIImage(named: "contact")
                     AccessToDB.saveDataToTables("CONTACTS_TABLES", attributes: ["contacts_iphone_id": "", "image":image!, "name":"Я", "tables_id":id])
                    self.tableView.reloadData()

                }
            }
            checkMatches = []
            alert = nil
        }))

        self.presentViewController(alert, animated: true, completion: nil)

    }
}

