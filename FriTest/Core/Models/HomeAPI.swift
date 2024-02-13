//
//  HomeAPI.swift
//  FriTest
//
//  Created by Leo on 12/2/24.
//

import Foundation

public struct HomeAPI: Codable, Hashable {
    public let meals: [MealAPI]
    
    enum CodingKeys: String, CodingKey {
        case meals = "meals"
    }
}
