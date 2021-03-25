import UIKit

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont?, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        if let safeFont = font {
            let labelSize = myText.boundingRect(with: rect,
                                                options: .usesLineFragmentOrigin,
                                                attributes: [NSAttributedString.Key.font: safeFont],
                                                context: nil)
            return ceil(labelSize.width)
        }
        return ceil(0)
    }
}
