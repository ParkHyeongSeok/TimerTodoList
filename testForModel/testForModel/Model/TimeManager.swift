//
//  TimeManager.swift
//  testForModel
//
//  Created by 박형석 on 2021/03/07.
//

import Foundation
import UIKit

class TimeManager {
    static let shared = TimeManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var times = [Time]()
    
    private func saveTime() {
        do {
            try context.save()
        }
        catch {
            print("-----> save error : \(error)")
        }
    }
    
    public func createTime(completionTime: Int64) {
        let newtime = Time(context: context)
        newtime.time = completionTime
        saveTime()
        readTimes()
    }
    
    public func readTimes() {
        do {
            times = try context.fetch(Time.fetchRequest())
        }
        catch {
            print("-----> Time FetchError : \(error)")
        }
    }
    
    public func deleteTime(time: Time) {
        context.delete(time)
        saveTime()
    }
    
    func secondToMinuteSecond(wholeSecond: Int) -> (Int, Int) {
        let minute = wholeSecond / 60
        let second = wholeSecond % 60
        return (minute, second)
    }
    
    func makeTimeString(minute: Int, second: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", minute)
        timeString += ":"
        timeString += String(format: "%02d", second)
        return timeString
    }
    
    
    
}
