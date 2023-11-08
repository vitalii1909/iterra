//
//  CleanDetailsView.swift
//  Iterra
//
//  Created by mikhey on 2023-11-06.
//

import SwiftUI

struct CleanDetailsView: View {
    
    @StateObject var vm: CleanTimeDetailsVM
    
    init(vm: CleanTimeDetailsVM) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        bodyContent
        .task {
            do {
              try await vm.fetch()
            } catch let error {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    private var bodyContent: some View {
        VStack(content: {
            if !vm.historyArray.isEmpty {
                list(dict: vm.historyArray)
            } else {
                Text("no history")
                    .frame(maxHeight: .infinity)
            }
            
            Spacer()
            hud
        })
        .animation(.smooth(), value: vm.historyArray.isEmpty)
    }
    
    private func list(dict: [Date : [CleanHistory]]) -> some View {
        ScrollView {
            LazyVStack(spacing: 12, content: {
                getSections(dict: vm.historyArray)
            })
            .padding(.horizontal, 20)
            .animation(.smooth(), value: vm.historyArray.values.count)
        }
    }
    
    private var hud: some View {
        HUDView<CleanTimeDetailsVM>()
            .environmentObject(vm)
    }
}

extension CleanDetailsView {
    private func getSections(dict: [Date : [CleanHistory]]) -> some View {
        ForEach(dict.keys.sorted(by: {$0 < $1}), id: \.self) { date in
            Section {
                if let array = vm.historyArray[date] {
                    getRows(array: array)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } else {
                    
                }
            } header: {
                Text(" \(date.get(.day))/\(date.get(.month))")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func getRows(array: [CleanHistory]) -> some View {
        ForEach(array, id: \.id) { historyModel in
            ChatBubbleView(text: historyModel.text, date: historyModel.date)
        }
    }
}

#Preview {
    publicUserId = .mocUser()
    return CleanDetailsView(vm: .init(currentClean: .mocData()))
}
