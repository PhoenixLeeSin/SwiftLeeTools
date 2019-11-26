//
//  VerifyHelp.swift
//  FBSnapshotTestCase
//
//  Created by topscommmac01_lixiaojin on 2019/5/27.
//
import Foundation
import SwiftyJSON
import QorumLogs

public class VerifyHelp: NSObject {
    
    ///校验手机号码
    public class func isPhoneNumber(phoneNumber:String) -> Bool {
        if phoneNumber.count == 0 {
            return false
        }
        let mobile = "^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        return regexMobile.evaluate(with: phoneNumber)
    }
    
    ///校验身份证号
    public class func isIdNumber(idNumber:String) -> Bool {
        if idNumber.count == 0 {
            return false
        }
        let number = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let regexNumber = NSPredicate(format: "SELF MATCHES %@",number)
        return regexNumber.evaluate(with: idNumber)
    }
    
    ///校验正整数
    public class func isPositiveInteger(number:String) -> Bool {
        if number.count == 0 {
            return false
        }
        let integer = "^([1-9][0-9]*){1,3}$"
        let regex = NSPredicate(format: "SELF MATCHES %@",integer)
        return regex.evaluate(with: number)
    }
    
    ///校验车牌号
    public class func isCarNumber(number:String) -> Bool{
        var carString = ""
        if number.count == 0 {
            return false
        }
        else {
            if number.count == 7{ // 普通车牌
                carString  = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$"
            }
            else if number.count == 8{ //新能源车牌
                carString  = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}(([0-9]{5}[DF]$)|([DF][A-HJ-NP-Z0-9][0-9]{4}$))"
            }
        }
        let carPredicate = NSPredicate(format: "SELF MATCHES %@", carString)
        return carPredicate.evaluate(with: number)
    }
    ///校验邮箱
    public class func isEmail(email:String)-> Bool{
        if email.count == 0{
            return false
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    ///检查数据是否为空
    public class func isDataEmpty(json:JSON,key:String) -> Bool{
        var isEmpty = false
        if  json.dictionaryValue[key] != nil && json[key].stringValue != ""{
            isEmpty = true
        }
        return isEmpty
    }
    
    ///工号自动补全count位
    public class func completedByZero(str:String,count:Int) -> String{
        var result = ""
        if !str.isEmpty{
            if !isPurnFloat(string: str){
                result = str
            }else{
                if str.count == count{
                    result = str
                }else if str.count < count{
                    var tempStr = ""
                    for _ in 0...count - str.count - 1{
                        tempStr += "0"
                    }
                    result = tempStr + str
                }else{
                    let tempInt = Int(str)
                    result = (tempInt?.description)!
                }
            }
        }
        return result
    }
    
    ///数字保留位数
   public class func decimalFormat(_ decimal:String,_ number:String) -> String{
        QL1(decimal)
        var formatStr = ""
        if decimal != ""{
            if isPurnFloat(string: decimal){
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal  // 小数形式
                numberFormatter.minimumFractionDigits = 0 //设置小数点后最少位数
                numberFormatter.maximumFractionDigits = Int(number)!   //设置小数点后最多位数
                formatStr = numberFormatter.string(from:NumberFormatter().number(from:decimal)!)! //格式化
            }else{
                formatStr = decimal
            }
        }
        return formatStr
    }
    
    ///金额数据格式化 小数点后保留2-9位 带元字
    public class func moneyFormat(_ money:String) -> String{
        QL1(money)
        var formatMoney = ""
        if money != ""{
            if isPurnFloat(string: money){
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal  // 小数形式
                numberFormatter.usesGroupingSeparator = true //设置用组分隔
                numberFormatter.groupingSeparator = "," //分隔符号
                numberFormatter.groupingSize = 3  //分隔位数
                numberFormatter.minimumFractionDigits = 2 //设置小数点后最少位数
                numberFormatter.maximumFractionDigits = 9   //设置小数点后最多位数
                numberFormatter.positiveSuffix = "元" //后缀名
                if money.contains("+"){
                    formatMoney = "+" + numberFormatter.string(from:NumberFormatter().number(from:money.replacingOccurrences(of: "+", with: ""))!)! //格式化
                }else if money.contains("-"){
                    formatMoney = numberFormatter.string(from:NumberFormatter().number(from:money)!)! + "元"  //格式化
                }else{
                    formatMoney = numberFormatter.string(from:NumberFormatter().number(from:money)!)! //格式化
                }
            }else{
                formatMoney = money
            }
        }
        return formatMoney
    }
    
    ///判断是否为数字 包括小数 整数 负数等
    public class func isPurnFloat(string: String) -> Bool {
        let scan: Scanner = Scanner(string: string)
        var val:Float = 0
        return scan.scanFloat(&val) && scan.isAtEnd
    }
    
    ///富文本配置行间距以及首行缩进 若label设置字体大小，请在设置字体之后使用该方法
    public class func toAttribute(label:UILabel,string: String,lineSpace:Int,isIndent:Bool) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = CGFloat(lineSpace)
        if isIndent{
            style.firstLineHeadIndent = label.font.pointSize * 2
        }
        let attributes = [NSAttributedString.Key.paragraphStyle: style]
        return NSAttributedString(string:string, attributes: attributes)
    }
    
    ///检查文件尺寸大小
    public class func checkFileSize(fileSize:String)->Bool{
        var temp = false
        if !fileSize.isEmpty{
            var tempSize = fileSize.uppercased()
            if tempSize.contains("MB"){
                tempSize = tempSize.replacingOccurrences(of: "MB", with: "")
                if Double(tempSize) != nil,Double(tempSize)! <= 5.0{
                    temp = true
                }
            }else if tempSize.contains("KB"){
                tempSize = tempSize.replacingOccurrences(of: "KB", with: "")
                if Double(tempSize) != nil,Double(tempSize)! <= 5120.0{
                    temp = true
                }
            }
        }
        QL1("文件是否低于5M:\(temp)")
        return temp
    }
    
    ///检查文件尺寸大小
    public class func checkImageInfo(imageName:String)->Bool{
        var result = false
        if imageName != ""{
            let str = imageName.lowercased()
            if str.contains(".jpg") || str.contains(".jpeg") || str.contains(".png"){
                result = true
            }
        }
        return result
    }
}

