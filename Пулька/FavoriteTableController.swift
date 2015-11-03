import UIKit
import AddressBookUI
import AddressBook

class FavoriteTableController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ABPeoplePickerNavigationControllerDelegate {
    
    var accessToAddressBook = AddressBookAccess()
    let personPicker: ABPeoplePickerNavigationController
    var calc: CalculatorController? = nil
    var edit: EditTableViewController? = nil
    
    @IBOutlet weak var buttonForDelete: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
  
    var tableID = ""
    var arrayOfCells = [CollectionViewCellContact!]()
    var model = ContactsOnTheTabel()

    @IBOutlet weak var paySum: UILabel!
    @IBOutlet weak var totalSum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadDataInFavorite:", name: "ReloadDataInFavorite", object: nil)
        calc = storyboard?.instantiateViewControllerWithIdentifier("calc") as? CalculatorController
        edit = storyboard?.instantiateViewControllerWithIdentifier("edit") as? EditTableViewController
        self.addChildViewController(calc!)
    }
    
    override func viewDidAppear(animated: Bool) {
       //titleNavigation.title = titleString
    }

    override func viewDidDisappear(animated: Bool) {
        model.data = []
        deleteIsAlreadyDone(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    required init(coder aDecoder: NSCoder) {
        personPicker = ABPeoplePickerNavigationController()
        super.init(coder: aDecoder)!
        personPicker.peoplePickerDelegate = self
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecordRef, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        if property == 3 {
            let index = Int(identifier) as CFIndex
            let name: String = ABRecordCopyCompositeName(person).takeRetainedValue() as String
            let phones: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeUnretainedValue() as ABMultiValueRef
            let phone: String = ABMultiValueCopyValueAtIndex(phones, index).takeRetainedValue() as! String
            let picTemp1 = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)
            
            model.appendNewContact(name, phone: phone, image: picTemp1, tableID: tableID)
            collectionView.reloadData()
            calc!.indexPath = model.contacts.count - 1
            calc?.controllerIndex = "favorite"
            calc!.modelDataContactsOnTheTabels = model
            self.navigationController?.pushViewController(calc!, animated: true)
        }
   }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.contacts.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if model.contacts.count == indexPath.row {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("addCell", forIndexPath: indexPath) as! CollectionViewCellAddContact
            cell.customInit()
            cell.addButtonOutlet.addTarget(self, action: "addContact:", forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellContact", forIndexPath: indexPath) as! CollectionViewCellContact
            cell.customInit(self)
            arrayOfCells.append(cell)
        
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")        // тут?
            cell.addGestureRecognizer(longPressRecognizer)
            
            cell.name.text = model.contacts[indexPath.row].name
            cell.sum.text = SumFormatter.formatter.getRubleFormatt(model.getTotalSumForPerson(indexPath.row))
            cell.addButtonOutlet.layer.borderColor = UIColor(red: 84 / 255, green: 186 / 255, blue: 255 / 255, alpha: 1.0).CGColor
            /// custom init
            cell.addButtonOutlet.tag = indexPath.row
            cell.deleteButton.tag = indexPath.row
            cell.editButton.tag = indexPath.row
            cell.addButtonOutlet.setBackgroundImage(model.contacts[indexPath.row].image, forState: UIControlState.Normal)
            return cell
        }
    }

    func addContact(sender:UIButton!) {
        if  accessToAddressBook.status == .Authorized {
            self.presentViewController(personPicker, animated: true, completion: nil)
        } else { self.accessToAddressBook.displayCantAddContactAlert(self) }
    }
    
    func addContactSum(sender:UIButton!){
        calc?.indexPath = sender.tag
        calc?.controllerIndex = "favorite"
        calc?.modelDataContactsOnTheTabels = model
        self.navigationController?.pushViewController(calc!, animated: true)
    }
    
    func reloadDataInFavorite(notification:NSNotification){
        collectionView.reloadData()
        let tupel = model.getTotalSumAndPaySum()
        totalSum.text = "\(tupel.0)"
        paySum.text = "\(tupel.1)"
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        for eachCell in arrayOfCells {
            for eachCell in arrayOfCells {
                eachCell.setAnimation(eachCell)
            }
        }
        buttonForDelete.hidden = false
    }
    
    func deleteContact(sender: UIButton!) {
        let indexPath = sender.tag
        model.deleteContact(indexPath, tableID: tableID)
        collectionView.reloadData()
    }
    
    func editContact (sender: UIButton!) {
        self.navigationController?.pushViewController(edit!, animated: true)
        edit?.row = sender.tag
        //edit?.model = model
       // edit?.getObjectType()

    }
    
    @IBAction func deleteIsAlreadyDone(sender: UIButton?) {
        for eachCell in arrayOfCells {
            eachCell.addButtonOutlet.layer.removeAllAnimations()
            eachCell.deleteButton.layer.removeAllAnimations()
            eachCell.deleteButton.hidden = true
        }
        buttonForDelete.hidden = true
    }


    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
