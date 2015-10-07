

import UIKit

class TableControllerSumOnTheTop: UIView {

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let componets: [CGFloat] =  [208.0, 208.0, 208.0, 1.0]
        _ = CGColorCreate(colorSpace, componets)
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        CGContextMoveToPoint(context, 0, height)
        CGContextAddLineToPoint(context, width, height)
        CGContextStrokePath(context)
    }


}
