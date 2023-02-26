//
//  Hedvig_HemuppgiftUITests.swift
//  Hedvig_HemuppgiftUITests
//
//  Created by Henrik Larsson on 2023-02-23.
//

import XCTest

extension XCTestCase {

  func wait(for duration: TimeInterval) {
    let waitExpectation = expectation(description: "Waiting")

    let when = DispatchTime.now() + duration
    DispatchQueue.main.asyncAfter(deadline: when) {
      waitExpectation.fulfill()
    }

    // We use a buffer here to avoid flakiness with Timer on CI
    waitForExpectations(timeout: duration + 0.5)
  }
}

class Hedvig_HemuppgiftUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchExistingUser() throws {

        let app = XCUIApplication()
        app.launch()

        let searchField = app.searchFields.firstMatch
    
       
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        
        wait(for: 5) 

        searchField.typeText("octocat")

        XCTAssertEqual(searchField.value as! String, "octocat")
        
        app.keyboards.buttons["Search"].tap()
        
        wait(for: 5)
        
        let numberOfListCells = app.cells.count
        XCTAssert(numberOfListCells > 3)

    }
    
    
    func testSearchNonExistentUser() throws {

        let app = XCUIApplication()
        app.launch()

        let searchField = app.searchFields.firstMatch
    
       
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        
        wait(for: 3)

        searchField.typeText("thisisauserthatdoesntexist")

        XCTAssertEqual(searchField.value as! String, "thisisauserthatdoesntexist")
        
        app.keyboards.buttons["Search"].tap()
        
        wait(for: 5)
        
        let numberOfListCells = app.cells.count
        XCTAssert(numberOfListCells == 1)

    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
