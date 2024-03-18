//
//  LessonView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/21/23.
//

import SwiftUI

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

#Preview {
    LessonView()
}
