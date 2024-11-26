//
//  UserDefaultsManager.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import Foundation

protocol UserDefaultsManagerProtocol {

    func loadItems() -> [ItemModel]
    func saveItems(items: [ItemModel])

}

final class UserDefaultsManager {

    private let userDefauls = UserDefaults.standard

}

extension UserDefaultsManager: UserDefaultsManagerProtocol {

    func loadItems() -> [ItemModel] {
        guard let data = self.userDefauls.object(forKey: Constant.items) as? Data,
              let itemModels = try? PropertyListDecoder().decode([ItemModel].self, from: data) else {
            return []
        }

        return itemModels
    }
    
    func saveItems(items: [ItemModel]) {
        let encodedData = try? PropertyListEncoder().encode(items)
        self.userDefauls.set(encodedData, forKey: Constant.items)
    }

}


private extension UserDefaultsManager {

    enum Constant {
        static let items: String = "Items"
        static let theme: String = "Theme"
    }

}
