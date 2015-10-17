
import UIKit

class CollectionViewCellAddContact: UICollectionViewCell {
    
    @IBOutlet var addButtonOutlet: UIButton!
    
   func customInit (){             //  небольшй костыль, надо бы сделать через обычный инит
        self.addButtonOutlet.layer.cornerRadius = self.addButtonOutlet.frame.height / 2
        self.addButtonOutlet.layer.borderWidth = 1
        self.addButtonOutlet.layer.borderColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1.0).CGColor
    }
}
