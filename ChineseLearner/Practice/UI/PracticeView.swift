//
//  PracticeView.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 30/01/2022
//

import Foundation
import SwiftUI

struct PracticeView: View {

    @ObservedObject private var viewModel: PracticeViewModel

    init(viewModel: PracticeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .ready:
                    readyView
                case .practiceReady(let question):
                    testView(question: question)
                case .practiceCorrect(let question):
                    testView(question: question, success: true)
                case .practiceIncorrect(let question):
                    testView(question: question, failed: true)
                case .summary(let correctAnswers, let skippedQuestions):
                    summaryView(correctAnswers: correctAnswers, skippedQuestions: skippedQuestions)
                }
            }
            .navigationBarTitle("Practice")
        }
    }
}

extension PracticeView {
    private var readyView: some View {
        VStack(alignment: .leading) {
            Text("Welcome to the practice section!\n\nHere you can put your skills to the test by attempting to translate the words you have already added into your vocabulary.")
                .padding(.bottom, 32)
            Button(action: viewModel.beginPractice) {
                HStack {
                    Spacer()
                    Text("Begin practice")
                    Spacer()
                }
            }
            .buttonStyle(LightGreyButtonStyle())
            Spacer()
        }
        .padding()
    }

    private func testView(question: String, success: Bool = false, failed: Bool = false) -> some View {
        VStack(alignment: .leading) {
            Text("Translate the word")
                .font(.headline)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
            Text(question)
                .font(.subheadline)
            TextField("Chinese", text: $viewModel.chineseAnswer)
                .textFieldStyle(ValidatedTextFieldStyle(state: success ? .correct : failed ? .incorrect : .ready))
            TextField("Pinyin", text: $viewModel.pinyinAnswer)
                .textFieldStyle(ValidatedTextFieldStyle(state: success ? .correct : failed ? .incorrect : .ready))
            VStack(alignment: .leading) {
                Button(action: viewModel.checkAnswer) {
                    HStack {
                        Spacer()
                        Text("Check")
                        Spacer()
                    }
                }
                .buttonStyle(LightGreyButtonStyle())

                Button(action: viewModel.skip) {
                    HStack {
                        Spacer()
                        Text("Skip")
                        Spacer()
                    }
                }
                .buttonStyle(LightGreyButtonStyle())

                Button(action: viewModel.endPractice) {
                    HStack {
                        Spacer()
                        Text("Finish practice")
                        Spacer()
                    }
                }
                .buttonStyle(DarkGreyButtonStyle())
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
            Spacer()
            .frame(maxWidth: .infinity)
        }
        .padding()
    }

    private func summaryView(correctAnswers: Int, skippedQuestions: Int) -> some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("Your score\n\(correctAnswers)/\(correctAnswers + skippedQuestions)")
                .font(.system(size: 50))
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                .frame(maxWidth: .infinity)
            Text("Well done for studying today, see you again tomorrow!")
                .padding(.top, 24)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            Spacer()
            Button(action: viewModel.closeSummary) {
                HStack {
                    Spacer()
                    Text("Close")
                    Spacer()
                }
            }
            .buttonStyle(DarkGreyButtonStyle())
        }
        .padding()
    }
}
