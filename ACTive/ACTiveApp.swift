//
//  ACTiveApp.swift
//  ACTive
//
//  Created by Gabriel Wang on 3/17/24.
//

import SwiftUI
import SwiftData
import Security

@main
struct ACTiveApp: App {
    @AppStorage("HasLaunchedBefore") var hasLaunchedBefore = false
    @State private var showWelcome = true
    var body: some Scene {
        WindowGroup {
            if showWelcome && !hasLaunchedBefore{
                WelcomeView{
                    hasLaunchedBefore=true
                    showWelcome=false
                }
            }else{
                MainTabView()
            }
        }
    }
}


struct WelcomeView: View {
    let sampleTask: [Task] = [
            Task(name: "Math", totaltime: 45, completetime: 3),
            Task(name: "English", totaltime: 45, completetime: 21),
            Task(name: "Reading", totaltime: 60, completetime: 17),
            Task(name: "Science", totaltime: 65, completetime: 29)
        ]
    var onConfirm: () -> Void
    var body: some View {
        VStack {
                    Text("Welcome to the App! Data is initilizing")
                        .font(.title)
                        .padding()

                    Button(action: onConfirm) {
                        Text("Get Started")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
        .onAppear {
                    saveTasksToKeychain(tasks: sampleTask)
                    let taskData=TaskData()
                    taskData.retrieveTasksFromKeychain() //Read the init data
                }
    }
}

// After the first launch, it will show the MainTabView
struct MainTabView: View {
    @ObservedObject var user = User()
    var body: some View {
        TabView{
            TodayView(user:user)
                .tabItem { Label("Today",systemImage: "list.bullet")}
                .onAppear(perform: {
                })
            LessonView(user:user)
                .tabItem { Label("Lessons",systemImage: "person.2") }
            // Hide the tab if user is not pro
                .opacity(user.user.isPro == false ? 0 : 1)
            PrefView(user:user,isPro:$user.user.isPro)
                .tabItem { Label("Preferences",systemImage: "gear") }
        }
    }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
} // to calculate completeness of Task better


struct userProfile: Identifiable,Hashable,Codable{
    var id=UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
    var username:String
    var isPro=false
    var isCoach=false //for demo only
}


class User: ObservableObject{
    @Published var user:userProfile=userProfile(username: "gbw7942",isPro: false,isCoach: false)
}



class Task: Hashable,Identifiable,Codable{
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.totaltime==rhs.totaltime&&lhs.completetime==rhs.completetime
    }
    enum DecodingError: Error{
        case missingFile
    }
    
    var name: String
    var totaltime: Double
    var completetime: Double
    var completeness:Double
    var id: UUID
    
    init(name: String,totaltime: Double,completetime:Double){
        self.name=name
        self.totaltime=totaltime
        self.completetime=completetime
        self.completeness=100*completetime/totaltime
        if let uuid = UUID(uuidString: "E621E1F8-C36C-0OWN-93FP-0C14SA3E6E5F") {
            self.id = uuid}
        else {
            self.id = UUID()}
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

class TaskData: ObservableObject{
    @Published var taskData: [Task] = []

        func retrieveTasksFromKeychain() {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "tasksJSON",
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]

            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)

            guard status == errSecSuccess, let data = item as? Data else {
                print("Error retrieving tasks from Keychain")
                return
            }

            do {
                let tasks = try JSONDecoder().decode([Task].self, from: data)
                DispatchQueue.main.async {
                    self.taskData = tasks
                }
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }
}

func saveTasksToKeychain(tasks: [Task]) {
    do {
        let jsonData = try JSONEncoder().encode(tasks)
        
        // Prepare query to search for existing item
        let searchQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "tasksJSON"
        ]
        
        // Update existing item if found, otherwise add new item
        var status = SecItemUpdate(searchQuery as CFDictionary, [kSecValueData as String: jsonData] as CFDictionary)
        
        if status == errSecItemNotFound {
            // Item not found, add new item
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "tasksJSON",
                kSecValueData as String: jsonData
            ]
            
            status = SecItemAdd(query as CFDictionary, nil)
        }
        
        guard status == errSecSuccess else {
            print("Error saving tasks to Keychain")
            return
        }
        
        print("Tasks saved to Keychain successfully")
    } catch {
        print("Error encoding tasks to JSON: \(error)")
    }
}


func retrieveTasksFromKeychain() -> [Task]? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "tasksJSON",
        kSecReturnData as String: kCFBooleanTrue!,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)

    guard status == errSecSuccess, let data = item as? Data else {
        print("Error retrieving tasks from Keychain")
        return nil
    }

    do {
        let tasks = try JSONDecoder().decode([Task].self, from: data)
        return tasks
    } catch {
        print("Error decoding JSON data: \(error)")
        return nil
    }
}

