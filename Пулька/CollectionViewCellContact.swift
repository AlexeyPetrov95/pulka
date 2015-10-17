import UIKit

class CollectionViewCellContact: UICollectionViewCell {
    
    @IBOutlet var addButtonOutlet: UIButton!
    @IBOutlet var name: UILabel!
    @IBOutlet var sum: UILabel!    
    
    @IBOutlet weak var deleteButton: UIButton!

    
    func customInit (viewController: UIViewController){             //  небольшй костыль, надо бы сделать через обычный инит
        addButtonOutlet.layer.cornerRadius = self.addButtonOutlet.frame.height / 2
        addButtonOutlet.clipsToBounds = true
        deleteButton.layer.cornerRadius = self.deleteButton.frame.height / 2
        addButtonOutlet.addTarget(viewController, action: "addContactSum:", forControlEvents: .TouchUpInside)
        deleteButton.addTarget(viewController, action: "deleteContact:", forControlEvents: .TouchUpInside)
    }
    

    func setAnimation(cell: CollectionViewCellContact){
        let shackeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shackeAnimation.duration = 0.1
        shackeAnimation.autoreverses = true
        shackeAnimation.repeatCount = Float.infinity
        shackeAnimation.fromValue = 0.0
        shackeAnimation.toValue = 0.1
        shackeAnimation.fromValue = 0.1
        shackeAnimation.toValue =  -0.1
        cell.addButtonOutlet.layer.addAnimation(shackeAnimation, forKey: "transform.rotation")
        cell.deleteButton.layer.addAnimation(shackeAnimation, forKey: "transform.rotation")
        cell.deleteButton.hidden = false
    }

}
