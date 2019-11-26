//
//  ConstantsHelp.swift
//  Alamofire
//
//  Created by topscommmac01_lixiaojin on 2019/5/28.
//

import Foundation
import UIKit

public class ConstantsHelp: NSObject {
    
    //当前设备屏幕宽度
    public static let SCREENWITH = UIScreen.main.bounds.width
    //当前设备屏幕的高度
    public static let SCREENHEIGHT = UIScreen.main.bounds.height
    
    public static let IPHONESMALLWIDTH:CGFloat = 320 //iphone较小宽度
    public static let IPHONEMIDDLEWIDTH:CGFloat = 375 //iphone中间宽度
    public static let IPHONEBIGWIDTH:CGFloat = 414 //iphoneo较大宽度
    
    //用户名和密码输入框高度
    public static let textFieldLoginHeight = 45
    public static let textFieldHeight = 35
    public static let detailInfoHieght = 25
    
    
    //较小字体大小
    public static let smallerFontSize:CGFloat = 12
    //较小字体大小
    public static let littleFontSize:CGFloat = 15
    //较大字体大小
    public static let smallFontSize:CGFloat = 17
    //普通字体大小
    public static let normalFontSize:CGFloat = 19
    //较大大字体大小
    public static let largeFontSize:CGFloat = 25
    //行间距
    public static let lineSpaceNormal = 8
    //内边距
    public static let normalPadding = 10
    //较小内边距
    public static let littlePadding = 5
    //较大内边距
    public static let largePadding = 15
    //label高度
    public static let labelHeight = 35
    //较小label高度
    public static let middleLabelHeight = 25;
    //文本框
    public static let uiTextFieldHeight = 35
    //较大文本框
    public static let uiTextFieldBigHeight = 70
    //title高度
    public static let titleHeight = 35
    //较小Label高度
    public static let littleLabelHeight = 20
    //视图顶部边距
    public static let topMargin = 10
    //视图左边距
    public static let leftMargin = 10
    //视图右边距
    public static let rightMargin = -10
    //左侧标签宽度,六个字左右宽度
    public static let leftTitleWidth = 110
    //左侧较小标签宽度,四个字左右宽度
    public static let leftTitleSmallWidth = 70
    //左侧必填标签宽度,四个字左右宽度
    public static let leftTitleNotNullWidth = 80
    //按钮高度
    public static let buttonHeight = 35
    //item 每行高度
    public static let itemRowHeight = 35
    
}


//网络响应数据参数名称
extension ConstantsHelp{
    public static let actionReuslt:String = "actionResult"
    public static let message:String = "message"
    public static let success:String = "success"
    public static let timeout:String = "timeout"
    public static let dataMap:String = "dataMap"
    public static let mobile:String = "mobile"
    public static let loginName:String = "LoginName"
    public static let uuid: String = "uuid"
    public static let dataList:String = "dataList"
    public static let listDataMap:String = "listDataMap"
}

//颜色部分
extension ConstantsHelp {
    public static let backgroundCGColor:CGColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public static let borderCGColor:CGColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    public static let fontNormalCGColor:CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    public static let mainCGColor:CGColor = CGColor.CGColorFromRGB(rgbValue: 0x058bd6)
    public static let deepBackgroundCGColor:CGColor = CGColor.CGColorFromRGB(rgbValue: 0xbbbbbb)
    public static let lightBackgroundCGColor:CGColor = CGColor.CGColorFromRGB(rgbValue: 0xEEEEEE)
    public static let normalBackgroundCGColor:CGColor = CGColor.CGColorFromRGB(rgbValue: 0xF6F6F6)
    public static let backgroundUIColor:UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public static let buttonUIColor:UIColor = UIColor.colorWithHexString(hex:"#30AAFF")
    public static let borderUIColor:UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    public static let fontNormalUIColor:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    public static let fontGreyUIColor:UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    public static let fontItemLabelColor:UIColor = UIColor.colorWithHexString(hex: "#333333")
    public static let normalTableViewUIColor:UIColor = UIColor.colorWithHexString(hex:"#efeff4")
    public static let normalMainUIColor:UIColor = UIColor.colorWithHexString(hex:"#058bd6")
    public static let mainUIColor:UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    public static let normalBtnColor = UIColor.colorWithHexString(hex:"#30AAFF")
    public static let darkMainUIColor:UIColor = UIColor.colorWithHexString(hex:"#0683c9")
    public static let deepBackgroundUIColor:UIColor = UIColor.colorWithHexString(hex:"#bbbbbb")
    public static let lightBackgroundUIColor:UIColor = UIColor.colorWithHexString(hex:"#EEEEEE")
    public static let normalBackgroundUIColor:UIColor = UIColor.colorWithHexString(hex:"#F6F6F6")
    public static let normalTextUIColor:UIColor = UIColor.colorWithHexString(hex:"#696969")
    public static let stateUIColor:UIColor = UIColor.colorWithHexString(hex: "#009e49")
    public static let loginUIColor:UIColor = UIColor.colorWithHexString(hex: "#202020")
    public static let tintColor:UIColor = UIColor.colorWithHexString(hex: "#202020")
}

extension ConstantsHelp{
    //分页参数
    public static let pageTitle = "page"
    public static let rowsTitle = "rows"
    public static let rows = 20
    public static let sidxTitle = "sidx"
    public static let sordTitle = "sord"
    public static let stateTitle = "state"
    public static let indexAppTitle = "indexApp"
    public static let typeListTitle = "typeList"
    
    public static let asc = "asc"
    public static let desc = "desc"
    public static let sortcode = "sortcode"
    public static let approvalUserId = "approvalUserId"
    
    //审批状态
    public static let stateToDo = "1" //审核中，待办
    public static let stateAlreadyDo = "2,3,8" //通过，不通过，关闭
    public static let stateDenyDo = "9" // 退回
    
    //审批节点状态
    public static let openState = "0" //开立,未启动
    public static let approvingState = "1" //审核中
    public static let approveState = "2" //审批通过
    public static let disApproveState = "3" //审批不通过
    public static let submitState = "4" //已提交
    public static let closeState = "8" //关闭状态
    
    //单据状态
    public static let billOpenState = "0" //开立,未启动
    public static let billApproveState = "1" //审核中
    public static let billBackState = "2" // 退回
    public static let billEndState = "9" //已审核
    
    
    //页面状态
    public static let add = "add"
    public static let update = "update"
    
}


extension ConstantsHelp{
    //详情以及列表属性部分
    public static let unit = "unit"
    public static let color = "color"
    public static let money = "money"
    public static let isAllowNull = "isAllowNull"
    public static let isAllowZero = "isAllowZero"
    public static let no = "no"
    
    public static let bit = "bit"
    public static let extendSpace = "extendSpace" //空格 例子:2019-01-01 全天
    public static let extendBracket = "extendBracket" //中括号 例子:李四[001]
    public static let valuePlaceholder = "valuePlaceholder" //值默认值，如果值为空，显示该默认值
    
    public static let man = "人"
    public static let day = "天"
    public static let yuan = "元"
    public static let red = "#FF0000"
    public static let green = "#37562c"
    public static let yellow = "#FF8000"
    public static let dateType = "dateType"
    public static let type = "type" //日期类型
    public static let date = "date" //只保留日期 2019-01-01
    public static let time = "time" //保留到时间 2019-01-01 12:00:00
    public static let dateHour = "dateHour" //保留到日期小时 2019-01-01 12:00
    public static let hour = "hour" //保留小时分钟 12:00
    public static let second = "second" //保留秒 12:00:00
    public static let topsProColor = "topsProColor"
    
    //其余部分
    public static let crmCookie = "crmCookie"
    public static let OA = "OA"
    public static let CRM = "CRM"
    public static let ER = "ER"
    public static let approvalHistory = "approvalHistory"
    public static let applyHistory = "applyHistory"
    
    public static let attachmentList = "attachmentList"
    public static let mainTable = "mainTable"
    public static let lineTable = "lineTable"
    public static let lineTableOne = "lineTableOne"
    
    public static let imageStr =  ".JPG.PNG.GIF.JPEG.jpg.png.gif.jpeg.HEIC.heic.HEIF.heif"
    public static let key = "key"
    public static let value = "value"
    public static let disTitle = "disTitle"
    public static let title = "title"
    public static let code = "code"
    public static let image = "image"
    public static let lineTableKey = "lineTableKey"
    
    public static let cannotRead = ".zip.rar.exe" //暂时不支持在线预览文件类型
    public static let imageCount = 9 //图片预览时 超过该数以文字显示
    public static let fileTableViewCount = 0 //附件列表超过该数时 滚动条常在
    
    public static let dept = "dept" //部门
    public static let user = "人员" //人员
    public static let usercode = "usercode" //工号
}

extension ConstantsHelp{
    public enum UIViewType:String{
        case uitextField = "uitextField"
        case uibutton = "uibutton"
        case uitextview = "uitextview"
    }
}
