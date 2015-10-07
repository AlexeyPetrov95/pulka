import UIKit
import AddressBookUI
import AddressBook

class FavoriteTableController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ABPeoplePickerNavigationControllerDelegate {
    
    var accessToAddressBook = AddressBookAccess()
    let personPicker: ABPeoplePickerNavigationController
    var calc: CalculatorController? = nil
    var arrayOfCells = [CollectionViewCellContact!]()

    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var buttonForDelete: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    // для того чтобы не сохранять кадый раз сумму в бд!!! так как не нужна в БД скорее всего, но нужная для иинтерфейса

    
    
    var tableID = ""
    var data:[AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadDataInFavorite:", name: "ReloadDataInFavorite", object: nil)
        calc = storyboard?.instantiateViewControllerWithIdentifier("calc") as? CalculatorController
        //data = AccessToDB.loadData("CONTACTS_TABLES", predicate: "tables_id == %@", value: tableID)
       // self.getData()
    }
    
    override func viewDidAppear(animated: Bool) {
       //titleNavigation.title = titleString
    }

    override func viewDidDisappear(animated: Bool) {
        data = []
        deleteIsAlreadyDone(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openSettings(){                                                                                // повторяется нужно вынести!!!
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }

    func displayCantAddContactAlert() {                                                                 // тоже вынести в общий модуль!
        let cantAddContactAlert = UIAlertController(title: "Can't add Contact", message: "You must give the app permisson to add the contact first", preferredStyle: .Alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings", style: .Default, handler: { action  in self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
        presentViewController(cantAddContactAlert, animated: true, completion: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        personPicker = ABPeoplePickerNavigationController()
        super.init(coder: aDecoder)!
        personPicker.peoplePickerDelegate = self
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecordRef, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        if property == 3 {
            var infoAboutContact:Contacts? = Contacts()
            let index = Int(identifier) as CFIndex
            let name: String = ABRecordCopyCompositeName(person).takeRetainedValue() as String
            let phones: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeUnretainedValue() as ABMultiValueRef
            let phone: String = ABMultiValueCopyValueAtIndex(phones, index).takeRetainedValue() as! String
            
            let picTemp1 = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)
            if picTemp1 == nil{
                infoAboutContact?.imageContact = UIImage(named: "contact")
            } else {
                let picTemp2: NSObject? = Unmanaged<NSObject>.fromOpaque(picTemp1!.toOpaque()).takeRetainedValue()
                if picTemp2 != nil {
                    infoAboutContact!.imageContact = UIImage(data: picTemp2! as! NSData)!
                }
            }
            infoAboutContact?.name = name
            infoAboutContact?.phone = phone
            
            let matches = AccessToDB.loadData("CONTACTS_TABLES", predicate: "(tables_id == %@) AND (name == %@) AND (contacts_iphone_id == %@)", value: [tableID, name, phone])
            
            if matches.count == 0 {
                AccessToDB.saveDataToTables("CONTACTS_TABLES", attributes: ["name":infoAboutContact!.name, "contacts_iphone_id":infoAboutContact!.phone, "image": infoAboutContact!.imageContact!,
                    "tables_id": tableID])
                SingletoneArray.singletone.arrayForSum.append(infoAboutContact!)
                
                calc!.indexPath = SingletoneArray.singletone.arrayForSum.count - 1
                calc!.controllerIndex = "favorite"
                
                self.navigationController?.pushViewController(calc!, animated: true)
                collectionView.reloadData()
            }
             infoAboutContact = nil
        }
   }
    
    func getData (){
        SingletoneArray.singletone.arrayForSum = []
        for person in data {
            let personContact = Contacts()
            personContact.name = person.valueForKey("name") as! String
            personContact.phone = person.valueForKey("contacts_iphone_id") as! String
            SingletoneArray.singletone.arrayForSum.append(personContact)
         }
    }

    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data = AccessToDB.loadData("CONTACTS_TABLES", predicate: "tables_id == %@", value: tableID)
        return data.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if data.count == indexPath.row {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("addCell", forIndexPath: indexPath) as! CollectionViewCellAddContact
            cell.customInit()
            cell.addButtonOutlet.addTarget(self, action: "addContact:", forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellContact", forIndexPath: indexPath) as! CollectionViewCellContact
    
            cell.customInit(self)
            cell.addButtonOutlet.addTarget(self, action: "addSum:", forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.deleteButton.addTarget(self, action: "deleteContact:", forControlEvents: .TouchUpInside)
            arrayOfCells.append(cell)
            
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")        // тут?
            cell.addGestureRecognizer(longPressRecognizer)
            

            
            cell.name.text = data[indexPath.row].valueForKey("name") as? String
            cell.sum.text = SumFormatter.formatter.getRubleFormatt(SingletoneArray.singletone.arrayForSum[indexPath.row].getSumForContact())
            cell.addButtonOutlet.layer.borderColor = UIColor(red: 84 / 255, green: 186 / 255, blue: 255 / 255, alpha: 1.0).CGColor
            
            cell.addButtonOutlet.tag = indexPath.row
            cell.deleteButton.tag = indexPath.row
            
            cell.addButtonOutlet.setBackgroundImage(data[indexPath.row].valueForKey("image") as? UIImage, forState: UIControlState.Normal)
            return cell
        }
    }

    func addContact(sender:UIButton!) {
        if  accessToAddressBook.status == .Authorized {
            self.presentViewController(personPicker, animated: true, completion: nil)
        } else {
            self.displayCantAddContactAlert()
        }
    }
    
    func addSum (sender:UIButton){
        calc?.indexPath = sender.tag
        calc?.controllerIndex = "favorite"
        self.navigationController?.pushViewController(calc!, animated: true)
    }
    
    func reloadDataInFavorite(notification:NSNotification){
        collectionView.reloadData()
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        for eachCell in arrayOfCells {
            eachCell.setAnimation(eachCell)
        }
        buttonForDelete.hidden = false
    }
    
    func deleteContact(sender: UIButton!) {
        print (2)
        let indexPath = sender.tag
        print (indexPath)
        AccessToDB.deleteItemInTable("CONTACTS_TABLES", predicate: "(tables_id == %@) AND (name == %@) AND (contacts_iphone_id == %@)", values:[tableID, data[indexPath].valueForKey("name") as! String, data[indexPath].valueForKey("contacts_iphone_id") as! String])
        
     //   SingletoneArray.singletone.arrayOfConatcs.removeAtIndex(indexPath)
        collection.reloadData()
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
