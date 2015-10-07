
import Foundation
import UIKit

class Contacts {
    var name: String = ""
    var phone: String = ""
    var sum = [Double]()
    var imageContact: UIImage?
    
    func getSumForContact() -> Double{
        var totalSum: Double = 0
        for eachSum in self.sum {
            totalSum += eachSum
        }
        return totalSum
    }
    
    func getNameMatches (name: String, phone: String) -> Bool {                                    // objectMathes !!! + не только singeltone!!!
        for eachName in SingletoneArray.singletone.arrayOfConatcs{
            if eachName.name == name && eachName.phone == phone {
                return true
            }
        }
        return false
    }
}

class Calculator {
    static var calc: CalculatorController? = nil
}

class SingletoneArray {
    var arrayOfConatcs = [Contacts]()
    var arrayForSum = [Contacts]()
    static let singletone = SingletoneArray()
}

class SumFormatter {
    func getRubleFormatt(sum: Double)-> String? {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "ru_RU")
        return formatter.stringFromNumber(sum)
    }
    static let formatter = SumFormatter()
}