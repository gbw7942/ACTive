//
//  ContentView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/21/23.
//

import SwiftUI
import SwiftData
import Foundation

struct TodayView: View {
    @StateObject var user=User()
    @StateObject var AllTasks:TaskStore
    
    @State private var selection: Tasks?
    var body: some View{
        NavigationStack{
            VStack(alignment:.center){
                CircularProgressView()
                Divider()
                ForEach(AllTasks.tasks){ Taskdetail in
                    TodayTaskProgress(tasks: Taskdetail)
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigation){
                    VStack(alignment:.leading){
                        Text("Hi, \(user.user.username)").font(.footnote)
                        Text("\(dateFormat())").font(.footnote)
                        Spacer()
                    }
                }
            }.navigationTitle("Today")
        }
    }
}

//#Preview {
//    TodayView()
//}

func dateFormat()->String{
    let date=Date()
    let dateFormatter=DateFormatter()
    dateFormatter.locale=Locale.current
    dateFormatter.dateStyle = .short
    return dateFormatter.string(from: date)
}
