//
//  UpgradeToProView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/22/23.
//

import SwiftUI

struct UpgradeToProView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.yellow.gradient).ignoresSafeArea()
            VStack(alignment: .center){
                Group{
                    Text("Benefits of being a Pro user").font(.title).bold().foregroundStyle(Color.black).fontWeight(.black)
                        .padding(.bottom,40)
                }
                HStack {
                    VStack(alignment:.leading){
                        Text("Standard Version").bold().foregroundStyle(Color.gray).padding(.bottom,40)
                        Divider()
                        Label("No video lessons",systemImage: "lightbulb.slash").foregroundStyle(Color.gray).padding(.bottom)
                        Label("Standard analysis",systemImage: "wrench.adjustable").foregroundStyle(Color.gray).padding(.bottom)
                        Label("No protection",systemImage: "wrongwaysign").foregroundStyle(Color.gray).padding(.bottom)
                        Label("Isolated data",systemImage: "icloud.slash").foregroundStyle(Color.gray).padding(.bottom)
                    }.padding(.trailing,10).padding(.trailing,5)
                    VStack(alignment:.trailing){
                        Label("Pro Version",systemImage: "crown.fill").bold().foregroundStyle(Color.red).padding(.bottom,40)
                        Divider()
                        Label("Video lessons",systemImage: "lightbulb.fill").foregroundStyle(Color.red).padding(.bottom)
                        Label("Better analysis",systemImage: "wrench.and.screwdriver.fill").foregroundStyle(Color.red).padding(.bottom)
                        Label("Better detection",systemImage: "figure.walk.arrival").foregroundStyle(Color.red).padding(.bottom)
                        Label("Share to coach",systemImage: "icloud.fill").foregroundStyle(Color.red).padding(.bottom)
                    }.padding(.leading,10).padding(.trailing,5)
                }
            }
        }
    }
}

#Preview {
    UpgradeToProView()
}

