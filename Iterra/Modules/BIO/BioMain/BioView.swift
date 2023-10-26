//
//  BioView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-15.
//

import SwiftUI

struct BioView: View {
    
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var userService: UserService
    @StateObject var bioService: BioService = .init()
    
    @ObservedObject var vm: BioVM
    
    private var tasks: [BioModel] {
        return (taskStore.cleanTimeArray + taskStore.timersArray + taskStore.patienceArray)
    }
    
    @State var dict = [Date : [BioModel]]()
    
    @State var showNewEvent = false
    
    var body: some View {
        
        ScrollViewReader(content: { proxy in
            
            if !dict.isEmpty {
                List {
                    getSections(dict: dict)
                }
                .animation(.spring(), value: taskStore.cleanTimeArray.filter({$0.finished == false }).count)
                .animation(.spring(), value: taskStore.cleanTimeArray.count)
                .listRowSpacing(20)
                .onAppear {
                    scrollToCurrent(proxy: proxy)
                }
            } else {
                Text("No clean time")
            }
        })
        .task {
            Task {
                guard let userId = userService.user?.id else {
                    return
                }
                if let dict = await vm.fetchBio(service: bioService, userId: userId) {
                    self.dict = dict
                }
            }
        }
        .sheet(isPresented: $showNewEvent, content: {
            NewBioEventView()
        })
    }
    
    private func getSections(dict: [Date : [BioModel]]) -> some View {
        ForEach(dict.map({$0.key}).sorted(by: {$0 < $1}), id: \.timeIntervalSince1970) { key in
            Section() {
                getRows(key: key, dict: dict)
            } header: {
                Text(" \(key.get(.day))/\(key.get(.month))")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
            }
            .id(key)
        }
    }
    
    private func getRows(key: Date, dict: [Date : [BioModel]]) -> some View {
        let array = dict[key] ?? [BioModel]()
        return ForEach(array.sorted(by: {$0.deadline < $1.deadline}), id: \.id) { taskModel in
            taskCell(taskModel: taskModel)
                .id(taskModel.id)
        }
    }
    
    func taskCell(taskModel: BioModel) -> some View {
        switch taskModel {
        case let bioText as BioText:
           return Text("\(bioText.text)")
        default:
            return Text("qqqq")
        }
        
//          if let object = taskModel as? BioText {
//              return Text("www \(object.text)")
//          } else {
//              return Text("qqqq")
//          }
//          if item is Movie {
//                  movieCount += 1
//              } else if item is Song {
//                  songCount += 1
//              }
          
        //        VStack(alignment: .leading, spacing: 5, content: {
        //            Text(taskModel.text)
        //                .lineLimit(2)
        //
        //            HStack(content: {
        //                Spacer()
        //
        //                switch taskModel.type {
        //                case .willpower:
        //                    Circle()
        //                        .foregroundColor(taskModel.accepted ? .green : .red)
        //                        .frame(width: 40)
        //                case .patience:
        //                    let date = (taskModel.stopDate ?? Date()).timeIntervalSince(taskModel.date)
        //                    Text(date.stringFromTimeInterval().dropLast(4))
        //                        .font(.title.bold())
        //                case .cleanTime:
        //                    HStack(content: {
        //                        let date = (taskModel.stopDate ?? Date()).timeIntervalSince(taskModel.date)
        //                        Text(date.stringFromTimeInterval().dropLast(4))
        //                            .font(.title.bold())
        //
        //                        Circle()
        //                            .foregroundColor(taskModel.accepted ? .green : .red)
        //                            .frame(width: 40)
        //                    })
        //                }
        //            })
        //
        //            if taskModel.type != .cleanTime {
        //                Text("\(taskModel.deadline.get(.hour)):\(taskModel.deadline.get(.minute))  \(taskModel.deadline.get(.day))/\(taskModel.deadline.get(.month))")
        //            }
        //
        //        })
        //        .padding(.horizontal, 20)
        //        .padding(.vertical, 5)
        //        .padding(10)
        //        .listRowBackground(Color.blue.opacity(0.2))
        //        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    private func scrollToCurrent(proxy: ScrollViewProxy) {
        //        if let closestDate = dict?.keys.sorted(by: {$0 < $1}).first(where: {$0.compareDay(with: Date())}) { // "Feb 15, 2018, 12:00 PM"
        //            print(closestDate.description(with: .current)) // Thursday, February 15, 2018 at 12:00:00 PM Brasilia Summer Time
        //            proxy.scrollTo(closestDate, anchor: .top)
        //        } else {
        //
        //        }
        //    }
    }
}


#Preview {
    let taskStore = TaskStore()
//    taskStore.cleanTimeArray = TaskModel.mocArray(type: .cleanTime)
//    taskStore.timersArray = TaskModel.mocArray(type: .willpower)
//    taskStore.cleanTimeArray = TaskModel.mocArray(type: .cleanTime)
//    taskStore.patienceArray = TaskModel.mocArray(type: .patience)
//
//    for i in taskStore.cleanTimeArray {
//        i.finished = true
//    }
//    for i in taskStore.patienceArray {
//        i.accepted = true
//        i.finished = true
//    }
//    for i in taskStore.timersArray {
//        i.accepted = true
//        i.finished = true
//    }
    
    let userService = UserService()
    userService.user = User(id: "Y7pN9sZVpwgngcEnj0L9", email: "mikhey.work@gmail.com")
    
    return BioNavigationStack()
        .environmentObject(taskStore)
        .environmentObject(userService)
}

extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
    }
}

extension Date {
    
    func compareDay(with: Date) -> Bool {
        return self.get(.day) == with.get(.day) &&  self.get(.month) == with.get(.month) && self.get(.year) == with.get(.year)
    }
    
}
