//
//  HomeViewModel.swift
//  FriTest
//
//  Created by Leo on 12/2/24.
//

import Foundation
import Combine
import OrderedCollections

public protocol HomeViewModelI: AnyObject {
    var mealsData: OrderedSet<MealAPI> { get set }
    var service: MealServiceAPI { get set }
    var fetchMealDataUseCase: FetchMealDataFromServiceUseCaseI { get set }
    var dataStatus: CurrentValueSubject<UiDataStatus, Never> { get set }
    var cancellabe: Set<AnyCancellable> { get set }
    
    func fetchData()
}

final class HomeViewModel: HomeViewModelI {
    var fetchMealDataUseCase: FetchMealDataFromServiceUseCaseI
    var mealsData: OrderedSet<MealAPI>
    var service: MealServiceAPI
    var dataStatus: CurrentValueSubject<UiDataStatus, Never>
    var cancellabe: Set<AnyCancellable>
    var serialQueue = DispatchQueue(label: "rakeshkusuma.serial.queue")
    
    public init(fetchMealDataUseCase: FetchMealDataFromServiceUseCaseI, mealsData: OrderedSet<MealAPI>, service: MealServiceAPI, dataStatus: CurrentValueSubject<UiDataStatus, Never>) {
        self.fetchMealDataUseCase = fetchMealDataUseCase
        self.mealsData = mealsData
        self.service = service
        self.dataStatus = dataStatus
        self.cancellabe = Set<AnyCancellable>()
    }
    
    public init() {
        self.service = MealServiceAPI()
        self.fetchMealDataUseCase = FetchMealDataFromServiceUseCase(self.service)
        self.mealsData = []
        self.dataStatus = CurrentValueSubject<UiDataStatus, Never>(.intialize)
        self.cancellabe = Set<AnyCancellable>()
    }
    
    func fetchData() {
        if dataStatus.value != .loading && mealsData.count < 20 {
            dataStatus.value = .loading
            
            fetchMealDataUseCase.execute()
                .receive(on: DispatchQueue.main, options: .none)
                .sink(receiveCompletion: { [weak self] status in
                    switch status {
                    case .finished:
                        if self?.mealsData.count == 20 {
                            self?.dataStatus.value = .success
                        } else {
                            self?.dataStatus.value = .refresh
                        }
                        
                        self?.fetchData()
                    case .failure(_):
                        self?.dataStatus.value = .error
                    }
                }, receiveValue: { [weak self] data in
                    guard let meal = data.meals.first else {
                        return
                    }
                    self?.mealsData.append(meal)
                }).store(in: &cancellabe)
        }
    }
}
