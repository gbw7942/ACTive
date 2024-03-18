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
    @StateObject var taskData=TaskData()
    var body: some View{
        NavigationStack{
            VStack(alignment:.center){
                CircularProgressView()
                Divider()
                if let retrievedTasks = retrieveTasksFromKeychain() {
                    ForEach(retrievedTasks){ singleTask in
                        TodayTaskProgress(tasks: singleTask)
                    }
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

struct TodayTaskProgress: View {
    @ScaledMetric var imageWidth: CGFloat = 40
    
    let tasks:Task
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                Text(tasks.name).foregroundStyle(tasks.completetime==tasks.totaltime ? .secondary:.primary)
                ProgressView(value: tasks.completetime,total: tasks.totaltime){
                    Text("\(Int(round((tasks.completeness.round(to: 0)))))%").font(.footnote).foregroundStyle(tasks.completetime==tasks.totaltime ? .secondary:.primary)}
                .frame(width: 300)
                .tint(tasks.completetime==tasks.totaltime ? .secondary:ColorOptions.set())
                .animation(.easeOut, value: 0.07)
            }.padding(.bottom,10)
            
            if tasks.completetime==tasks.totaltime {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.secondary)
                        }
        }
    }
}

struct ColorOptions:Codable{
    static var all: [Color] = [
            .primary,
            .gray,
            .red,
            .orange,
            .blue,
            .brown,
            .yellow,
            .green,
            .mint,
            .cyan,
            .indigo,
            .purple,
        ]
    
    static func set() -> Color {
            if let element = ColorOptions.all.randomElement() {
                return element
            } else {
                return .primary
            }
            
        }
}

struct CircularProgressView: View {
    @State var progress=0.0
    var progressPercent: Int{Int(round(progress*100))}
    var body: some View {
        VStack {
            Text("Today's task: ").font(.title).bold().padding()
            Spacer()
            ZStack {
                Circle()
                    .stroke(Color.pink.opacity(0.3),lineWidth: 30)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.pink,style: StrokeStyle(lineWidth: 30,lineCap: .round))
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)
                Text("\(progressPercent)%").font(.title)
            }
            Slider(value: $progress, in: 0...1, step: 0.01).padding()
        }.frame(width: 300,height: 350)
    }
}


func dateFormat()->String{
    let date=Date()
    let dateFormatter=DateFormatter()
    dateFormatter.locale=Locale.current
    dateFormatter.dateStyle = .short
    return dateFormatter.string(from: date)
}
