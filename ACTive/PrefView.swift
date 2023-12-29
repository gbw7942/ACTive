//
//  AccountView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/21/23.
//

import SwiftUI

struct PrefView: View {
    @State var detectQuitAction=false
    @StateObject var user=User()
    @Binding var isPro:Bool
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Account")){
                    NavigationLink(destination: MeView().environmentObject(user)){
                        Label("Me",systemImage: "person")}
                    NavigationLink(destination: EmptyView()){
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
