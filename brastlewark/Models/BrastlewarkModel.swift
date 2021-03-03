//
//  BrastlewarkResponse.swift
//  brastlewark
//
//  Created by Alex Hernández on 25/02/2021.
//

import UIKit


// MARK: - BrastlewarkResponse
struct BrastlewarkResponse: Codable, Hashable {
    var brastlewark: [Brastlewark]?

    enum CodingKeys: String, CodingKey, Hashable {
        case brastlewark = "Brastlewark"
    }
}

// MARK: - Brastlewark
struct Brastlewark: Codable, Hashable {
    var id: Int?
    var name: String?
    var thumbnail: String?
    var age: Int?
    var weight, height: Double?
    var hairColor: HairColor?
    var professions: [Profession]?
    var friends: [String]?

    enum CodingKeys: String, CodingKey, Hashable {
        case id, name, thumbnail, age, weight, height, professions, friends
        case hairColor = "hair_color"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum HairColor: String, Codable, Hashable, CaseIterable {
    case black = "Black"
    case gray = "Gray"
    case green = "Green"
    case pink = "Pink"
    case red = "Red"
}

enum Profession: String, Codable, Hashable, CaseIterable {
    case baker = "Baker"
    case blacksmith = "Blacksmith"
    case brewer = "Brewer"
    case butcher = "Butcher"
    case carpenter = "Carpenter"
    case cook = "Cook"
    case farmer = "Farmer"
    case gemcutter = "Gemcutter"
    case leatherworker = "Leatherworker"
    case marbleCarver = "Marble Carver"
    case mason = "Mason"
    case mechanic = "Mechanic"
    case medic = "Medic"
    case metalworker = "Metalworker"
    case miner = "Miner"
    case potter = "Potter"
    case prospector = "Prospector"
    case sculptor = "Sculptor"
    case smelter = "Smelter"
    case stonecarver = "Stonecarver"
    case tailor = "Tailor"
    case taxInspector = "Tax inspector"
    case tinker = " Tinker"
    case woodcarver = "Woodcarver"
}

enum Section: String, CaseIterable {
    case professions = "Professions"
}
