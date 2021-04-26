//
//  File.swift
//
//
//  Created by Guilherme Souza on 25/04/21.
//

import Foundation

public struct Episode: Decodable, Hashable {

  public let season: Int
  public let number: Int
  //    public let airdate: Date
  public let name: String
  public let image: Image?
  public let summary: String?
}
