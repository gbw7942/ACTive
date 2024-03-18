//
//  MeView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/28/23.
//

import SwiftUI

struct MeView: View {
    @EnvironmentObject var user:User
    var body: some View {
        NavigationStack{
            if user.user.isPro==true{
                Label("You are already a pro user.",systemImage: "crown")}
            else{
                    Text("You are still a standard user.")
                }
            NavigationLink(destination: UpgradeToProView()){Label("What's the difference between Pro and Standard?",systemImage: "questionmark.square")}
                .navigationTitle("\(user.user.username)")
            }
        }
    }

struct Meview_previews: PreviewProvider{
    static var previews: some View{
        MeView()
    }
}


