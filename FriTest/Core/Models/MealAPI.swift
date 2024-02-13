//
//  MealAPI.swift
//  FriTest
//
//  Created by Leo on 12/2/24.
//

import Foundation

public struct MealAPI: Codable, Hashable {
    public let id: String
    public let name: String
    public let category: String
    public let area: String
    public let thumbnail: String
    public let youtubeLink: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case thumbnail = "strMealThumb"
        case youtubeLink = "strYoutube"
    }
}
