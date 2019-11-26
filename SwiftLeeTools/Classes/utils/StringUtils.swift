//
//  StringUtils.swift
//  FBSnapshotTestCase
//
//  Created by topscommmac01_lixiaojin on 2019/5/27.
//

import Foundation
import QorumLogs

public class StringUtils: NSObject {
    //获取字符串的前N个字符串
   public class func getPrefixNStr(currentStr :String,length : Int) -> String {
        var strResult = ""
        if currentStr == "" || currentStr.count < length{
            strResult = currentStr
        }else {
          strResult = String(currentStr.prefix(length))
        }
        return strResult
    }
    
    //获取字符串的后N个字符串
   public class func getSuffixNStr(currentStr :String,length : Int) -> String {
        var strResult = ""
        if currentStr == "" || currentStr.count < length{
            strResult = currentStr
        }else {
            strResult = String(currentStr.suffix(length))
        }
        return strResult
    }
    
    //截取字符串,按开始、结束位截取
   public class func getIndexStr(currentStr:String,start:Int,end:Int) -> String {
        var str = ""
        if currentStr == "" || currentStr.count < end {
            str = currentStr
        }else{
            let startStr = currentStr.index(currentStr.startIndex, offsetBy: start)
            let endStr = currentStr.index(currentStr.startIndex, offsetBy: end)
            str = String(currentStr[startStr..<endStr])
        }
        return str
    }
    
   // 获取指定高度字符串宽度
  public class func getStrWidth(str:String,fontSize: CGFloat, height:CGFloat = ConstantsHelp.SCREENHEIGHT) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: str).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return rect.width
    }
    //获取指定宽度字符串高度
   public class func getStrHeight(str:String,fontSize: CGFloat, width:CGFloat = (ConstantsHelp.SCREENWITH - 20)) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: str).boundingRect(with:CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return rect.height
    }
    // 获取最后一个指定符号后面的信息
   public class func getSignBackStr(str:String,sign:String = "\\") -> String {
        var result = ""
        if str == "" || !str.contains(sign){
            result = str
        }else{
            let list = str.components(separatedBy: sign)
            result = String(list[list.count-1])
        }
        return result
    }
    
    // 获取第一个指定符号前面的信息
   public class func getSignFrontStr(str:String,sign:String = "(") -> String {
        var result = ""
        if str == "" || !str.contains(sign){
            result = str
        }else{
            let list = str.components(separatedBy: sign)
            result = String(list[0])
        }
        return result
    }
    
    //保留小数点后n位小数
   public class func decimalHold(_ Str:String,_ number:Int,_ isForce:Bool) -> String{
        var tempStr = ""
        if !isForce{
            if Str.contains("."){
                if Str.split(separator: ".")[1].count >= number{
                    tempStr = Str.split(separator: ".")[0] + "." + getPrefixNStr(currentStr: String(Str.split(separator: ".")[1]), length: number)
                }else{
                    tempStr = Str
                }
            }else{
                tempStr = Str
            }
        }else{
            if Str.contains("."){
                if Str.split(separator: ".")[1].count >= number{
                    tempStr = Str.split(separator: ".")[0] + "." + getPrefixNStr(currentStr: String(Str.split(separator: ".")[1]), length: number)
                }else{
                   let num = number - Str.split(separator: ".")[1].count
                    tempStr = Str
                    for _ in 1...num{
                      tempStr = tempStr + "0"
                    }
                }
            }else{
                tempStr = Str+"."
                for _ in 1...number{
                    tempStr = tempStr + "0"
                }
            }
        }
        return tempStr
    }
    
//    //字符串进行md5摘要加密
//    class func md5(_ strs:String) ->String{
//        let str = strs.cString(using: String.Encoding.utf8)
//        let strLen = CUnsignedInt(strs.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        CC_MD5(str!, strLen, result)
//        let hash = NSMutableString()
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        result.deinitialize(count: 1)
//        return String(format: hash as String)
//    }
    
    //字符串转字典
   public class func toDictionary(_ str:String) ->NSDictionary{
        let jsonData:Data = str.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
}

extension String{
    // 字符串转 CGFloat
   public func toCGFloat() -> CGFloat {
        var float:CGFloat = 0
        if VerifyHelp.isPurnFloat(string: self){
            let double = Double(self)
            if double != nil {
              float = CGFloat(double!)
            }
        }
        return float
    }
    
    //字符串转为html
   public func toNSAttributedString() ->NSAttributedString{
        var result:NSAttributedString = NSAttributedString.init(string: "")
        do{
            result = try NSAttributedString(data: self.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
           
        }catch let error as NSError {
            QL1(error)
            result = NSAttributedString.init(string: "")
        }
        return result
    }
    
    //设置字体颜色以及大小,变为富文本
   public func setFontAndColor(color:String = "#000000",fontSize:CGFloat = 17,needBold:Bool = false) ->NSMutableAttributedString{
        let attrString:NSMutableAttributedString = NSMutableAttributedString(string:self) //所有文字变为富文本
        let theRange = NSString(string: self).range(of: self)   //颜色处理的范围
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.colorWithHexString(hex: color), range: theRange)  //颜色处理
        if needBold{
            attrString.addAttribute(NSAttributedString.Key.font, value:UIFont.boldSystemFont(ofSize: fontSize), range: theRange)  //字体大小处理
        }else{
            attrString.addAttribute(NSAttributedString.Key.font, value:UIFont.systemFont(ofSize: fontSize), range: theRange)  //字体大小处理
        }
        return attrString
    }
    
    //正则表达式替换字符串
  public  mutating func raplaceRegex(pattern: String, replaceWith: String = "") {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return
        }
    }
    /// 字符串加倍
   public func multipleSplicing(multiple:Int)->String{
        var result = ""
        if !self.isEmpty{
            for _ in 1...multiple{
              result = result + self
            }
        }
        return result
    }
    
    /// 字符串判空
   public  var isContentEmpty:Bool{
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    ///字符串格式化指定日期字符串
   public func getFormatDate(type:DateFormateType)->String{
        var result = ""
        if self != ""{
            result = self.replacingOccurrences(of: "T", with: " ")
            if let tempResult =  DateUtils.dateStringToDate(dateStr: result,type:.YMDHMS){
                result = tempResult.formatDate(format:type)
            }else{
                result = ""
            }
        }
        return result
    }
    
    /// 打开url
   public func openAsUrl(backAlert:@escaping ()->Void){
        let url = NSURL(string:self)
        if let resultUrl = url,UIApplication.shared.canOpenURL(resultUrl as URL){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(resultUrl as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(resultUrl as URL)
            }
        }else {
            backAlert()
        }
    }

}


//富文本问题处理
extension String {
   public func attributedString() -> NSMutableAttributedString? {
        let value = self + "<br>"
        guard let data = value.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return nil }
        let options: [NSMutableAttributedString.DocumentReadingOptionKey : Any] = [
            NSMutableAttributedString.DocumentReadingOptionKey.characterEncoding : String.Encoding.utf8.rawValue,
            NSMutableAttributedString.DocumentReadingOptionKey.documentType : NSMutableAttributedString.DocumentType.html
        ]
        var htmlString = NSMutableAttributedString.init(string: "")
        
        do{
            htmlString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
        }catch let error as NSError {
            QL1(" \(error.domain) ")
            return NSMutableAttributedString.init(string: error.localizedFailureReason ?? "")
        }
        // 适配table不显示问题
        if htmlString.length > 0 {
            htmlString.addAttribute(NSMutableAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSMakeRange(0, 1))
        }
//        QL1("htmlString = \(htmlString)")
        return htmlString//?.attributedStringWithResizedImages(with: ConstantsHelp.SCREENWITH)
    }
}

///数字转大写
extension Double {
   public func numberRMM() -> String {
        return String(self).numberRMM()
    }
}

extension String {
    /// 人名币大写
   public func numberRMM() -> String {
        guard let num = Double(self) else {
            return ""
        }
        let format = NumberFormatter()
        format.locale = Locale(identifier: "zh_CN")
        format.numberStyle = .spellOut
        format.minimumIntegerDigits = 1
        format.minimumFractionDigits = 0
        format.maximumFractionDigits = 2
        let text = format.string(from: NSNumber(value: num)) ?? ""
        let sept = self.components(separatedBy: ".")
        let decimals: Double? = sept.count == 2 ? Double("0." + sept.last!) : nil
        return self.formatRMM(text: text, isInt: decimals == nil || decimals! < 0.01)
    }
    
    private func formatRMM(text: String, isInt: Bool) -> String {
        let formattedString = text.replacingOccurrences(of: "一", with: "壹")
            .replacingOccurrences(of: "二", with: "贰")
            .replacingOccurrences(of: "三", with: "叁")
            .replacingOccurrences(of: "四", with: "肆")
            .replacingOccurrences(of: "五", with: "伍")
            .replacingOccurrences(of: "六", with: "陆")
            .replacingOccurrences(of: "七", with: "柒")
            .replacingOccurrences(of: "八", with: "捌")
            .replacingOccurrences(of: "九", with: "玖")
            .replacingOccurrences(of: "十", with: "拾")
            .replacingOccurrences(of: "百", with: "佰")
            .replacingOccurrences(of: "千", with: "仟")
            .replacingOccurrences(of: "〇", with: "零")
        let sept = formattedString.components(separatedBy: "点")
        var intStr = sept[0]
        if sept.count > 0 && isInt {
            // 整数处理
            return intStr.appending("元整")
        } else {
            // 小数处理
            let decStr = sept[1]
            intStr = intStr.appending("元").appending("\(decStr.first!)角")
            if decStr.count > 1 {
                intStr = intStr.appending("\(decStr[decStr.index(decStr.startIndex, offsetBy: 1)])分")
            } else {
                intStr = intStr.appending("零分")
            }
            return intStr
        }
    }
}
