//
//  Constants.swift
//  brastlewark
//
//  Created by Alex Hernández on 25/02/2021.
//

import UIKit

struct Constants {
    static let baseURL = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
    static let mockData: String = "{\"Brastlewark\":[{\"id\":0,\"name\":\"Tobus Quickwhistle\",\"thumbnail\":\"http://www.publicdomainpictures.net/pictures/10000/nahled/thinking-monkey-11282237747K8xB.jpg\",\"age\":306,\"weight\":39.065952,\"height\":107.75835,\"hair_color\":\"Pink\",\"professions\":[\"Metalworker\",\"Woodcarver\",\"Stonecarver\",\" Tinker\",\"Tailor\",\"Potter\"],\"friends\":[\"Cogwitz Chillwidget\",\"Tinadette Chillbuster\"]}]}"

}

enum Images {
    static let logo = UIImage(systemName: "gamecontroller")
    static let logoFill = UIImage(systemName: "gamecontroller.fill")
    static let emptyStateLogo = UIImage(systemName: "slash.circle")
    static let placeholder = UIImage(systemName: "photo.on.rectangle")
    static let topRightIcon = UIImage(systemName: "repeat")
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale
    
    static let isiPhoneSE = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad = idiom == .pad && ScreenSize.maxLength >= 1024.0
    
    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
