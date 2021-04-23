//
//  File.swift
//
//
//  Created by Guilherme Souza on 23/04/21.
//

import Foundation

public struct ShowSearch: Decodable {
  public let score: Double
  public let show: Show
}

public struct Show: Decodable {
  public let id: Int
  public let url: URL
  public let name: String
  public let type: String
  public let language: String
  public let genres: [String]
  public let status: String
  public let runtime: Int
  public let premiered: String
  public let officialSite: URL
  public let schedule: Schedule
}

public struct Schedule: Decodable {
  public let time: String
  public let days: [String]
}
