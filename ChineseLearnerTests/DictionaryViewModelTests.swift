//
//  DictionaryViewModelTests.swift
//  ChineseLearnerTests
//
//  Created by ApprovedBug on 01/02/2022
//

import Foundation
import XCTest
@testable import ChineseLearner

class DictionaryViewModelTests: XCTestCase {

    let persistenceController = TestPersistenceController()
    var viewModel: DictionaryViewModelMock!

    override func setUp() {

        viewModel = DictionaryViewModelMock(persistenceController: persistenceController)
    }

    func testInit() {

        XCTAssertTrue(viewModel.state == .idle)
    }

    func testFetchWords_emptyList() {
        viewModel.fetchWords()

        XCTAssertEqual(viewModel.state, .empty)
    }

    func testFetchWords_withResults() {
        let word = WordMO(context: persistenceController.mainContext)

        viewModel.fetchWords()

        let letterSections = viewModel.createLetterSections(from: [word])

        XCTAssertEqual(viewModel.state, .ready(letterSections))
    }

    func testFetchWords_withFilter_results() {
        let firstWord = WordMO(context: persistenceController.mainContext)
        firstWord.english = "english"
        firstWord.pinyin = "pinyin"
        firstWord.chinese = "chinese"

        let secondWord = WordMO(context: persistenceController.mainContext)
        secondWord.english = "foo"
        secondWord.pinyin = "bar"
        secondWord.chinese = "chinese"

        viewModel.searchText = "english"

        viewModel.fetchWords()

        let letterSections = viewModel.createLetterSections(from: [firstWord])

        XCTAssertEqual(viewModel.state, .ready(letterSections))
    }

    func testFetchWords_withFilter_noResults() {
        let firstWord = WordMO(context: persistenceController.mainContext)
        firstWord.english = "english"
        firstWord.pinyin = "pinyin"
        firstWord.chinese = "chinese"

        let secondWord = WordMO(context: persistenceController.mainContext)
        secondWord.english = "foo"
        secondWord.pinyin = "bar"
        secondWord.chinese = "chinese"

        viewModel.searchText = "empty"

        viewModel.fetchWords()

        XCTAssertEqual(viewModel.state, .ready([]))
    }

    func testCreateLetterSections_oneSection_oneWord() throws {

        let word = WordMO(context: persistenceController.mainContext)
        word.english = "english"
        word.pinyin = "pinyin"
        word.chinese = "chinese"

        let letterSections = viewModel.createLetterSections(from: [word])

        XCTAssertTrue(letterSections.count == 1)

        let firstSection = try XCTUnwrap(letterSections.first)

        XCTAssertTrue(firstSection.letter == "e")

        let firstWord = try XCTUnwrap(firstSection.words.first)
        
        XCTAssertTrue(firstWord.english == "english")
        XCTAssertTrue(firstWord.pinyin == "pinyin")
        XCTAssertTrue(firstWord.chinese == "chinese")
    }

    func testCreateLetterSections_oneSection_twoWords() throws {

        let word = WordMO(context: persistenceController.mainContext)
        word.english = "english"
        word.pinyin = "pinyin"
        word.chinese = "chinese"

        let letterSections = viewModel.createLetterSections(from: [word])

        XCTAssertTrue(letterSections.count == 1)

        let firstSection = try XCTUnwrap(letterSections.first)

        XCTAssertTrue(firstSection.letter == "e")

        let firstWord = try XCTUnwrap(firstSection.words.first)

        XCTAssertTrue(firstWord.english == "english")
        XCTAssertTrue(firstWord.pinyin == "pinyin")
        XCTAssertTrue(firstWord.chinese == "chinese")
    }

    func testCreateLetterSections_twoSections_twoWords() throws {

        let firstWord = WordMO(context: persistenceController.mainContext)
        firstWord.english = "english"
        firstWord.pinyin = "pinyin"
        firstWord.chinese = "chinese"

        let secondWord = WordMO(context: persistenceController.mainContext)
        secondWord.english = "hello"
        secondWord.pinyin = "nihao"
        secondWord.chinese = "你好"

        let letterSections = viewModel.createLetterSections(from: [firstWord, secondWord])

        XCTAssertTrue(letterSections.count == 2)

        let firstSection = try XCTUnwrap(letterSections.first)

        XCTAssertTrue(firstSection.letter == "e")
        XCTAssertTrue(firstSection.words.count == 1)
        let firstSectionWord = try XCTUnwrap(firstSection.words.first)

        XCTAssertTrue(firstSectionWord.english == "english")
        XCTAssertTrue(firstSectionWord.pinyin == "pinyin")
        XCTAssertTrue(firstSectionWord.chinese == "chinese")

        let secondSection = try XCTUnwrap(letterSections.last)

        XCTAssertTrue(secondSection.letter == "h")
        XCTAssertTrue(secondSection.words.count == 1)
        let secondSectionWord = try XCTUnwrap(secondSection.words.first)

        XCTAssertTrue(secondSectionWord.english == "hello")
        XCTAssertTrue(secondSectionWord.pinyin == "nihao")
        XCTAssertTrue(secondSectionWord.chinese == "你好")
    }

    func testFilterWords() throws {
        let firstWord = WordMO(context: persistenceController.mainContext)
        firstWord.english = "english"
        firstWord.pinyin = "pinyin"
        firstWord.chinese = "chinese"

        let secondWord = WordMO(context: persistenceController.mainContext)
        secondWord.english = "foo"
        secondWord.pinyin = "bar"
        secondWord.chinese = "chinese"

        let words = viewModel.filteredWords(words: [firstWord, secondWord], filter: "eng")

        XCTAssertTrue(words.count == 1)

        let filteredWord = try XCTUnwrap(words.first)

        XCTAssertEqual(filteredWord.english, "english")
        XCTAssertEqual(filteredWord.chinese, "chinese")
        XCTAssertEqual(filteredWord.pinyin, "pinyin")
    }

    func testAddTapped() {

        viewModel.addTapped()

        XCTAssertTrue(viewModel.isShowingSheet)
    }

    func testDisplayBeforeFetchFails() {
        viewModel.displayFilteredWords()

        XCTAssertEqual(viewModel.state, .failed(.noResults("Display called before fetch")))
    }

    func testDeleteWord() throws {

        let request = WordMO.fetchRequest()
        request.sortDescriptors = []

        var fetchResultsCount = try persistenceController.mainContext.count(for: request)

        XCTAssertEqual(fetchResultsCount, 0)

        let word = WordMO(context: persistenceController.mainContext)
        word.english = "english"
        word.pinyin = "pinyin"
        word.chinese = "chinese"

        fetchResultsCount = try persistenceController.mainContext.count(for: request)

        XCTAssertEqual(fetchResultsCount, 1)

        let letterSection = try XCTUnwrap(viewModel.createLetterSections(from: [word]).first)

        viewModel.delete(from: letterSection, at: IndexSet(integer: 0))

        fetchResultsCount = try persistenceController.mainContext.count(for: request)

        XCTAssertEqual(fetchResultsCount, 0)
    }

    func testDisplayResultsCalledWhenSearchTextChanged() {

        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertFalse(viewModel.isDisplayFilteredWordsCalled)

        viewModel.searchText = "first search"

        let expectation = expectation(description: "Listen for display results called")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            if self.viewModel.isDisplayFilteredWordsCalled {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.5)
    }
}
