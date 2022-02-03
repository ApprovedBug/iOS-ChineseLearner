//
//  DictionaryViewModelMock.swift
//  ChineseLearnerTests
//
//  Created by ApprovedBug on 03/02/2022
//

import Foundation
@testable import ChineseLearner

class DictionaryViewModelMock: DictionaryViewModel {

    var isDisplayFilteredWordsCalled = false

    override func displayFilteredWords() {
        super.displayFilteredWords()
        isDisplayFilteredWordsCalled = true
    }
}
