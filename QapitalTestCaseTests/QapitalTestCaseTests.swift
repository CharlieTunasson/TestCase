//
//  QapitalTestCaseTests.swift
//  QapitalTestCaseTests
//
//  Created by Charlie Tuna on 2021-03-20.
//

import XCTest
@testable import QapitalTestCase

class QapitalTestCaseTests: XCTestCase {

    private let rawString = "Daniel made a roundup."
    private let exampleStrongString = "<strong>Daniel</strong> made a roundup."
    private let exampleMultipleStrongString = "<strong>Daniel</strong> <strong>made a </strong>round<strong>up.</strong>"
    private let exampleWrongString = "<strong>Daniel</strong> made <strog>a</strong> round up."

    override func setUp() {
        super.setUp()
    }

    func testHtmlStringConversion() {
        XCTAssertTrue(exampleStrongString.htmlAttributed(font: UIFont.systemFont(ofSize: 12),
                                                         size: 12,
                                                         color: .black,
                                                         strongColor: .black)?.length == rawString.count)

        XCTAssertTrue(exampleMultipleStrongString.htmlAttributed(font: UIFont.systemFont(ofSize: 12),
                                                         size: 12,
                                                         color: .black,
                                                         strongColor: .black)?.length == rawString.count)
    }

    func testMessageTextTagAttributes() {
        XCTAssertTrue(exampleStrongString.attributedStringWithTags(attributes: [:],
                                                                   tagAttributes: ["strong": [.font: UIFont.systemFont(ofSize: 13)]])?.length == rawString.count)
        XCTAssertTrue(exampleMultipleStrongString.attributedStringWithTags(attributes: [:],
                                                                           tagAttributes: ["strong": [.font: UIFont.systemFont(ofSize: 13)]])?.length == rawString.count)
        XCTAssertFalse(exampleWrongString.attributedStringWithTags(attributes: [:],
                                                                 tagAttributes: ["strong": [.font: UIFont.systemFont(ofSize: 13)]])?.length == rawString.count)
    }

    func testActivityDateFormatter() {
        let activityRepository = ActivityRepository()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let exampleDate = "2021-03-17"

        let date = dateFormatter.date(from: exampleDate)!

        let formattedDateString = activityRepository.dateFormatter.string(from: date)
        let desiredDateString = "2021-03-17T00:00:00+00:00"
        XCTAssertTrue(formattedDateString == desiredDateString)
    }
}
