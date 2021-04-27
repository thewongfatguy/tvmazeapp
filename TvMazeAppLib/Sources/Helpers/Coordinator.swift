//
//  File.swift
//
//
//  Created by Guilherme Souza on 27/04/21.
//

import Foundation

open class Coordinator {

  public let id = UUID()
  private(set) public var children: [UUID: Coordinator] = [:]

  private(set) public var didFinish: (() -> Void)!

  public init() {}

  private func store(_ coordinator: Coordinator) {
    children[coordinator.id] = coordinator
  }

  private func free(_ coordinatorId: UUID) {
    children[coordinatorId] = nil
  }

  public func coordinate(to coordinator: Coordinator) {
    store(coordinator)
    coordinator.didFinish = { [weak self, id = coordinator.id] in
      self?.free(id)
    }
    coordinator.start()
  }

  open func start() {}
}
