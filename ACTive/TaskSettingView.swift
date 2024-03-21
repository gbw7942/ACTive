//
//  TaskSettingView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/22/23.
//

import SwiftUI
import UIKit


struct TaskSettingView: View {
    @StateObject var taskData = TaskData()
    @State private var selection: Task?
    @State var showAddTaskView = false

    var body: some View {
        NavigationSplitView {
            VStack(spacing: 16) { // Added spacing between elements

                List {
                    if let retrievedTasks = retrieveTasksFromKeychain() {
                        ForEach(retrievedTasks) { singleTask in
                            TodayTaskProgress(tasks: singleTask)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) { // Enhanced swipe actions
                                    Button(role: .destructive) {
                                        deleteTask(taskToDelete: singleTask)
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill") // Changed to a filled icon for better visibility
                                    }
                                    Button {
                                        // Implement edit task action here
                                    } label: {
                                        Label("Edit", systemImage: "square.and.pencil") // Added label text for clarity
                                    }
                                    .tint(.yellow) // Colored the edit button for visual differentiation
                                }
                        }
                    }
                }
                .listStyle(.insetGrouped) // Changed list style for a more modern appearance
                
                
                Button(action: { showAddTaskView.toggle() }) {
                    Label("Add Task", systemImage: "plus.circle.fill") // Changed to a filled icon for better visibility
                        .labelStyle(.iconOnly) // Shows only the icon
                        .font(.title) // Enlarges the icon for better tap targets
                }
                .sheet(isPresented: $showAddTaskView, content: {
                    AddTaskView()
                })
                .buttonStyle(.borderedProminent) // Gives the button a more pronounced look
                .controlSize(.large) // Increases the control size for easier interaction
                .padding(.horizontal) // Added horizontal padding
            .padding(.top) // Added top padding
            }
            .navigationTitle("Task Settings") // Added a navigation title
            .toolbar { // Toolbar items for additional actions or information
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Implement an action here, such as showing help or settings
                    }) {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        } detail: {
            Text("Select a task to view details.") // Placeholder text for detail view
                .foregroundColor(.secondary) // Styled the placeholder text
        }
    }
}

struct AddTaskView: View {
    @State private var inputTaskName = ""
    @State private var inputTaskTime = 30
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode // For navigating back
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Basic Setting")) {
                        TextField("Type the task name here", text: $inputTaskName)
                        Stepper("Total time of Task: \(inputTaskTime) min", value: $inputTaskTime, in: 5...180, step: 5)
                    }
                    Section(header: Text("Advanced Setting")) {
                        Label("Still developing. Thanks for your attention.", systemImage: "hourglass")
                    }
                }
                Button(action: {
                    let newTask = Task(name: inputTaskName, totaltime: Double(inputTaskTime), completetime: 0)
                    var tasks = retrieveTasksFromKeychain() ?? [Task]()
                    tasks.append(newTask)
                    saveTasksToKeychain(tasks: tasks)
                    showAlert = true // Trigger the alert
                }) {HStack {
                            Image(systemName: "checkmark")
                                .font(.title3)
                            Text("Done")
                                .font(.title3)
                        }}
                .foregroundColor(.white) // Ensures text and icon are white for contrast
                .padding() // Adds space around the text and icon, making the button larger and easier to tap
                .background(Color.blue) // Sets the background color of the button
                .cornerRadius(10) // Rounds the corners of the button's background
                .shadow(radius: 5) // Adds a shadow for depth
                .buttonStyle(.plain) // Applies the plain button style, can be adjusted based on preference
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Success"),
                        message: Text("The task has been saved successfully."),
                        dismissButton: .default(Text("OK")) {
                            presentationMode.wrappedValue.dismiss() // Go back to TaskSettingView
                        }
                    )
                }
                Spacer()
            }
            .navigationTitle("Add Task")
        }
    }
}


func deleteTask(taskToDelete: Task){
    guard var retrievedTasks = retrieveTasksFromKeychain() else { return }
    retrievedTasks.removeAll { $0.id == taskToDelete.id }
    saveTasksToKeychain(tasks:retrievedTasks)
}
