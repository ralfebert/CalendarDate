// MIT License
//
// Copyright (c) 2021 Ralf Ebert
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

/**
 CalendarDate is a Swift type that represents a Date as year, month and day value.
 Includes support for simple date calculations, formatting as a ISO 8601
 string ('yyyy-mm-dd') and JSON coding.

 Restriction: `CalendarDate` has no understanding of time zones. It is meant to be used
 in places where the time zone doesn't matter. It uses the logic of Foundation's Date
 to transform the current time into year/month/day based on TimeZone.current.
 */
public struct CalendarDate: Equatable, Hashable {
    public let year, month, day: Int

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    public init(date: Date) {
        let calendar = Calendar.current
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }

    public var date: Date {
        DateComponents(calendar: Calendar.current, year: self.year, month: self.month, day: self.day).date!
    }
}

extension CalendarDate: LosslessStringConvertible {
    public init?(_ description: String) {
        if let date = Self.formatter.date(from: description) {
            self.init(date: date)
        } else {
            return nil
        }
    }

    public var description: String {
        Self.formatter.string(from: self.date)
    }

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension CalendarDate: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        guard let value = CalendarDate(string) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Not a valid calendar date: \"\(string)\""
            )
        }

        self = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}

/// Date calculations
public extension CalendarDate {
    static var today: CalendarDate {
        CalendarDate(date: Date())
    }

    func adding(years: Int? = nil, months: Int? = nil, weeks: Int? = nil, days: Int? = nil) -> CalendarDate {
        let calendar = Calendar.current
        let components = DateComponents(year: years, month: months, day: days, weekOfYear: weeks)
        return CalendarDate(date: calendar.date(byAdding: components, to: self.date)!)
    }

    func daysTowards(date towardsDate: CalendarDate) -> Int {
        Calendar.current.dateComponents([.day], from: self.date, to: towardsDate.date).day!
    }

    static var yesterday: CalendarDate {
        self.today.adding(days: -1)
    }

    static var tomorrow: CalendarDate {
        self.today.adding(days: 1)
    }

    var isToday: Bool {
        self == CalendarDate.today
    }

    var isYesterday: Bool {
        self == CalendarDate.yesterday
    }

    var isTomorrow: Bool {
        self == CalendarDate.tomorrow
    }
}
