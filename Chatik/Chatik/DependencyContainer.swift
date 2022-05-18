//
//  DependencyContainer.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 21.04.2022.
//

import Foundation

protocol DependencyContainer {
    func getFirebase() -> FirebaseService
    func getCoreData() -> CoreDataService
}

class DependencyContainerProduction: DependencyContainer {
    let firebaseService = FirebaseServiceImp()
    let coreDataService = CoreDataServiceImp()
    
    func getCoreData() -> CoreDataService {
        return coreDataService
    }
    func  getFirebase() -> FirebaseService {
        return firebaseService
    }
}

class DependencyContainerSupplier {
    
    static let dependencyContainer: DependencyContainer = DependencyContainerProduction()
    
}
