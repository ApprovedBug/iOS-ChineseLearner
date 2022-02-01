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
            Form {
                TextField("Chinese", text: $viewModel.chinese)
                TextField("Pinyin", text: $viewModel.pinyin)
                TextField("English", text: $viewModel.english)
                    .autocapitalization(.none)

                Button("Add word") {
                    viewModel.add()
                }
                .centerHorizontally()
                .navigationTitle("Add new word")
            }
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
        }
    }
}

struct AddWordView_Previews: PreviewProvider {

    static var previews: some View {

        let viewModel = AddWordViewModel(
            viewContext: PersistenceController().mainContext
        )
        NavigationView {
            AddWordView(viewModel: viewModel)
        }
    }
}
