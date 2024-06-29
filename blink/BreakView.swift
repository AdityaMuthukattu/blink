//
//  BreakView.swift
//  blink
//
//  Created by Aditya Muthukattu on 29/6/2024.
//
import Foundation
import SwiftUI
struct BreakView: View {
    var body: some View {
        VStack {
            Text("Take a break!")
                .font(.largeTitle)
                .padding()
            Text("Relax for a few moments.")
                .font(.title)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BreakView_Previews: PreviewProvider {
    static var previews: some View {
        BreakView()
    }
}
