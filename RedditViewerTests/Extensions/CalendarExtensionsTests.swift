//
//  CalendarExtensionsTests.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/5/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import XCTest
@testable import RedditViewer

class CalendarExtensionsTests: XCTestCase {
    func testTimeAgoSince_returnsJustNow_forcurrentDateBySubstracting() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting()), "Just now")
    }

    func testTimeAgoSince_returnsSecondsAgoValue_forDateEarlierThanMinuteAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(seconds: 40)), "40 seconds ago")
    }

    func testTimeAgoSince_returnsOneMinuteAgoValue_forDateEarlierThanTwoMinutesAgoButLaterThanOneMinuteAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(seconds: 90)), "A minute ago")
    }

    func testTimeAgoSince_returnsMinutesAgoValue_forDateEarlierThanOneHourAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(minutes: 5)), "5 minutes ago")
    }

    func testTimeAgoSince_returnsOneHourAgoValue_forDateEarlierThanTwoHoursAgoButLaterThanOneHourAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(minutes: 90)), "An hour ago")
    }

    func testTimeAgoSince_returnsHoursAgoValue_forDateEarlierThanADaysAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(hours: 5)), "5 hours ago")
    }

    func testTimeAgoSince_returnsYesterdayValue_forDateEarlierThanTwoDaysAgoButLaterThanOneDayAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(hours: 36)), "Yesterday")
    }

    func testTimeAgoSince_returnsDaysAgoValue_forDateEarlierThanAWeekAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(days: 5)), "5 days ago")
    }

    func testTimeAgoSince_returnsLastWeekValue_forDateEarlierThanTwoWeeksAgoButLaterThanOneWeekAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(days: 10)), "Last week")
    }

    func testTimeAgoSince_returnsWeeksAgoValue_forDateEarlierThanAMonthAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(weeks: 3)), "3 weeks ago")
    }

    func testTimeAgoSince_returnsLastMonthValue_forDateEarlierThanTwoMonthsAgoButLaterThanOneMonthAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(weeks: 6)), "Last month")
    }

    func testTimeAgoSince_returnsMonthsAgoValue_forDateEarlierThanAYearAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(months: 9)), "9 months ago")
    }

    func testTimeAgoSince_returnsLastYearValue_forDateEarlierThanTwoYearsAgoButLaterThanOneYearAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(months: 18)), "Last year")
    }

    func testTimeAgoSince_returnsYearsAgoValue_forDateEarlierThanTwoYearsAgo() {
        XCTAssertEqual(Calendar.current.timeAgo(since: currentDateBySubstracting(9)), "9 years ago")
    }

    private func currentDateBySubstracting(_ years: Int = 0, months: Int = 0, weeks: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var components = DateComponents()
        components.year = -years
        components.month = -months
        components.weekOfYear = -weeks
        components.day = -days
        components.hour = -hours
        components.minute = -minutes
        components.second = -seconds
        return Calendar.current.date(byAdding: components, to: Date())!
    }
}

