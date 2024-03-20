//
//  TaskSettingView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/22/23.
//

import SwiftUI
import UIKit


struct TaskSettingView: View {
    @StateObject var taskData=TaskData()
    @State private var selection: Task?
    @State var showAddTaskView=false
    
    var body: some View {
        NavigationSplitView{
            VStack{
                HStack{
                    Button(action:{showAddTaskView.toggle()}){
                        Label("",systemImage: "plus.circle")
                    }.sheet(isPresented: $showAddTaskView, content: {
                        AddTaskView()
                    })
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5)
                }
                List{
                    if let retrievedTasks = retrieveTasksFromKeychain() {
//                        ForEach(taskData.taskData){ singleTask in
//                            TodayTaskProgress(tasks: singleTask)}
                        ForEach(retrievedTasks){ singleTask in
                            TodayTaskProgress(tasks: singleTask)
                        }
                        .swipeActions{
                            Button(role: .destructive){
                                selection=nil
                            }label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button(action: {}){Label("",systemImage: "square.and.pencil")}
                        }
                    }

                }
            }
        }
    detail:{
    }
    }
}

struct AddTaskView: View {
    @State var inputTaskName=""
    @State var inputTaskTime=30
    var body: some View {
        NavigationStack{
            VStack{
                Form{
                    Section(header: Text("Basic Setting")){
                        TextField("Type the task name here",text: $inputTaskName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.words)
                        Stepper("Total time of Task: \(inputTaskTime) min",value: $inputTaskTime, in:5...180,step: 5)
                    }
                    Section(header: Text("Advanced Setting")){
                        Label("Still developing. Thanks for your attention.",systemImage: "hourglass")
                    }
                }
                Button(action:{
                        var newTask=Task(name: inputTaskName, totaltime: Double(inputTaskTime), completetime: 0)
                        var tasks = retrieveTasksFromKeychain() ?? [Task]()
                        tasks.append(newTask)
                        saveTasksToKeychain(tasks: tasks)
                }){Text("Done").fontWeight(.bold)}
                    .padding()
                    .cornerRadius(10)
            }
            .navigationTitle("Add Task")
        }
    }
}


func deleteTask(taskToDelete: Task){
    if var retrievedTasks = retrieveTasksFromKeychain() {
        retrievedTasks.removeAll{$0.id == taskToDelete.id}
        saveTasksToKeychain(tasks: retrievedTasks)
    }
}
