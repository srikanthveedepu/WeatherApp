
import UIKit

extension UIFont {
    
    static func customFont(name fontName: String, size: UIFont.TextStyle) -> UIFont {
        
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: size)
        let pointSize = fontDescriptor.pointSize
        
        let scaledFont = (UIScreen.main.bounds.width / 375) * pointSize
        
        var customFontSize: CGFloat = scaledFont
        
        if size == .body && scaledFont < 17 {
            customFontSize = 17
        }
        else if size == .headline && scaledFont < 17 {
            customFontSize = 17
        }
        else if size == .subheadline && scaledFont < 15 {
            customFontSize = 15
        }
        else if size == .caption2 && scaledFont < 11 {
            customFontSize = 11
        }
        else if size == .caption1 && scaledFont < 12 {
            customFontSize = 12
        }
        else if size == .footnote && scaledFont < 13 {
            customFontSize = 13
        }
        else if size == .callout && scaledFont < 16 {
            customFontSize = 16
        }
        else if size == .title3 && scaledFont < 20 {
            customFontSize = 20
        }
        else if size == .title2 && scaledFont < 22 {
            customFontSize = 22
        }
        else if size == .title1 && scaledFont < 28 {
            customFontSize = 28
        }
        else if size == .largeTitle && scaledFont < 34 {
            customFontSize = 34
        }
        
        guard let customFont = UIFont(name: fontName, size: customFontSize) else {
            return UIFont.systemFont(ofSize: pointSize)
        }
        
        return UIFontMetrics.default.scaledFont(for: customFont)
    }
}
