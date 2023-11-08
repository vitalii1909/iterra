//
//  BioView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-15.
//

import SwiftUI

struct BioView: View, KeyboardReadable {
    
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
                        try await vm.fetchBio()
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
                NewBioEventView()
            })
            .sheet(item: $changeDateBio) { bioModel in
                BioUpdateDateView(currentBio: bioModel)
            }
    }
    
    private var bodyContet: some View {
        ScrollViewReader(content: { proxy in
            VStack(content: {
                if !vm.dict.isEmpty {
                    bioList(dict: vm.dict, proxy: proxy)
                } else {
                    Spacer()
                    Text("No events")
                }
                Spacer()
                textHud
            })
        })
    }
    
    private func bioList(dict: [Date: [BioModel]], proxy: ScrollViewProxy) -> some View {
        ScrollView {
            LazyVStack(spacing: 12, content: {
                getSections(dict: dict)
            })
            .padding(.horizontal, 20)
        }
        .animation(.smooth(), value: vm.dict.values.count)
        .listStyle(.plain)
        .listRowSpacing(14)
        .background(Color.clear)
        .onAppear {
            scrollToCurrent(proxy: proxy)
        }
        .onChange(of: vm.dict.values.count) { newValue in
            scrollToCurrentMessage(proxy: proxy)
        }
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            scrollToCurrentMessage(proxy: proxy)
        }
    }
    
    private var textHud: some View {
//        HUDView(vm: HUDBioVM())
        Text("w")
    }
    
    private func scrollToCurrent(proxy: ScrollViewProxy) {
        if let closestDate = vm.dict.keys.sorted(by: {$0 < $1}).first(where: {$0.compareDay(with: Date())}) {
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.0) {
                proxy.scrollTo(closestDate, anchor: .top)
            }
        }
    }
    
    private func scrollToCurrentMessage(proxy: ScrollViewProxy) {
        if let closestDate = vm.dict.keys.sorted(by: {$0 < $1}).first(where: {$0.compareDay(with: Date())}) { // "Feb 15, 2018, 12:00 PM"
            print(closestDate.description(with: .current)) // Thursday, February 15, 2018 at 12:00:00 PM Brasilia Summer Time
            
            if let id = vm.dict[closestDate]?.sorted(by: {$0.date < $1.date}).last?.id {
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.0) {
                    withAnimation(.easeOut) {
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
            }
        }
    }
}

//collection
private extension BioView {
    private func getSections(dict: [Date : [BioModel]]) -> some View {
        ForEach(dict.map({$0.key}).sorted(by: {$0 < $1}), id: \.timeIntervalSince1970) { key in
            Section() {
                getRows(key: key, dict: dict)
                    .frame(maxWidth: .infinity, alignment: .trailing)
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
                    Button(action: {
                        changeDateBio = taskModel
                    }, label: {
                        Text("change date")
                    })
                })
            
        }
    }
    
    @ViewBuilder
    func taskCell(taskModel: BioModel) -> some View {
        switch taskModel {
        case let bioWillpower as BioWillpower:
            BioWillpoweRow(bioWillpower: bioWillpower)
                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 14))
        case let bioPatience as BioPatience:
            BioPatienceRow(bioPatience: bioPatience)
                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 14))
        case let bioClean as BioClean:
            BioCleanRow(bioClean: bioClean)
                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 14))
        case let bioText as BioText:
            ChatBubbleView(text: bioText.text, date: bioText.date)
                .contentShape(ContentShapeKinds.contextMenuPreview, ChatBubbleShape(direction: .right))
        default:
            Text("Error type")
        }
    }
}


#Preview {
    publicUserId = User.mocUser()
    let taskStore = StoreManager()
    //
    //    taskStore.bioArray = [BioWillpower.mocData(done: true), BioWillpower.mocData(done: false), BioPatience.mocData(waited: true),
    //        BioPatience.mocData(waited: false),
    //                          BioText.mocDate()
    //    ]
    
    return BioNavigationStack()
        .environmentObject(taskStore)
}

import Combine

protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}
