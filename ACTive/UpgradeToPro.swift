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
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 20) {
                Text("Benefits of Being a Pro User")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                HStack(spacing: 20) {
                    featureColumn(title: "Standard Version", features: [
                        ("No video lessons", "lightbulb.slash"),
                        ("Standard analysis", "wrench.adjustable"),
                        ("No protection", "wrongwaysign"),
                        ("Isolated data", "icloud.slash")
                    ], textColor: Color.gray)
                    
                    featureColumn(title: "Pro Version", features: [
                        ("Video lessons", "lightbulb.fill"),
                        ("Better analysis", "wrench.and.screwdriver.fill"),
                        ("Better detection", "figure.walk.arrival"),
                        ("Share to coach", "icloud.fill")
                    ], textColor: Color.green)
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            .padding()
        }
    }
    
    private func featureColumn(title: String, features: [(String, String)], textColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .bold()
                .padding(.bottom, 5)
            
            ForEach(features, id: \.0) { feature in
                Label(feature.0, systemImage: feature.1)
                    .foregroundColor(textColor)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.3)))
        .shadow(radius: 3)
    }
}

struct UpgradeToProView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeToProView()
    }
}
