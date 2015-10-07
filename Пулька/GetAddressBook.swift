
import Foundation
import UIKit
import AddressBook
import AddressBookUI


class AddressBookAccess {
    
    var status = ABAddressBookGetAuthorizationStatus()
    
    lazy var addressBookRef: ABAddressBookRef = {
        var error: Unmanaged<CFError>?
        return ABAddressBookCreateWithOptions(nil,
            &error).takeRetainedValue() as ABAddressBookRef
        }()
    
    func getAccess () -> Bool {
        switch status {
        case .Denied, .Restricted:
            return false
        case .NotDetermined:
            promptAddressBookRequestAccess()
            return false
        case .Authorized:
            return true
        }
    }
    
    func promptAddressBookRequestAccess(){
        ABAddressBookRequestAccessWithCompletion(addressBookRef){
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()){
                if !granted {
                    self.status = .Denied
                } else {
                    self.status = .Authorized
                }
                self.getAccess()
            }
        }
    }
    
    func openSettings(){ // вынести
        let url = NSURL(string:UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func displayCantAddContactAlert(controller: UIViewController) {     // вынести
        let cantAddContactAlert = UIAlertController(title: "Can't add Contact", message: "You must give the app permisson to add the contact first", preferredStyle: .Alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings", style: .Default, handler: { action  in self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
        controller.presentViewController(cantAddContactAlert, animated: true, completion: nil)
    }


    
}