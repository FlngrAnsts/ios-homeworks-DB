//
//  Coordinator.swift
//  Documents
//
//  Created by Anastasiya on 29.07.2024.
//

import Foundation


protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] {get set}
}


extension Coordinator{
    func add(coordinator: Coordinator){
        childCoordinators.append(coordinator)
    }
    func remove(coordinator: Coordinator){
        childCoordinators = childCoordinators.filter{$0 !== coordinator}
    }
}
