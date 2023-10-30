//
//  BioView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-15.
//

import SwiftUI

struct BioView: View {
    
    @ObservedObject var vm: BioVM
    
    @EnvironmentObject private var taskStore: StoreManager
    @EnvironmentObject private var userService: UserService
    
    @State private var showNewEvent = false
    @State private var changeDateBio: BioModel?
    
    var body: some View {
        bodyContet
            .task {
                Task {
                    do {
                        try await vm.fetchBio(bioArray: $taskStore.bioArray, userId: userService.user?.id)
                    } catch let error {
                        print("let error \(error)")
                    }
                }
            }
            .toolbar {
                Button(action: {
                    showNewEvent = true
                }, label: {
                    Image(systemName: "plus")
                })
            }
            .sheet(isPresented: $showNewEvent, content: {
                NewBioEventView(array: $taskStore.bioArray)
            })
            .sheet(item: $changeDateBio) { bioModel in
                BioUpdateDateView(array: $taskStore.bioArray, currentBio: bioModel)
            }
    }
    
    private var bodyContet: some View {
        ScrollViewReader(content: { proxy in
            if let dict = vm.getDict(array: taskStore.bioArray), !dict.isEmpty {
                List {
                    getSections(dict: dict)
                }
                .animation(.smooth(), value: taskStore.cleanTimeArray.filter({$0.finished == false }).count)
                .animation(.smooth(), value: taskStore.cleanTimeArray.count)
                .listRowSpacing(14)
                .onAppear {
                    scrollToCurrent(proxy: proxy)
                }
            } else {
                Text("No clean time")
            }
        })
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

//collection
private extension BioView {
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
    
    @ViewBuilder
    private func getRows(key: Date, dict: [Date : [BioModel]]) -> some View {
        let array = dict[key] ?? [BioModel]()
        ForEach(array.sorted(by: {$0.date < $1.date}), id: \.id) { taskModel in
            taskCell(taskModel: taskModel)
                .id(taskModel.id)
                .contextMenu(menuItems: {
                    Button {
                        changeDateBio = taskModel
                    } label: {
                        Text("change date")
                    }
                })
        }
    }
    
    @ViewBuilder
    func taskCell(taskModel: BioModel) -> some View {
        switch taskModel {
        case let bioText as BioText:
            BioTextRow(text: bioText.text)
        default:
            Text("Error type")
        }
    }
    
    //FIXME: delete
    private func taskCell2(taskModel: BioModel) -> some View {
        switch taskModel {
        case let bioText as BioText:
            return AnyView(BioTextRow(text: bioText.text))
        default:
            return AnyView(Text("22"))
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
}


#Preview {
    let taskStore = StoreManager()
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
