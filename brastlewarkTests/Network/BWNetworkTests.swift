//
//  AHVNetworkTests.swift
//  brastlewark
//
//  Created by Alex Hernández on 27/02/2021.
//

import XCTest
@testable import brastlewark

class BWNetworkTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWebService_WhenGivenSuccessfulResponse_ReturnsSuccess() {
        
        // Arrange
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        
        let jsonString = Constants.mockData
        
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        let sut = BWWebservice(urlString: Constants.baseURL,
                                urlSession: urlSession)
        
        let expectation = self.expectation(description: "Web Service Response Expectation")

        // Act
        sut.getList() { (resp, err) in
            
            // Assert
            if let shortName = resp?.filter({$0.id == 0}).first?.name {
                XCTAssertEqual(shortName, "Tobus Quickwhistle")
            }
            
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5)
    }
}
