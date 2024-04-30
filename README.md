# CalendarDate

CalendarDate is a Swift type that represents a Date as year, month and day value:

```swift
let date = CalendarDate(year: 2018, month: 5, day: 3)
let today = CalendarDate.today
```

Converting Foundation `Date` values (start of the day in TimeZone.current) from and to `CalendarDate`:

```swift
let today = CalendarDate(date: Date.now)
let date = today.date
```

Easy date calculations:

```swift
CalendarDate.today.adding(weeks: 3)
CalendarDate.today.adding(days: 3)

CalendarDate.today.daysTowards(date: CalendarDate.tomorrow) // returns 1

CalendarDate.tomorrow
CalendarDate.yesterday

date.isYesterday
date.isToday
date.isTomorrow
```

Formatting / parsing a ISO 8601 string ('YYYY-MM-DD'):

```swift
let string = date.description    // "2018-05-03"
let parsedDate = CalendarDate(string)
```

JSON coding:

```swift
JSONEncoder().encode(date)  // "2018-05-03"
```

