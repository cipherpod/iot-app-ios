//
//  Created by Sergei E. on 12/13/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import UIKit

class AMIDevicesListCellTickerBuilder: NSObject {    
    func attributize(text:NSString) {
        
    }
    
    public func tickers(with entity:AMIDeviceEntity, lineHeight:CGFloat, maxEntries:Int) -> [NSAttributedString] {
        let styleConstants = AMIStyleConstants.sharedInstance
        let tickerFont = styleConstants.masterViewCellTickerFont
        let tickerFontSize = tickerFont.pointSize
        var result:[NSAttributedString] = []
        
        if !entity.temp.isNaN {
            let entry = NSMutableAttributedString.init()
            let att = NSTextAttachment.init()
            att.image = UIImage.init(pdfNamed: "ic-sentortype-temp.pdf", atHeight:lineHeight)
            att.bounds = CGRect.init(x: 0, y: tickerFontSize - lineHeight + 2, uptoX: lineHeight, height: lineHeight)
            let attStr = NSMutableAttributedString.init(attachment: att)
            entry.append(attStr)
            entry.append(NSAttributedString.init(string: String(format: " %.0f°C", entity.temp)))
            entry.addAttributes([.font : styleConstants.masterViewCellTickerFont, .foregroundColor : styleConstants.dimmedTextColor, .baselineOffset: 0],
                                 range: NSRange.init(location: 0, length: entry.length))
            result.append(entry)
        }
        
        if !entity.pressure.isNaN {
            let entry = NSMutableAttributedString.init()
            let att = NSTextAttachment.init()
            att.image = UIImage.init(pdfNamed: "ic-sentortype-prsr.pdf", atHeight:lineHeight)
            att.bounds = CGRect.init(x: 0, y: tickerFontSize - lineHeight + 2, uptoX: lineHeight, height: lineHeight)
            let attStr = NSMutableAttributedString.init(attachment: att)
            entry.append(attStr)
            entry.append(NSAttributedString.init(string: String(format: " %.1fkPa", entity.pressure / 1000.0)))
            entry.addAttributes([.font : styleConstants.masterViewCellTickerFont, .foregroundColor : styleConstants.dimmedTextColor, .baselineOffset: 0],
                                range: NSRange.init(location: 0, length: entry.length))
            result.append(entry)
        }
        
        if !entity.humidity.isNaN {
            let entry = NSMutableAttributedString.init()
            let att = NSTextAttachment.init()
            att.image = UIImage.init(pdfNamed: "ic-sentortype-humi.pdf", atHeight:lineHeight)
            att.bounds = CGRect.init(x: 0, y: tickerFontSize - lineHeight + 2, uptoX: lineHeight, height: lineHeight)
            let attStr = NSMutableAttributedString.init(attachment: att)
            entry.append(attStr)
            entry.append(NSAttributedString.init(string: String(format: " %.0f%", entity.humidity * 100.0)))
            entry.addAttributes([.font : styleConstants.masterViewCellTickerFont, .foregroundColor : styleConstants.dimmedTextColor, .baselineOffset: 0],
                                range: NSRange.init(location: 0, length: entry.length))
            result.append(entry)
        }
        
        return result
    }

}
