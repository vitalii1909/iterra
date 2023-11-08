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
        VStack(content: {
            
            ScrollView {
                LazyVStack(content: {
                    ForEach(vm.historyArray.keys.sorted(by: {$0 < $1}), id: \.self) { date in
                        if let array = vm.historyArray[date] {
                            Section {
                                ForEach(array, id: \.id) { historyModel in
                                    Text("\(historyModel.text)")
                                }
                            } header: {
                                Text(date, format: .dateTime)
                            }
                        }
                    }
                })
            }
            
            Spacer()
            HUDView(vm: HUDCleanHistoryVM(currentClean: vm.currentClean))
        })
        .task {
            do {
              try await vm.fetch()
            } catch let error {
                print("error \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    CleanDetailsView(vm: .init(currentClean: .mocData()))
}
