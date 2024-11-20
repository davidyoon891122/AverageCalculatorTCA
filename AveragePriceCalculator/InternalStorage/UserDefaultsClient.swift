//
//  UserDefaultsClient.swift
//  AveragePriceCalculator
//
//  Created by Davidyoon on 11/20/24.
//

import Foundation
import ComposableArchitecture

struct UserDefaultsClient {
    
    var loadItems: @Sendable () -> [ItemModel]
    var saveItems: @Sendable ([ItemModel]) -> Void
    
    
}

extension UserDefaultsClient: DependencyKey {
    
    static var liveValue: UserDefaultsClient = .init(loadItems: {
        let userDefaultsManager = UserDefaultsManager()
        return userDefaultsManager.loadItems()
    }, saveItems: { items in
        let userDefaultsManager = UserDefaultsManager()
        userDefaultsManager.saveItems(items: items)
    })
    
}

extension DependencyValues {
    
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
    
}
