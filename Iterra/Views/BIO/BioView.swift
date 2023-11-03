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
    
    @State private var showNewEvent = false
    @State private var changeDateBio: BioModel?
    
    init(vm: BioVM, showNewEvent: Bool = false, changeDateBio: BioModel? = nil) {
        self.vm = vm
        self.showNewEvent = showNewEvent
        self.changeDateBio = changeDateBio
    }
    
    var body: some View {
        bodyContet
            .task {
                Task {
                    do {
                        try await vm.fetchBio(bioArray: $taskStore.bioArray, userId: publicUserId?.id)
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
            VStack(content: {
                if let dict = vm.getDict(array: taskStore.bioArray), !dict.isEmpty {
                    List {
                        getSections(dict: dict)
                    }
                    .padding(.horizontal, 20)
                    .animation(.smooth(), value: taskStore.cleanTimeArray.count)
                    .listStyle(.plain)
                    .listRowSpacing(14)
                    .background(Color.white)
                    .onAppear {
                        scrollToCurrent(proxy: proxy)
                    }
                } else {
                    Spacer()
                    Text("No events")
                }
                
                Spacer()
                //FIXME: new HUD
                TextField("", text: $vm.eventText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            })
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
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
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
        case let bioWillpower as BioWillpower:
            BioWillpoweRow(bioWillpower: bioWillpower)
        case let bioPatience as BioPatience:
            BioPatienceRow(bioPatience: bioPatience)
        case let bioClean as BioClean:
            BioCleanRow(bioClean: bioClean)
        case let bioText as BioText:
            BioTextRow(text: bioText.text)
        default:
            Text("Error type")
        }
    }
}


#Preview {
    let taskStore = StoreManager()
    
    taskStore.bioArray = [BioWillpower.mocData(done: true), BioWillpower.mocData(done: false)]
    
    return BioNavigationStack()
        .environmentObject(taskStore)
}
