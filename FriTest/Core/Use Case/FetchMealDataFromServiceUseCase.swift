//
//  FetchMealDataFromServiceUseCase.swift
//  FriTest
//
//  Created by Leo on 12/2/24.
//

import Foundation
import Combine

public protocol FetchMealDataFromServiceUseCaseI: AnyObject {
    var service: MealServiceAPI { get set }
    func execute() -> AnyPublisher<HomeAPI, NetworkError>
}

final class FetchMealDataFromServiceUseCase: FetchMealDataFromServiceUseCaseI {
    var service: MealServiceAPI
    
    init(_ service: MealServiceAPI) {
        self.service = service
    }
    
    func execute() -> AnyPublisher<HomeAPI, NetworkError> {
        service.fetchHome()
    }
}
