//
//  CoachView.swift
//  ACTive
//
//  Created by Gabriel Wang on 12/21/23.
//

import SwiftUI

struct CoachView: View {
    @State var selectedDate = Date()
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 100, to: Date())!
        return min...max
    }
    var body: some View {
        VStack(){
            HStack(alignment:.top){
                Image(systemName: "person.fill").font(.title).bold()
                Text("Meeting with Dr. Lee").font(.title)
            }.padding(.bottom,20)
            Text("Records").font(.footnote)
            CoachRecordsView()
            HStack{
                DatePicker(
                        selection: $selectedDate, in: dateRange,
                        displayedComponents: [.hourAndMinute, .date],
                        label: {
                            Label("Add another",systemImage: "plus.bubble")
                        }).padding()
            }
        }
    }
}

#Preview {
    CoachView()
}
