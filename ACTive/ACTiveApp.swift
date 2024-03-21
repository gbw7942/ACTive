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
    @StateObject private var user = User()
    @State private var showWelcome = true
    var body: some Scene {
        WindowGroup {
            if showWelcome && !hasLaunchedBefore{
                WelcomeView{
                    hasLaunchedBefore=true
                    showWelcome=false
                }
            }else{
                MainTabView().environmentObject(user)
            }
        }
    }
}


struct WelcomeView: View {
    @State var username=""
    let sampleTask: [Task] = [
            Task(name: "Math", totaltime: 45, completetime: 3),
            Task(name: "English", totaltime: 45, completetime: 21),
            Task(name: "Reading", totaltime: 60, completetime: 17),
            Task(name: "Science", totaltime: 65, completetime: 29)
        ]
    var onConfirm: () -> Void
    var body: some View {
        VStack {
                    Text("Welcome to ACTive!")
                        .font(.title)
                        .padding()
                    Text("ACTive aims to offer an all-round help and tutor for ADHD students in middle and high school in Boston.")
                        .font(.footnote)
                    Spacer()
                    TextField("Input your username here",text:$username)
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
    @State private var selectedTab = 0 // Use an integer to track the selected tab
    @State private var showAlert = false
    @EnvironmentObject var user: User
    
    var body: some View {
        TabView(selection: $selectedTab){
            TodayView(user: user)
                .tabItem { Label("Today", systemImage: "list.bullet") }
                .tag(0) // Assign a tag for the tab
            
            LessonView(user: user)
                .tabItem { Label("Lessons", systemImage: "person.2") }
                .tag(1) // Assign a different tag for each tab
                .opacity(user.user.isPro ? 1 : 0) // This will only affect the opacity, not prevent access
            
            PrefView(user: user, isPro: $user.user.isPro)
                .tabItem { Label("Preferences", systemImage: "gear") }
                .tag(2)
        }
        .onChange(of: selectedTab) { newValue in
            if newValue == 1 && !user.user.isPro { // Check if Lessons tab is selected and user is not a pro
                showAlert = true
                selectedTab = 0 // Optionally redirect user to another tab, e.g., the first tab
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Restricted Access"),
                message: Text("This page requires VIP access. Please upgrade to pro to continue."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


struct UserProfile: Identifiable,Hashable,Codable{
    var id=UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
    var username:String
    var isPro=false
    var isCoach=false //for demo only
}


class User: ObservableObject{
    @Published var user:UserProfile=UserProfile(username: "gbw7942",isPro: false,isCoach: false)
}



class Task: Hashable,Identifiable,Codable{
    enum TextColor: String, Codable, CaseIterable { // Ensure it conforms to CaseIterable
        case red, green, blue, yellow,gray,brown,cyan,mint

        var color: Color {
            switch self {
            case .red:
                return .red
            case .green:
                return .green
            case .blue:
                return .blue
            case .yellow:
                return .yellow
            case .gray:
                return .gray
            case .brown:
                return .brown
            case .cyan:
                return .cyan
            case .mint:
                return .mint
            }
        }

            static func random() -> TextColor {
                return TextColor.allCases.randomElement()! // Now this should work
            }
        }

    
    var name: String
    var totaltime: Double
    var completetime: Double
    var completeness:Double
    var id: UUID
    var color: TextColor
    
    init(name: String,totaltime: Double,completetime:Double){
        self.name=name
        self.totaltime=totaltime
        self.completetime=completetime
        self.completeness=100*completetime/totaltime
        self.color = TextColor.random()
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
        
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.totaltime==rhs.totaltime&&lhs.completetime==rhs.completetime
    }
    enum DecodingError: Error{
        case missingFile
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

func saveUserProfileToKeychain(userProfile: UserProfile) {
    do {
        let jsonData = try JSONEncoder().encode(userProfile)
        
        // Prepare query to search for existing item
        let searchQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userProfileJSON"
        ]
        
        // Update existing item if found, otherwise add a new item
        var status = SecItemUpdate(searchQuery as CFDictionary, [kSecValueData as String: jsonData] as CFDictionary)
        
        if status == errSecItemNotFound {
            // Item not found, add new item
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "userProfileJSON",
                kSecValueData as String: jsonData
            ]
            
            status = SecItemAdd(query as CFDictionary, nil)
        }
        
        guard status == errSecSuccess else {
            print("Error saving user profile to Keychain")
            return
        }
        
        print("User profile saved to Keychain successfully")
    } catch {
        print("Error encoding user profile to JSON: \(error)")
    }
}


extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
} // to calculate completeness of Task better
