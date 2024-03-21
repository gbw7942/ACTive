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
                ScrollView{
                    VStack(alignment:.center){
                        CircularProgressView()
                        Spacer()
                        if let retrievedTasks = retrieveTasksFromKeychain() {
                            ForEach(retrievedTasks){ singleTask in
                                TodayTaskProgress(tasks: singleTask)
                            }
                        }
                        
                    }
                }
                .navigationTitle("Today")
        }.padding(.bottom)
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
                .tint(tasks.completetime==tasks.totaltime ? .secondary:tasks.color.color)
                .animation(.easeOut, value: 0.07)
            }.padding(.bottom,10)
            
            if tasks.completetime==tasks.totaltime {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.secondary)
                        }
        }
    }
}



struct CircularProgressView: View {
    @State var progress=calculateTotalCompleteness()
    var body: some View {
        VStack {
            Spacer().frame(minHeight: 100)
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
                Text("\(Int(round(progress*100)))%").font(.title)
            }
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

func calculateTotalCompleteness() ->Double{
    var todayTotalTime=0.0
    var todayCompleteTime=0.0
    if let retrievedTasks = retrieveTasksFromKeychain() {
        retrievedTasks.forEach { singleTask in
            todayTotalTime += singleTask.totaltime
            todayCompleteTime += singleTask.completetime
        }
    }
    if todayTotalTime > 0 {
            let completenessPercentage = todayCompleteTime / todayTotalTime
            return completenessPercentage
        } else {
            return 0
        }
}
