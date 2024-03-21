//
//  AccountView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/21/23.
//

import SwiftUI

struct PrefView: View {
    @State var detectQuitAction=false
    @ObservedObject var user: User
    @Binding var isPro:Bool
//    @Binding var isCoach:Bool
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Account")){
                    NavigationLink(destination: MeView().environmentObject(user)){
                        Label("Me",systemImage: "person")}
                      NavigationLink(destination: TaskSettingView()){
                        Label("Tasks",systemImage: "square.and.pencil")}
                }
                Section(header:Text("Advanced")){
                    Toggle(isOn: $detectQuitAction, label: {
                        Label("Quitting Action Detection",systemImage: "figure.walk.arrival")})
                    Label(isPro ? "Lesson is unlocked." : "Lesson available for Pro.",systemImage: "person.2")
                }
                    Section(header: Text("ACTive")){
                        NavigationLink(destination: AboutUsView()){
                            Label("About us",systemImage: "person.3.sequence")}
                        NavigationLink(destination: EmptyView()){
                            Label("Contact us",systemImage: "ellipsis.message")}
                    }
                Section(header: Text("Debug")){
                    Toggle(isOn: $isPro, label: {
                        Label("Is Pro user",systemImage: "crown")
                    })
                    .onChange(of: isPro){ newValue in
                        user.user.isPro = newValue
                    }
//                    Toggle(isOn: $isCoach, label: {
//                        Text("Is Coach")
//                    })
//                    NavigationLink(destination: ReportView().environmentObject(user)){
//                        Text("View the coach's screen").opacity(isCoach==false ? 0 : 1)
//                    } //this is demo for Coach
                    }
                }
            .navigationTitle("Preferences")
        }
    }
}

//struct Prefiew_previews: PreviewProvider{
//    static var previews: some View{
//        PrefView()
//    }
//}
