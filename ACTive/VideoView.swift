//
//  VideoView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/22/23.
//

import SwiftUI
import BetterSafariView

struct LessonView: View {
    @StateObject var user=User()
    var body: some View {
        NavigationStack{
            List{
                Section(header:Text("Videos")){
                    NavigationLink(destination:VideoView()){
                        Text("Behavior Therapy Intro")}
                    NavigationLink(destination:EmptyView()){
                        Text("How to encourage yourself")}}
                
            }.navigationTitle("Lessons for \(user.user.username)")
        }
    }
}


struct VideoView: View {
    @State var presentingSafariView=false
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment:.center){
                    Text("Behavioral therapy is a type of therapy that treats mental health disorders. It's based on the idea that behaviors are learned and can be changed. Behavioral therapy aims to identify and change unhealthy or self-destructive behaviors. Behavioral therapy techniques include: Reinforcement, Punishment, Shaping, Modeling.").padding(50)
                    Button(action: {
                        self.presentingSafariView.toggle()
                    }){
                        Label("Open our the video",systemImage: "safari")
                    }.safariView(isPresented: $presentingSafariView){
                        SafariView(
                            url: URL(string: "https://activeadhd.wordpress.com/2023/12/22/behavior-therapy-introduction/")!,
                        configuration: SafariView.Configuration(
                        barCollapsingEnabled: true))
                    }
                    
                }
                
            }.navigationTitle("Behavior Therapy Intro")
        }
    }
}

#Preview {
    VideoView()
}

