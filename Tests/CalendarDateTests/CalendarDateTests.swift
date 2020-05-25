// MIT License
//
// Copyright (c) 2020 Ralf Ebert
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

@testable import CalendarDate
import XCTest

final class CalendarDateTests: XCTestCase {

    func testStringConversion() {
        let date = CalendarDate(year: 2018, month: 5, day: 3)
        let str = "2018-05-03"
        XCTAssertEqual(date.description, str)
        XCTAssertEqual(CalendarDate(str), date)
    }

    @available(OSX 10.12, *)
    @available(iOS 10.0, *)
    func testDateConversion() {
        let calendarDate = CalendarDate(year: 2018, month: 5, day: 3)
        let date = calendarDate.date
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions = [.withFullDate, .withFullTime]
        formatter.formatOptions.remove(.withTimeZone)
        XCTAssertEqual(formatter.string(from: date), "2018-05-03T00:00:00")
        XCTAssertEqual(CalendarDate(date: date), calendarDate)
        XCTAssertEqual(CalendarDate(date: ISO8601DateFormatter().date(from: "2018-05-03T00:00:00Z")!), calendarDate)
    }

    func testJSONCoding() throws {
        let date = CalendarDate(year: 2018, month: 5, day: 3)

        let data = try JSONEncoder().encode(date)
        XCTAssertEqual(String(data: data, encoding: .utf8), "\"2018-05-03\"")

        let decodedDate = try JSONDecoder().decode(CalendarDate.self, from: data)
        XCTAssertEqual(date, decodedDate)
    }

    func testEquals() {
        let date = CalendarDate(year: 2018, month: 5, day: 3)
        XCTAssertEqual(date, date)
        XCTAssertNotEqual(date, CalendarDate(year: 2019, month: 5, day: 3))
        XCTAssertNotEqual(date, CalendarDate(year: 2018, month: 6, day: 3))
        XCTAssertNotEqual(date, CalendarDate(year: 2018, month: 5, day: 4))
    }

    func testToday() {
        let today = CalendarDate.today
        XCTAssertTrue(today.year > 2000)
    }

}
