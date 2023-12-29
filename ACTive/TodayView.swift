//
//  ContentView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/21/23.
//

import SwiftUI
import SwiftData
import Foundation

struct TodayView: View {
    @StateObject var user=User()
    @StateObject var AllTasks:TaskStore
    var body: some View{
        NavigationStack{
            ScrollView{
                VStack(alignment:.center){
                    CircularProgressView()
                    Divider()
                    VStack(alignment:.leading){
                        Text("Reading")
                        ProgressView(value: 32,total: 60){ Text("53%").font(.footnote) }
                            .frame(width: 300)
                            .tint(Color.green)
                            .animation(.easeOut, value: 0.53)
                    }.padding(.bottom,10)
                    VStack(alignment:.leading){
                        Text("Math")
                        ProgressView(value: 3,total: 45){
                            Text("7%").font(.footnote)}
                        .frame(width: 300)
                        .tint(Color.red)
                        .animation(.easeOut, value: 0.07)
                    }.padding(.bottom,10)
                    VStack(alignment:.leading){
                        Text("Science")
                        ProgressView(value: 21,total: 45){
                            Text("47%").font(.footnote)}
                        .frame(width: 300)
                        .tint(Color.blue)
                        .animation(.easeOut, value: 0.47)
                    }.padding(.bottom,10)
                    VStack(alignment:.leading){
                        Text("History")
                        ProgressView(value: 39,total: 50){
                            Text("78%").font(.footnote)}
                        .frame(width: 300)
                        .tint(Color.brown)
                        .animation(.easeOut, value: 0.78)
                    }.padding(.bottom,10)
                    VStack(alignment:.leading){
                        Text("Art")
                        ProgressView(value: 17,total: 30){
                            Text("57%").font(.footnote)}
                        .frame(width: 300)
                        .tint(Color.yellow)
                        .animation(.easeOut, value: 0.57)
                    }.padding(.bottom,10)
                    }

            }
            .toolbar{
                ToolbarItem(placement: .navigation){
                    VStack(alignment:.leading){
                        Text("Hi, \(user.user.username)").font(.footnote)
                        Text("\(dateFormat())").font(.footnote)
                        Spacer()
                    }
                }
            }.navigationTitle("Today")
        }
    }
}

#Preview {
    TodayView()
}

func dateFormat()->String{
    let date=Date()
    let dateFormatter=DateFormatter()
    dateFormatter.locale=Locale.current
    dateFormatter.dateStyle = .short
    return dateFormatter.string(from: date)
}
