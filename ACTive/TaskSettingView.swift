//
//  TaskSettingView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/22/23.
//

import SwiftUI
import UIKit


struct TaskSettingView: View {
    @EnvironmentObject var AllTasks:TaskStore
    @State private var isAddingNewEvent = false
    @State private var newEvent = Tasks(name: "New Task", totaltime: 60, completetime: 0)
    @State private var selection: Tasks?
    
    var body: some View {
        NavigationSplitView{
            VStack{
                HStack{
                    Button("Add"){}
                }
                List{
                    ForEach(AllTasks.tasks){tasks in
                        TodayTaskProgress(tasks: tasks)
                            .tag(tasks)
                            .swipeActions{
                                Button(role: .destructive){
                                    selection=nil
                                    var jsonString=AllTasks.tasks[1].writetojson()    //transfer to JSON Stirng
                                    
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


//#Preview {
//    TaskSettingView()
//}

