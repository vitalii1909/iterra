//
//  Extension + Date.swift
//  Iterra
//
//  Created by mikhey on 2023-10-27.
//

import Foundation

extension Date {
    func compareDay(with: Date) -> Bool {
        return self.get(.day) == with.get(.day) &&  self.get(.month) == with.get(.month) && self.get(.year) == with.get(.year)
    }
    
    func compareMinutes(with: Date) -> Bool {
        return self.get(.minute) == with.get(.minute) && self.get(.hour) == with.get(.hour) && self.get(.day) == with.get(.day) &&  self.get(.month) == with.get(.month) && self.get(.year) == with.get(.year)
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension Date {
   static var tomorrow:  Date { return Date().dayAfter }
   static var today: Date {return Date()}
   var dayAfter: Date {
      return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
   }
}


extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
    }
}
