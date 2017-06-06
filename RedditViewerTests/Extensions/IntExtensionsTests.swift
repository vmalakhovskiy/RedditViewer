//
//  IntExtensionsTests.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/5/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import XCTest
@testable import RedditViewer

class IntExtensionsTests: XCTestCase {
    func testFormatUsingAbbrevation_retursUnformattedStringWithNumber_ifNumberLessThanThouthand() {
        XCTAssertEqual("555", 555.formatUsingAbbrevation())
    }

    func testFormatUsingAbbrevation_retursFormattedStringWithKSuffix_ifNumberMoreThanThouthand() {
        XCTAssertEqual("1.6k", 1550.formatUsingAbbrevation())
        XCTAssertEqual("1.5k", 1540.formatUsingAbbrevation())
    }

    func testFormatUsingAbbrevation_retursFormattedStringWithMSuffix_ifNumberMoreThanMillion() {
        XCTAssertEqual("1.3m", 1_255_000.formatUsingAbbrevation())
        XCTAssertEqual("1.5m", 1_501_000.formatUsingAbbrevation())
    }

    func testFormatUsingAbbrevation_retursFormattedStringWithMSuffix_ifNumberMoreHundredOfThouthands() {
        XCTAssertEqual("0.9m", 888_000.formatUsingAbbrevation())
        XCTAssertEqual("0.1m", 100_000.formatUsingAbbrevation())
    }

    func testFormatUsingAbbrevation_retursFormattedStringWithMSuffix_ifNumberMoreThanBillion() {
        XCTAssertEqual("1.3b", 1_255_000_000.formatUsingAbbrevation())
        XCTAssertEqual("1.5b", 1_501_000_000.formatUsingAbbrevation())
    }

    func testFormatUsingAbbrevation_retursFormattedStringWithBSuffix_ifNumberMoreThanHundredOfMillions() {
        XCTAssertEqual("0.3b", 255_000_000.formatUsingAbbrevation())
        XCTAssertEqual("0.1b", 101_000_000.formatUsingAbbrevation())
    }

    func testFormatUsingAbbrevation_retursFormattedStringWithBSuffix_ifNumberMoreThanBillion() {
        XCTAssertEqual("255b", 255_000_000_000.formatUsingAbbrevation())
        XCTAssertEqual("101000b", 101_000_000_000_000.formatUsingAbbrevation())
    }
}
