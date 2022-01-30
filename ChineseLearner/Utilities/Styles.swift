//
//  Styles.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 30/01/2022
//

import Foundation
import SwiftUI


// MARK: - Text field styles

struct ValidatedTextFieldStyle: TextFieldStyle {

    enum State {
        case ready
        case correct
        case incorrect
    }

    var state: State = .ready

    init(state: State) {
        self.state = state
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 0.5)
                .foregroundColor(state == .ready ? Color(red: 0.9, green: 0.9, blue: 0.9) : state == .correct ? .green : .red))
    }
}

// MARK: - Button styles

struct LightGreyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0.25, green: 0.25, blue: 0.25)).opacity(configuration.isPressed ? 0.8 : 1)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .frame(maxWidth: .infinity)
    }
}

struct DarkGreyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0.15, green: 0.15, blue: 0.15)).opacity(configuration.isPressed ? 0.8 : 1)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .frame(maxWidth: .infinity)
    }
}
