# CalendarDate

CalendarDate is a Swift type that represents a Date as year, month and day value:

```swift
let date = CalendarDate(year: 2018, month: 5, day: 3)
let today = CalendarDate.today
```

Formatting / parsing a ISO 8601 string ('yyyy-mm-dd'):

```swift
let string = date.description    // "2018-05-03"
let parsedDate = CalendarDate(string)
```

JSON coding:

```swift
JSONEncoder().encode(date)  // "2018-05-03"
```
