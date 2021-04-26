//
//  File.swift
//
//
//  Created by Guilherme Souza on 25/04/21.
//

import ApiClient
import Foundation
import Models

final class ShowDetailViewModel {

  private let show: Show

  init(show: Show) {
    self.show = show
  }

  struct ShowDetail {
    let posterURL: URL?
    let name: String
    let genres: [String]?
    let scheduleItems: [ScheduleItem]?
    let summary: String?

    struct ScheduleItem {
      let day: String
      let time: String
      let isHighlighted: Bool
    }
  }

  func loadDetail() -> ShowDetail {
    let items = show.schedule.map { schedule -> [ShowDetail.ScheduleItem] in
      let allWeekDays = Calendar.current.standaloneWeekdaySymbols
      let shortWeekDays = Calendar.current.shortStandaloneWeekdaySymbols

      return zip(allWeekDays, shortWeekDays).map { weekDay, shortWeekDay in
        ShowDetail.ScheduleItem(
          day: shortWeekDay,
          time: schedule.time,
          isHighlighted: schedule.days.contains(weekDay)
        )
      }
    }

    return ShowDetail(
      posterURL: show.image?.original,
      name: show.name,
      genres: show.genres,
      scheduleItems: items,
      summary: show.summary
    )
  }
}
