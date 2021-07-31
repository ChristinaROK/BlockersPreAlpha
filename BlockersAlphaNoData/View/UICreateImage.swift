//
//  UIAddBlocker.swift
//  BlockersAlphaNoData
//
//  Created by ssj on 2021/06/05.
//

import SwiftUI

//TODO: 블로커 카드가 horizontal하게 움직이는 애니메이션 추가
struct UICreateImage: View {
    
    @EnvironmentObject var imageViewModel: ImageViewModel
    @State var blockerImage: String = ""
    
    var body: some View {
        
        VStack {
            CustomText(text: "예산을 지켜줄 블로커를 선택해 주세요", size: 22, weight: .semibold, design: .default, color: .black)
                .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color.green)
                    .padding(.vertical)
                    .frame(width: 380, height: 380)
                    .opacity(0.6)
                
                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack {
                        ForEach(imageViewModel.currentImages) { image in
                            Button(action: {
                                blockerImage = image.image
                            }, label: {
                                CustomAssetsImage(imageName: image.image, width: 210, height: 180, corner: 0)
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .padding(.horizontal, 60)
                                    .shadow(radius: 15)
                            })
                        }
                    }
                    .offset(x: 35)
                })
            }
            
            if blockerImage != "" {
                NavigationButton(destination: AnyView(UICreateName(blockerImage: $blockerImage)))
            }
            
        }
        .offset(y: -20)
    }
    
}


struct UICreateName: View {
    
    @Binding var blockerImage: String
    @State var blockerName = ""
    
    var body: some View {
        VStack {
            CustomText(text: "예산의 이름을 작성해주세요", size: 22, weight: .semibold, design: .default, color: .black)
                .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color.green)
                    .padding(.vertical)
                    .frame(width: 380, height: 380)
                    .opacity(0.6)
                
                VStack {
                    if blockerImage == "" {
                        CustomSFImage(imageName: "exclamationmark.triangle.fill", renderMode: .template, width: 98, height: 90, corner: 0, color: .orange)
                            .padding()
                    } else {
                        CustomAssetsImage(imageName: blockerImage, width: 150, height: 120, corner: 20)
                            .padding()
                    }
                    
                    TextField("예산 이름", text: $blockerName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
            }
            
            if blockerName.count>0 {
                NavigationButton(destination: AnyView(UICreateBudget(blockerImage: $blockerImage, blockerName: $blockerName)))
            }
            
            
        }
        .offset(y: -20)
    }
}

// TODO: customized keyboard 개발 (원 단위 수 자동 생성)
struct UICreateBudget: View {
    
    @Binding var blockerImage: String
    @Binding var blockerName: String
    @State var blockerAmount = ""
    
    
    var body: some View {
        
        VStack {
            
            CustomText(text: "관리할 예산 블럭의 총 금액을 알려주세요", size: 22, weight: .semibold, design: .default, color: .black)
                .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color.green)
                    .padding(.vertical)
                    .frame(width: 380, height: 200)
                    .opacity(0.6)
                
                TextField("총 예산 금액", text: $blockerAmount)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            if let budget = Float(blockerAmount) {
                
                var newblocker = BlockerModel(name: blockerName, image: blockerImage, budget: 0, period: nil, resetDate: nil, spent: nil, startDate: nil, endDate: nil, histories: [])
                
                Button(action: {
                    newblocker.budget = budget
                    
                }, label: {
                    NavigationButton(destination: AnyView(UICreateType(blockerModel: newblocker)))
                })
                
                
                
                Text("\(Int(budget))")
            }
            
        }
        .offset(y: -20)
    }
}


struct UICreateType: View {
    
    @State var blockerModel: BlockerModel
    @State private var isClicked: Bool = false
    @State private var isOneTime: Bool = true
    
    var body: some View {
        VStack {
            
            VStack {
                
                Text("\(Int(blockerModel.budget))")
                CustomText(text: "관리할 예산 블럭의 성격을 알려주세요", size: 22, weight: .semibold, design: .default, color: .black)
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.green)
                        .padding(.vertical)
                        .frame(width: 380, height: 200)
                        .opacity(0.6)
                    
                    HStack(spacing: 40) {
                        Button {
                            isOneTime.toggle()
                            if isClicked {
                                isClicked.toggle()
                            }
                        } label: {
                            CircleText(text: "반복")
                        }
                        
                        Button {
                            if isOneTime == false {
                                isOneTime.toggle()
                            }
                            
                            if isClicked == false {
                                isClicked.toggle()
                            }
                            
                            if blockerModel.period != nil {
                                blockerModel.period = nil
                            }
                        } label: {
                            CircleText(text: "일회성")
                        }
                    }
                }
            }
            
            VStack {
                CustomText(text: "관리할 예산 블럭의 주기를 알려주세요", size: 22, weight: .semibold, design: .default, color: .black)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.green)
                        .padding(.vertical)
                        .frame(width: 380, height: 200)
                        .opacity(0.6)
                    
                    HStack(spacing: 5) {
                        Button(action: {
                            blockerModel.period = .weekly
                            if isClicked == false {
                                isClicked.toggle()
                            }
                        }, label: {
                            CircleText(text: "주간")
                        })
                        
                        Button(action: {
                            blockerModel.period = .monthly
                            if isClicked == false {
                                isClicked.toggle()
                            }
                        }, label: {
                            CircleText(text: "월간")
                        })
                        
                        Button(action: {
                            blockerModel.period = .yearly
                            if isClicked == false {
                                isClicked.toggle()
                            }
                        }, label: {
                            CircleText(text: "연간")
                        })
                    }
                }
            }
            .isEmpty(isOneTime) // custom view modifier
            
            if isClicked {
                NavigationButton(destination: AnyView(UICreateDate(blockerModel: $blockerModel)))
            }
            
        }
        .offset(y: -20)
    }
}


struct UICreateDate: View {
    
    @Binding var blockerModel: BlockerModel
    //@State var date: Date = Date()
    @State var selectedWeekday = CustomWeekdays.일요일
    @State var selectedDate = "1 일"
    @State var selectedMonth = "1 월"
    @State private var _month : Int? = 1
    
    @State var selectedStartDate = Date()
    
    var body: some View {
        
        if let period = blockerModel.period {
            // 1. recurrsive mode
            VStack{
                
                VStack {
                    CustomText(text: "예산 블럭의 시작일을 알려주세요", size: 20, weight: .semibold, design: .default, color: .black)
                    CustomText(text: "(모든 예산은 시작일이 되면 초기화 됩니다.)", size: 18, weight: .semibold, design: .default, color: .black)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.green)
                            .padding(.vertical)
                            .frame(width: 380, height: 380)
                            .opacity(0.6)
                        
                        switch period {
                        case .weekly:
                            // 1-1. weekly view
                            Picker("", selection: $selectedWeekday) {
                                ForEach(CustomWeekdays.allCases) { day in
                                    Text("\(day.rawValue)").tag(day).font(.system(size: 22, weight: .semibold, design: .default))
                                }
                            }
                            .labelsHidden()
                            .padding()
                            .onReceive([selectedWeekday].publisher.first(), perform: { value in
                                blockerModel.resetDate = DateComponents(weekday: weekdays2int[value.rawValue])
                            }
                            )
                        case .monthly:
                            // 1-2. monthly view
                            VStack(spacing: 5) {
                                
                                Picker("", selection: $selectedDate) {
                                    ForEach(customDates, id: \.self) { date in
                                        Text(date).tag(date).font(.system(size: 22, weight: .medium, design: .default))
                                    }
                                }
                                .labelsHidden()
                                .padding()
                                .onReceive([selectedDate].publisher.first(), perform: { value in
                                    blockerModel.resetDate = DateComponents(day: days2int[value])
                                }
                                )
                                
                                CustomText(text: "⚠️ 일수가 모자란 달은 자동으로 계산됩니다.", size: 18, weight: .semibold, design: .default, color: .black)
                            }
                        case .yearly:
                            // 1-3. yearly view
                            
                            HStack(spacing: 0) {
                                
                                VStack(spacing:0) {
                                    Text("월")
                                        .font(.system(size: 20, weight: .semibold, design: .default))
                                        .padding()
                                        .frame(width: 100, height: 35, alignment: .center)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                    
                                    
                                    Picker("", selection: $selectedMonth) {
                                        ForEach(customMonth, id: \.self) { month in
                                            Text(month).tag(month).font(.system(size: 22, weight: .medium, design: .default))
                                        }
                                    }
                                    .labelsHidden()
                                    
                                    .onReceive([selectedMonth].publisher.first(), perform: { value in
                                        _month = month2int[value]
                                        
                                    }
                                    )
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.5)
                                .clipped()
                                
                                VStack(spacing:0) {
                                    Text("일")
                                        .font(.system(size: 20, weight: .semibold, design: .default))
                                        .padding()
                                        .frame(width: 100, height: 35, alignment: .center)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                    
                                    
                                    Picker("", selection: $selectedDate) {
                                        ForEach(customDates, id: \.self) { date in
                                            Text(date).tag(date).font(.system(size: 22, weight: .semibold, design: .default))
                                        }
                                    }
                                    .labelsHidden()
                                    .onReceive([self.selectedDate].publisher.first(), perform: { value in
                                        if let _month = _month {
                                            blockerModel.resetDate = DateComponents(month: _month, day: days2int[value])
                                        }
                                    }
                                    )
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.5)
                                .clipped()
                                
                                
                            }
                            
                            
                            
                        }
                    }
                    
                }
                
                
                NavigationButton(destination: AnyView(UICreateSpent(blockerModel: $blockerModel)))
                    .offset(y:60)
                
                
            }
            .offset(y: -20)
            
        } else {
            // one time mode
            VStack {
                CustomText(text: "예산 블럭의 시작일을 알려주세요", size: 20, weight: .semibold, design: .default, color: .black)
                    .padding()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.green)
                        .padding(.vertical)
                        .frame(width: 380, height: 380)
                        .opacity(0.5)
                    
                    // TODO: locale 적용
                    DatePicker("", selection: $selectedStartDate, displayedComponents: [.date])
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .onReceive([self.selectedStartDate].publisher.first(), perform: { value in
                            blockerModel.startDate = value
                        })
                }
                
                NavigationButton(destination: AnyView(UICreateEndDate(blocker: $blockerModel)))
                    .offset(y:60)
            }
            .offset(y: -20)
        }
    }
}

struct UICreateSpent: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var blockerViewModel: BlockerViewModel
    @Binding var blockerModel: BlockerModel
    @State var spent = ""
    
    var body: some View {
        
        VStack {
            
            CustomText(text: "예산 중 이미 사용한 금액이 있다면, 블로커에게 알려주세요", size: 20, weight: .semibold, design: .default, color: .black)
                .padding()
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color.green)
                    .padding(.vertical)
                    .frame(width: 380, height: 200)
                    .opacity(0.6)
                
                
                TextField("이미 사용한 금액", text: $spent)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            
            if let spent = Float(spent) {
                
                Button(action: {
                    blockerModel.spent = spent
                    blockerViewModel.currentBlockers.append(blockerModel)
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    CustomText(text: "예산 생성", size: 25, weight: .bold, design: .default, color: .white)
                        .frame(width: 120, height: 30, alignment: .center)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                })
            }
        }
        .offset(y: -20)
        
    }
}


struct UICreateEndDate: View {
    
    @EnvironmentObject var blockerViewModel: BlockerViewModel
    @State var selectedEndDate: Date = Date()
    @Binding var blockerModel: BlockerModel
    
    // initialize Binding property
    init(blocker blockerModel: Binding<BlockerModel>) {
        self._blockerModel = blockerModel
    }
    
    // Computed Property
    var startDate: Date { blockerModel.startDate! > Date() ? blockerModel.startDate! : Date() } // max(today, startDate)
    var dateRange: PartialRangeFrom<Date> {
        let current = Calendar.current
        let startCompenet = current.dateComponents([.year, .month, .day], from: startDate)
        return current.date(from: startCompenet)!...
    }
    
    var body: some View {
        VStack {
            
            Text("**DEBUG** \(blockerModel.startDate ?? Date())")
            Text("**DEBUG** \(dateRange.lowerBound)")
            
            CustomText(text: "예산 블럭의 종료일을 알려주세요", size: 20, weight: .semibold, design: .default, color: .black)
                .padding()
            
            // TODO: locale 적용
            DatePicker("", selection: $selectedEndDate, in: dateRange,  displayedComponents: [.date])
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .onReceive([self.selectedEndDate].publisher.first(), perform: { value in
                    blockerModel.endDate = value
                })
            
            Button(action: {
                blockerModel.endDate = selectedEndDate
                blockerViewModel.currentBlockers.append(blockerModel)
            }, label: {
                CustomText(text: "예산 생성", size: 22, weight: .bold, design: .default, color: .white)
                    .background(Color.green)
            })
        }
    }
}


struct CircleText: View {
    
    @State var text: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 80, height: 80, alignment: .center)
            CustomText(text: text, size: 22, weight: .semibold, design: .default, color: .orange)
        }
        .padding()
    }
}

struct NavigationButton: View {
    
    @State var destination: AnyView
    
    var body: some View {
        NavigationLink(
            destination: destination,
            label: {
                CustomSFImage(imageName: "arrow.forward.circle.fill", renderMode: .template, width: 80 , height: 80, corner: 0, color: Color.green)
                    .padding(.horizontal)
            })
    }
}

struct EmptyModifier: ViewModifier {
    let isEmpty: Bool
    
    func body(content: Content) -> some View {
        Group {
            if isEmpty {
                EmptyView()
            } else {
                content
            }
        }
    }
}

extension View {
    func isEmpty(_ bool: Bool) -> some View {
        modifier(EmptyModifier(isEmpty: bool))
    }
}

struct UIAddBlocker_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            
            //UICreateImage()
            
            //UICreateName(blockerImage: .constant("eat-blocker"))
            
            UICreateBudget(blockerImage: .constant("eat-blocker"), blockerName: .constant("aa"))
            
            //UICreateType(blockerModel: BlockerModel(name: "식비", image: "eat-blocker", budget: 600000, period: .weekly, resetDate: DateComponents(weekday:1), spent: nil, startDate: nil, endDate: nil, histories: []))
            
            //UICreateDate(blockerModel: .constant(BlockerModel(name: "식비", image: "eat-blocker", budget: 600000, period: nil, resetDate: nil, spent: nil, startDate: nil, endDate: nil, histories: [])))
            
            //UICreateSpent(blockerModel: .constant(BlockerModel(name: "식비", image: "eat-blocker", budget: 600000, period: .weekly, resetDate: DateComponents(weekday:1), spent: nil, startDate: nil, endDate: nil, histories: [])))
            
            //UICreateEndDate(startDate: Calendar.current.date(from: DateComponents(year: 2021, month: 1, day: 1))!)
        }
        .environmentObject(ImageViewModel())
        .environmentObject(BlockerViewModel())
        
    }
}
