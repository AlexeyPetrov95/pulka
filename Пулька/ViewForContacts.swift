
import Foundation
import UIKit

class drawCircleForContact: UIView {
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let componets: [CGFloat] =  [0.0, 0.0, 0.0, 0.0]
        _ = CGColorCreate(colorSpace, componets)
        
        let width = self.frame.size.width - 2
        let height:CGFloat = 0.0
        
        CGContextMoveToPoint(context, 0, height)
        CGContextAddLineToPoint(context, width, height)
        CGContextStrokePath(context)
    }
    
}