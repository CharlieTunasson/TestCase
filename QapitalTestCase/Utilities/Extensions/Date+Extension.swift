//
//  Date+Extension.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-19.
//

import Foundation

private let contentFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM yyyy"
    return formatter
}()

extension Date {
    static func -(lhs: Date, rhs: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -rhs, to: lhs)!
    }

    func contentFormatted() -> String {
        if Calendar.current.isDateInToday(self) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            return contentFormatter.string(from: self)
        }
    }
}


