/**
*  Ink
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/

import XCTest
import Ink

final class ListTests: XCTestCase {
    func testOrderedList() {
        let html = MarkdownParser().html(from: """
        1. One
        2. Two
        """)

        XCTAssertEqual(html, #"<ol><li>One</li><li>Two</li></ol>"#)
    }
    
    func test10DigitOrderedList() {
        let html = MarkdownParser().html(from: """
        1234567890. Not a list
        """)

        XCTAssertEqual(html, "<p>1234567890. Not a list</p>")
    }
    
    func testOrderedListParentheses() {
        let html = MarkdownParser().html(from: """
        1) One
        2) Two
        """)

        XCTAssertEqual(html, #"<ol><li>One</li><li>Two</li></ol>"#)
    }

    func testOrderedListWithoutIncrementedNumbers() {
        let html = MarkdownParser().html(from: """
        1. One
        3. Two
        17. Three
        """)

        XCTAssertEqual(html, "<ol><li>One</li><li>Two</li><li>Three</li></ol>")
    }

    func testOrderedListWithInvalidNumbers() {
        let html = MarkdownParser().html(from: """
        1. One
        3!. Two
        17. Three
        """)

        XCTAssertEqual(html, "<ol><li>One 3!. Two</li><li>Three</li></ol>")
    }

    func testUnorderedList() {
        let html = MarkdownParser().html(from: """
        - One
        - Two
        - Three
        """)

        XCTAssertEqual(html, "<ul><li>One</li><li>Two</li><li>Three</li></ul>")
    }
    
    func testMixedUnorderedList() {
        let html = MarkdownParser().html(from: """
        - One
        * Two
        * Three
        - Four
        """)

        XCTAssertEqual(html, "<ul><li>One</li></ul><ul><li>Two</li><li>Three</li></ul><ul><li>Four</li></ul>")
    }
    
    func testMixedList() {
        let html = MarkdownParser().html(from: """
        1. One
        2. Two
        3) Three
        * Four
        """)
        
        XCTAssertEqual(html, #"<ol><li>One</li><li>Two</li></ol><ol start="3"><li>Three</li></ol><ul><li>Four</li></ul>"#)
    }

    func testUnorderedListWithMultiLineItem() {
        let html = MarkdownParser().html(from: """
        - One
        Some text
        - Two
        """)

        XCTAssertEqual(html, "<ul><li>One Some text</li><li>Two</li></ul>")
    }

    func testUnorderedListWithNestedList() {
        let html = MarkdownParser().html(from: """
        - A
        - B
            - B1
                - B11
            - B2
        """)

        let expectedComponents: [String] = [
            "<ul>",
                "<li>A</li>",
                "<li>B",
                    "<ul>",
                        "<li>B1",
                            "<ul>",
                                "<li>B11</li>",
                            "</ul>",
                        "</li>",
                        "<li>B2</li>",
                    "</ul>",
                "</li>",
            "</ul>"
        ]

        XCTAssertEqual(html, expectedComponents.joined())
    }

    func testUnorderedListWithNestedListWithTwoLevelsGap() {
        let html = MarkdownParser().html(from: """
        - A
        - B
            - B1
                - B11
        - C
        """)

        let expectedComponents: [String] = [
            "<ul>",
                "<li>A</li>",
                "<li>B",
                    "<ul>",
                        "<li>B1",
                            "<ul>",
                                "<li>B11</li>",
                            "</ul>",
                        "</li>",
                    "</ul>",
                "</li>",
                "<li>C</li>",
            "</ul>"
        ]

        XCTAssertEqual(html, expectedComponents.joined())
    }

    func testUnorderedListWithNestedListSnakeCase() {
           let html = MarkdownParser().html(from: """
           - A
               - A1
           - B
               - B1
           - C
               - C1
           """)

           let expectedComponents: [String] = [
               "<ul>",
                   "<li>A",
                       "<ul>",
                           "<li>A1</li>",
                       "</ul>",
                   "</li>",
                   "<li>B",
                       "<ul>",
                           "<li>B1</li>",
                       "</ul>",
                   "</li>",
                   "<li>C",
                       "<ul>",
                           "<li>C1</li>",
                       "</ul>",
                   "</li>",
               "</ul>"
           ]

           XCTAssertEqual(html, expectedComponents.joined())
       }

    func testUnorderedListWithFourLevelsNestedList() {
        let html = MarkdownParser().html(from: """
        - A
            - A1
                - A11
                    - A111
            - B1
                - B11
            - C1
                - C11
        """)

        let expectedComponents: [String] = [
            "<ul>",
                "<li>A",
                    "<ul>",
                        "<li>A1",
                            "<ul>",
                                "<li>A11",
                                    "<ul>",
                                        "<li>A111</li>",
                                    "</ul>",
                                "</li>",
                            "</ul>",
                        "</li>",
                        "<li>B1",
                            "<ul>",
                                "<li>B11</li>",
                            "</ul>",
                        "</li>",
                        "<li>C1",
                            "<ul>",
                                "<li>C11</li>",
                            "</ul>",
                        "</li>",
                    "</ul>",
                "</li>",
            "</ul>"
        ]

        XCTAssertEqual(html, expectedComponents.joined())
    }

    func testUnorderedListWithTripleGrowNestedList() {
        let html = MarkdownParser().html(from: """
        - A
            - A1
                - A11
                    - A111
                - A12
                    - A121
            - A2
                - A21
                    - A211
        """)

        let expectedComponents: [String] = [
            "<ul>",
                "<li>A",
                    "<ul>",
                        "<li>A1",
                            "<ul>",
                                "<li>A11",
                                    "<ul>",
                                        "<li>A111</li>",
                                    "</ul>",
                                "</li>",
                                "<li>A12",
                                    "<ul>",
                                        "<li>A121</li>",
                                    "</ul>",
                                "</li>",
                            "</ul>",
                        "</li>",
                        "<li>A2",
                            "<ul>",
                                "<li>A21",
                                    "<ul>",
                                        "<li>A211</li>",
                                    "</ul>",
                                "</li>",
                            "</ul>",
                        "</li>",
                    "</ul>",
                "</li>",
            "</ul>"
        ]

        XCTAssertEqual(html, expectedComponents.joined())
    }

    func testUnorderedListWithDoubleSymmetricGrowNestedList() {
        let html = MarkdownParser().html(from: """
        - A
            - A1
                - A11
                    - A111
                - A12
                    - A121
                - A13
            - A2
        - B
        """)

        let expectedComponents: [String] = [
            "<ul>",
                "<li>A",
                    "<ul>",
                        "<li>A1",
                            "<ul>",
                                "<li>A11",
                                    "<ul>",
                                        "<li>A111</li>",
                                    "</ul>",
                                "</li>",
                                "<li>A12",
                                    "<ul>",
                                        "<li>A121</li>",
                                    "</ul>",
                                "</li>",
                                "<li>A13</li>",
                            "</ul>",
                        "</li>",
                        "<li>A2</li>",
                    "</ul>",
                "</li>",
                "<li>B</li>",
            "</ul>"
        ]

        XCTAssertEqual(html, expectedComponents.joined())
    }

    func testUnorderedListWithInvalidMarker() {
        let html = MarkdownParser().html(from: """
        - One
        -Two
        - Three
        """)

        XCTAssertEqual(html, "<ul><li>One -Two</li><li>Three</li></ul>")
    }
}

extension ListTests {
    static var allTests: Linux.TestList<ListTests> {
        return [
            ("testOrderedList", testOrderedList),
            ("test10DigitOrderedList", test10DigitOrderedList),
            ("testOrderedListParentheses", testOrderedListParentheses),
            ("testOrderedListWithoutIncrementedNumbers", testOrderedListWithoutIncrementedNumbers),
            ("testOrderedListWithInvalidNumbers", testOrderedListWithInvalidNumbers),
            ("testUnorderedList", testUnorderedList),
            ("testMixedUnorderedList", testMixedUnorderedList),
            ("testMixedList", testMixedList),
            ("testUnorderedListWithMultiLineItem", testUnorderedListWithMultiLineItem),
            ("testUnorderedListWithNestedList", testUnorderedListWithNestedList),
            ("testUnorderedListWithNestedListSnakeCase", testUnorderedListWithNestedListSnakeCase),
            ("testUnorderedListWithNestedListWithTwoLevelsGap", testUnorderedListWithNestedListWithTwoLevelsGap),
            ("testUnorderedListWithFourLevelsNestedList", testUnorderedListWithFourLevelsNestedList),
            ("testUnorderedListWithTripleGrowNestedList", testUnorderedListWithTripleGrowNestedList),
            ("testUnorderedListWithDoubleSymmetricGrowNestedList", testUnorderedListWithDoubleSymmetricGrowNestedList),
            ("testUnorderedListWithInvalidMarker", testUnorderedListWithInvalidMarker)
        ]
    }
}
