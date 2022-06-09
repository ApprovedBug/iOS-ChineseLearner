//
//  AddWordView.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 27/01/2022
//

import Foundation
import SwiftUI

struct AddWordView: View {

    @Environment(\.dismiss) var dismiss
    @ObservedObject private(set) var viewModel: AddWordViewModel

    init(viewModel: AddWordViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        VStack {
            TextField("Chinese", text: $viewModel.chinese)
                .textFieldStyle(.roundedBorder)
            TextField("Pinyin", text: $viewModel.pinyin)
                .textFieldStyle(.roundedBorder)
            TextField("English", text: $viewModel.english)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0))

            Button(action: viewModel.add) {
                HStack {
                    Spacer()
                    Text("Add")
                    Spacer()
                }
            }
            .navigationTitle("Add new word")
            .buttonStyle(LightGreyButtonStyle())
            .alert(isPresented: .constant(viewModel.state == .error)) {
                Alert(title: Text("Error"),
                    message: Text("Please fill in all fields"),
                    dismissButton: Alert.Button.default(
                        Text("Ok"), action: {
                            viewModel.dismissError()
                        }
                    )
                )
            }
            .onReceive(viewModel.$state) { state in
                if state == .complete {
                    dismiss()
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct AddWordView_Previews: PreviewProvider {

    static var previews: some View {

        let viewModel = AddWordViewModel(
            persistenceController: PersistenceController()
        )
        NavigationView {
            AddWordView(viewModel: viewModel)
        }
    }
}
