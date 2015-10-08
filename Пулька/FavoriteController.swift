
import UIKit

class FirstViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var model = DataInFavoriteTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        model.data = []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.getDataFromFavoriteTables()
        return model.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteTableNames")
        let name = model.getNameForFavoriteTable(indexPath.row)
        cell?.textLabel?.text = name
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            model.deleteTable(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "favoriteDetail" {
            let viewController:FavoriteTableController = segue.destinationViewController as! FavoriteTableController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let tableId = model.data[(indexPath?.row)!].valueForKey("table_id") as! String
            viewController.tableID = tableId
            viewController.data = AccessToDB.loadData("CONTACTS_TABLES", predicate: "tables_id == %@", value: tableId)
            viewController.getData()
        }
    }
    
    @IBAction func addFavorite(sender: UIBarButtonItem) {
        var alert:UIAlertController! = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in textField.placeholder = "Стол" })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action) -> Void in alert = nil }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0].text!
            self.model.adddFavorite(textField)
            self.tableView.reloadData()
            alert = nil
        }))

        self.presentViewController(alert, animated: true, completion: nil)

    }
}

