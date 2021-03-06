//
//  DictionaryView.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 27/01/2022
//

import SwiftUI

struct DictionaryView: View {

    @ObservedObject private(set) var viewModel: DictionaryViewModel

    init(viewModel: DictionaryViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .idle:
                    ProgressView()
                        .onAppear(perform: viewModel.fetchWords)
                case .loading:
                    ProgressView()
                case .ready(let letterSections):
                    loadedView(letterSections: letterSections)
                case .empty:
                    emptyView
                case .failed(let error):
                    Text("Error loading content - \(error.localizedDescription)")
                }
            }
            .navigationBarTitle("Your dictionary")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.addTapped()
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingSheet) {
                NavigationView {
                    AddWordView(
                        viewModel: AddWordViewModel(
                            viewContext: viewModel.viewContext
                        )
                    )
                }
            }
        }
    }
}

extension DictionaryView {

    private var emptyView: some View {

        VStack(alignment: .leading) {
            Text("Welcome to your dictionary!\n\nThis section contains all the words in your vocabulary that you would like to memorise. Tap the add button to get started!")
                .padding(.bottom, 32)
            Button(action: viewModel.addTapped) {
                HStack {
                    Spacer()
                    Text("Add word")
                    Spacer()
                }
            }
            .buttonStyle(LightGreyButtonStyle())
            Spacer()
        }
        .padding()
    }


    private func loadedView(letterSections: [LetterSectionViewModel]) -> some View {
        VStack(alignment: .leading) {
            Text(viewModel.resultsCount)
                .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 0))
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                .font(.footnote)
            List(letterSections) { section in

                if letterSections.count > 1 {
                    Section(header: Text(section.letter)) {
                        ForEach(section.words) { word in
                            WordRowView(viewModel: word)
                        }
                        .onDelete { indexSet in
                            viewModel.delete(from: section, at: indexSet)
                        }
                    }
                } else {
                    ForEach(section.words) { word in
                        WordRowView(viewModel: word)
                    }
                    .onDelete { indexSet in
                        viewModel.delete(from: section, at: indexSet)
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .listStyle(.insetGrouped)
            .animation(.default, value: 0.3)
        }
    }
}
