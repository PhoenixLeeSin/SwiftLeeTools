//
//  NotificationManager.swift
//  topsiOSPro
//  本地推送通知
//  Created by 李桂盛 on 2019/11/20.
//

import Foundation
import UserNotifications
import UIKit
import QorumLogs
import SwiftDate

/// 本地推送id前缀
public class NotificationIdPre:NSObject{
   public static let schedule = "schedule_"
}

/// 删除时选择删除范围
public enum NotificationState:String{
    case all //全部
    case unsent //未发送
    case sent //已发送
}

public class NotificationManager: NSObject {
    
   public static let sharedInstance = NotificationManager()
    
    /// 发送通知
    @available(iOS 10.0, *)
   public class func add(id:String,title:String,time:Date,subtitle:String="",body:String = "",badge:NSNumber? = nil,userInfo:[String:String] = [String:String]()){
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.default()
        if badge != nil{
            content.badge = badge
        }
        content.userInfo = userInfo
        let tempTime = DateComponents(year: time.year, month: time.month, day: time.day, hour: time.hour, minute: time.minute,second:time.second)
        //注意dateMatching这个参数不能直接使用time.dateComponents,会没有反应
        let trigger = UNCalendarNotificationTrigger(dateMatching:tempTime, repeats: false) //repeats:是否重复推送
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                QL1("Notification scheduled")
            } else {
                QL1("Error scheduling notification")
            }
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
             QL1(requests)
        }
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
             QL1(notifications)
        }
    }
    
    /// 更新，当id已经在通知中心里面存在了，则会自动刷新
    @available(iOS 10.0, *)
   public class func update(id:String,title:String,time:Date,subtitle:String="",body:String = "",badge:NSNumber? = nil,userInfo:[String:String] = [String:String]()){
        add(id: id, title: title, time: time, subtitle: subtitle, body: body, badge: badge, userInfo: userInfo)
    }
    
    /// 取消未发送、已发送的通知
    @available(iOS 10.0, *)
   public class func delete(ids:[String],state:NotificationState = .all){
        if state == .all{
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids) //未发送
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:ids) //已发送
        }else if state == .sent{
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:ids) //已发送
        }else if state == .unsent{
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids) //未发送
        }
    }
    /// 删除全部通知
    @available(iOS 10.0, *)
   public class func deleteAll(state:NotificationState = .all){
        if state == .all{
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests() //未发送
            UNUserNotificationCenter.current().removeAllDeliveredNotifications() //已发送
        }else if state == .sent{
             UNUserNotificationCenter.current().removeAllDeliveredNotifications() //已发送
        }else if state == .unsent{
             UNUserNotificationCenter.current().removeAllPendingNotificationRequests() //未发送
        }
    }
    
    /// 请求权限
    @available(iOS 10.0, *)
   public class func requestAuthorization(completion: ((_ granted: Bool)->())? = nil) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            QL1(granted)
            if granted {
                completion?(true)
            } else {
                center.getNotificationSettings(completionHandler: { settings in
                    if settings.authorizationStatus != .authorized {
                    }
                    if settings.lockScreenSetting != .enabled {
                    }
                    completion?(false)
                })
            }
        }
    }
    
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    /// 后台收到通知，用户点击通知后时调用
    @available(iOS 10.0, *)
   public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        QL1(response)
    }
    
    /// 前台收到通知，收到通知时调用
    @available(iOS 10.0, *)
   public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound]) //如果不想响应某一个通知，可以直接使用completionHandler([])进行屏蔽
       QL1(notification)
    }
}

