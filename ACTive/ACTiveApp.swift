//
//  ACTiveApp.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/21/23.
//

import SwiftUI
import SwiftData
    
@main
struct ACTiveApp: App {
    @ObservedObject var user = User()
//    @ObservedObject var taskStore = TaskStore(tasks: Task().AllTasks)
    var body: some Scene {
        WindowGroup {
            Group{
                TabView{
                    TodayView(user:user,AllTasks=TaskStore(tasks: Task().AllTasks))
                                        .tabItem { Label("Today",systemImage: "list.bullet")}
                                    LessonView(user:user)
                                        .tabItem { Label("Lessons",systemImage: "person.2") }
                                        // Hide the tab if user is not pro
                                        .opacity(user.user.isPro == false ? 0 : 1)
                                    PrefView(user:user,isPro:$user.user.isPro)
                                        .tabItem { Label("Preferences",systemImage: "gear") }
                                }
            }
        }
    }
}

struct userProfile: Identifiable,Hashable,Codable{
    var id=UUID.init(uuidString: "7942")
    var username:String
    var isPro=false
}

class User: ObservableObject{
    @Published var user:userProfile=userProfile(username: "gbw7942",isPro: false)
}


class Tasks: Hashable,Codable{
    static func == (lhs: Tasks, rhs: Tasks) -> Bool {
        return lhs.totaltime==rhs.totaltime&&lhs.completetime==rhs.completetime
    }
    
    var name: String
    var totaltime: Int
    var completetime: Int
    
    init(name: String,totaltime: Int,completetime:Int){
        self.name=name
        self.totaltime=totaltime
        self.completetime=completetime
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(totaltime)
        hasher.combine(completetime)
    }
    
    func writetojson(){
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            let json = String(data: data, encoding: .utf8)
            print(json ?? "JSON")
        } catch {
            print("Encoding error: \(error)")
        }
    }
    
}

class Task: ObservableObject{
    var todayTaskMath=Tasks(name: "Math", totaltime: 45, completetime: 3)
    var todayTaskReading=Tasks(name: "Reading", totaltime: 60, completetime: 21)
    var todayTaskEnglish=Tasks(name: "English", totaltime: 45, completetime: 41)
    var todayTaskScience=Tasks(name: "Science", totaltime: 65, completetime: 29)
    @Published var AllTasks:[Tasks]
        init()
    {AllTasks = [todayTaskMath,todayTaskReading,todayTaskEnglish,todayTaskScience]}
}

class TaskStore: ObservableObject {
    @Published var tasks: [Tasks]
    
    init(tasks: [Tasks]) {
        self.tasks = tasks
    }
}
