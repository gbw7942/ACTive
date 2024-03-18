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
    
    var body: some View {
        NavigationSplitView{
            VStack{
                HStack{
                    Button("Add"){}
                }
                List{
//                    if let retrievedTasks = retrieveTasksFromKeychain() {
//                        ForEach(retrievedTasks){ singleTask in
//                            TodayTaskProgress(tasks: singleTask)
//                        }
                    ForEach(taskData.taskData){ singleTask in
                        TodayTaskProgress(tasks: singleTask)
                        .swipeActions{
                            Button(role: .destructive){
                                selection=nil
                            }label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }

                }
            }
        }
    detail:{
    }
    }
}



