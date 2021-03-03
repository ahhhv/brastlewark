//
//  MockURLProtocol.swift
//  brastlewarkTVTests
//
//  Created by Alex Hernández on 27/02/2021.
//  Copyright © 2021 Alex Hernández. All rights reserved.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
