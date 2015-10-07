
import UIKit
import AddressBookUI
import AddressBook
import QuartzCore


class TableController: UIViewController, ABPeoplePickerNavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    var accessToAddressBook = AddressBookAccess()
    var personPicker: ABPeoplePickerNavigationController
    var calc: CalculatorController? = nil
    
    @IBOutlet weak var buttonForDelete: UIButton!
    @IBOutlet var collection: UICollectionView!
    var arrayOfCells = [CollectionViewCellContact!]()
    var model = DataInTable()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        calc = storyboard?.instantiateViewControllerWithIdentifier("calc") as? CalculatorController
        self.addChildViewController(calc!)
        model.createFirstContact()
    }
    
    override func viewDidAppear(animated: Bool) {
        collection.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        deleteIsAlreadyDone(nil)
    }
    
    func addContact(sender:UIButton!) {
        if  accessToAddressBook.status == .Authorized {
            self.presentViewController(personPicker, animated: true, completion: nil)
        } else { accessToAddressBook.displayCantAddContactAlert(self) }
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
            model.appendNewContact(name, phone: phone, image: picTemp1)
            // кальклятор не забыть впилить!
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.getCountOfPerson() + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if model.getCountOfPerson() == indexPath.row {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("addCell", forIndexPath: indexPath) as! CollectionViewCellAddContact
            cell.customInit()
            cell.addButtonOutlet.addTarget(self, action: "addContact:", forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellContact", forIndexPath: indexPath) as! CollectionViewCellContact
            cell.customInit(self)
            arrayOfCells.append(cell)
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
            cell.addGestureRecognizer(longPressRecognizer)            

            let infoAboutContact = model.getInfoAboutContact(indexPath.row)
            cell.name.text = infoAboutContact.0
            cell.sum.text = SumFormatter.formatter.getRubleFormatt(infoAboutContact.2)
            cell.addButtonOutlet.setBackgroundImage(infoAboutContact.3, forState: UIControlState.Normal)
            
            cell.addButtonOutlet.layer.borderColor = UIColor(red: 84 / 255, green: 186 / 255, blue: 255 / 255, alpha: 1.0).CGColor
            cell.addButtonOutlet.tag = indexPath.row
            cell.deleteButton.tag = indexPath.row
            return cell
        }
    }
    
    func addContactSum(sender:UIButton!){
        calc?.indexPath = sender.tag
        calc?.controllerIndex = "singeltone"
        self.navigationController?.pushViewController(calc!, animated: true)
    }
    
    @IBAction func addToFavorite(sender: UIBarButtonItem) {
        var alert:UIAlertController! = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Стол"
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action) -> Void in // убрать клаву
            alert = nil
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0].text!
            self.model.addFavorite(textField)
            alert = nil
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    /// ****************************** не критично, но еще можно подумать выносить или нет *****************************
    func longPressed(sender: UILongPressGestureRecognizer) {
        for eachCell in arrayOfCells {
            eachCell.setAnimation(eachCell)
        }
        buttonForDelete.hidden = false
    }
    
    func deleteContact(sender: UIButton!) {
        let indexPath = sender.tag
        model.deleteContact(indexPath)
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
    /// *****************************************************************************************************************
    
    @IBAction func pay(sender: UIBarButtonItem) {
        
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

