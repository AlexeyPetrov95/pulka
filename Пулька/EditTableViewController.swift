
import UIKit

class EditTableViewController: UITableViewController {
    
    var row: Int! = nil
    var model: ModelData! = nil
    var object: (DataInTable?, ContactsOnTheTabel?) = (nil, nil)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if object.0 != nil { return (object.0?.contacts[row].sum.count)! }
        else {return (object.1?.contacts[row].sum.count)!}
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Sum", forIndexPath: indexPath)
        if object.0 != nil{
            cell.textLabel?.text = SumFormatter.formatter.getRubleFormatt((object.0?.contacts[row].sum[indexPath.row])!)
        } else {
            cell.textLabel?.text = SumFormatter.formatter.getRubleFormatt((object.1?.contacts[row].sum[indexPath.row])!)
        }
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if object.0 != nil {
                object.0!.contacts[row].sum.removeAtIndex(indexPath.row)
                NSNotificationCenter.defaultCenter().postNotificationName("ReloadDataInTable", object: nil)
            }
            else {
                object.1!.contacts[row].sum.removeAtIndex(indexPath.row)
                NSNotificationCenter.defaultCenter().postNotificationName("ReloadDataInFavorite", object: nil)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
