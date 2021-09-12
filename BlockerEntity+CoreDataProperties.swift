//
//  BlockerEntity+CoreDataProperties.swift
//  BlockersAlphaNoData
//
//  Created by ssj on 2021/09/11.
//
//

import Foundation
import CoreData


extension BlockerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlockerEntity> {
        return NSFetchRequest<BlockerEntity>(entityName: "BlockerEntity")
    }

    @NSManaged public var budget: Float
    @NSManaged public var earned: Float
    @NSManaged public var endDate: Date?
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var period: String?
    @NSManaged public var spent: Float
    @NSManaged public var startDate: Date?
    @NSManaged public var resetDay: Int16
    @NSManaged public var resetMonth: Int16
    @NSManaged public var resetWeekday: Int16
    @NSManaged public var histories: NSSet?
    @NSManaged public var image: ImageEntity
    
    // TODO: histories predicate로 spend & earn 가져오기
    var currentBudget: Float { // desc : 기간 내 남은 예산
        get {
            return budget + earned - spent
        }
    }
    
    var currentBudgetPerBudget: Float { // desc : 전체 예산에서 남은 예산이 차지하는 비율 (=HP)
        get {
            return self.currentBudget / self.budget
        }
    }
    
    var customCalendar: Calendar { // dese : Helping Property
        get {
            var calendar = Calendar.current
            calendar.locale = Locale.init(identifier: "ko_KR") //TODO: hard coding 제거
            calendar.timeZone = TimeZone.init(identifier: "Asia/Seoul")! //TODO: hard coding 제거
            return calendar
        }
    }
    
    var dDay: Int { // desc : 예산 종료까지 남은 일자
        get {

            let calendar = customCalendar
            let todayComponent = calendar.dateComponents([.year, .month, .day],
                                                         from: Date())
            
            let todayFullSet = calendar.date(bySettingHour: 23,
                                             minute: 59,
                                             second: 59,
                                             of: Date())! // D-0를 D-7로 만들기위해 시간 세팅
            
            var closestNextDate: Date?
            var output: Int?
            
            // 1. 주기성 예산
            if let period = self.period {
                if period == "weekly" {
                    // 1-1. 일주일 주기 예산
                    if self.resetWeekday != 0 {
                        closestNextDate = calendar.nextDate(after: todayFullSet,
                                                                matching: DateComponents(hour:23,
                                                                            minute: 59,
                                                                            second: 59,
                                                                            weekday: Int(self.resetWeekday)),
                                                                matchingPolicy: .previousTimePreservingSmallerComponents)
                    }
                } else if period == "monthly" {
                    // 1-2. 월 주기 예산
                    if self.resetDay != 0 {
                        closestNextDate = calendar.nextDate(after: todayFullSet,
                                                                matching: DateComponents(
                                                                    day: Int(self.resetDay),
                                                                    hour:23,
                                                                    minute: 59,
                                                                    second: 59
                                                                    ),
                                                                matchingPolicy: .previousTimePreservingSmallerComponents)
                    }
                } else if period == "yearly"{
                    // 1-3. 년 주기 예산
                    if (self.resetDay != 0) && (self.resetMonth != 0) {
                        closestNextDate = calendar.nextDate(after: todayFullSet,
                                                                matching: DateComponents(
                                                                    month: Int(self.resetMonth),
                                                                    day: Int(self.resetDay),
                                                                    hour:23,
                                                                    minute: 59,
                                                                    second: 59
                                                                    ),
                                                                matchingPolicy: .previousTimePreservingSmallerComponents)
                    }
                    
                }
                
                if let nextDate = closestNextDate {
                    let nextDayComp = calendar.dateComponents([.year, .month, .day], from: nextDate)
                    let offSet = calendar.dateComponents([.day],
                                                         from: DateComponents(
                                                            year:todayComponent.year,
                                                            month: todayComponent.month,
                                                            day: todayComponent.day
                                                         ),
                                                         to: DateComponents(
                                                            year:nextDayComp.year,
                                                          month:nextDayComp.month,
                                                          day:nextDayComp.day)
                    )
                    output=offSet.day
                }
            } else {
                // 2. 일회성 예산
                if let start = self.startDate, let end = self.endDate {
                    let startComp = calendar.dateComponents([.year, .month, .day], from: start)
                    
                    let endComp = calendar.dateComponents([.year, .month, .day], from: end)
                    
                    let offSet = calendar.dateComponents([.day],
                                                        from: DateComponents(
                                                           year:startComp.year,
                                                           month: startComp.month,
                                                           day: startComp.day
                                                        ),
                                                        to: DateComponents(
                                                           year: endComp.year,
                                                         month:endComp.month,
                                                         day:endComp.day)
                    )
                    
                    output = offSet.day
                }
            }
            
            return output ?? 0
        }
    }
    
    var dTime: Int { // desc : 예산 종료까지 남은 시간
        get {
            
            let maxHour = 24
            let calendar = customCalendar
            let currentHour = calendar.dateComponents([.hour], from: Date()).hour ?? maxHour
            
            
            return maxHour - currentHour
        }
    }
    
    var todayBudget: Float { // desc: 오늘 사용 가능한(남은) 예산 (temp: 예산이 음수인 경우는 그대로 출력)
        get {
            if self.currentBudget >= 0 {
                return self.currentBudget / Float(self.dDay == 0 ? 1 : self.dDay)
            } else {
                return self.currentBudget
            }
        }
    }
    
    
    

}

// MARK: Generated accessors for histories
extension BlockerEntity {

    @objc(addHistoriesObject:)
    @NSManaged public func addToHistories(_ value: HistoryEntity)

    @objc(removeHistoriesObject:)
    @NSManaged public func removeFromHistories(_ value: HistoryEntity)

    @objc(addHistories:)
    @NSManaged public func addToHistories(_ values: NSSet)

    @objc(removeHistories:)
    @NSManaged public func removeFromHistories(_ values: NSSet)

}

extension BlockerEntity : Identifiable {

}
