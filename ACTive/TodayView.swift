//
//  ContentView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/21/23.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    var body: some View{
        NavigationStack{
            Text("December 21st, 2023").font(.footnote)
                .navigationTitle("Today")
        }
    }
}

#Preview {
    TodayView()
        .modelContainer(for: Item.self, inMemory: true)
}
