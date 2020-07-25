//
//  TranslatorVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class TranslatorVC: UIViewController {

    // MARK: - IBOutlet properties

    @IBOutlet var languageLabels: [UILabel]!
    @IBOutlet var textViews: [UITextView]!

    // MARK: - Properties

    private var httpClient = HTTPClient()
    private var languages: [Language] = []

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setPlaceholders()
        fetchLanguages()
        textViews.first?.delegate = self
    }

    // MARK: - IBAction methods

    @IBAction func detectLanguageTapped(_ sender: UIButton) {
        guard let textToDetext = textViews.first?.text else { return }
        httpClient.request(baseUrl: K.baseURLdetect, parameters: [K.googleQuery, (K.query, textToDetext)]) { self.manageDetectResult(with: $0) }
    }

    @IBAction func swapLanguagesTapped(_ sender: UIButton) {
        guard languageLabelsAreNotEmpty() else { return }
        swapLanguageLabelsText()
    }


    @IBAction func translateTapped(_ sender: UIButton) {
        guard isTranslationPossible() else { return }
        performTranslation()
    }

    // MARK: - Managing request result Methods

    private func manageDetectResult(with result: Result<DetectData, RequestError>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.setAlertVc(with: error.description)
            }
        case .success(let result):
            DispatchQueue.main.async {
                guard let detectedLanguage = result.data.detections.first?.first?.language else { return }
                let language = self.getLanguageName(from: detectedLanguage)
                self.languageLabels.first?.text = language
            }
        }
    }

    private func manageLanguagesResult(with result: Result<LanguageData, RequestError>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.setAlertVc(with: error.description)
            }
        case .success(let result):
            DispatchQueue.main.async {
                self.languages = result.data.languages
            }
        }
    }

    private func manageTranslateResult(with result: Result<TranslateData, RequestError>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.setAlertVc(with: error.description)
            }
        case .success(let result):
            DispatchQueue.main.async {
                let detectedLanguageCode = result.data.translations.first?.detectedSourceLanguage
                let detectedLanguage = self.getLanguageName(from: detectedLanguageCode ?? "N/A")
                self.languageLabels.first?.text = detectedLanguage
                self.textViews.last?.text = result.data.translations.first?.translatedText
            }
        }
    }

    // MARK: - Methods

    private func fetchLanguages() {
        let deviceLanguage = Locale.current.languageCode ?? "en"
        httpClient.request(baseUrl: K.baseURLlanguages, parameters: [K.googleQuery, (K.target, deviceLanguage)]) { self.manageLanguagesResult(with: $0)}
    }

    private func swapLanguageLabelsText() {
        let firstLanguage = languageLabels.first?.text
        languageLabels.first?.text = languageLabels.last?.text
        languageLabels.last?.text = firstLanguage
    }

    private func languageLabelsAreNotEmpty() -> Bool {
        guard languageLabels.first?.text != "N/A",
            languageLabels.last?.text != "N/A" else {
                setAlertVc(with: "At least one language is missing for translation, please set your languages")
                return false
        }
        return true
    }

    private func isTranslationPossible() -> Bool {
        guard textViews.first?.textColor != UIColor.lightGray else {
            setAlertVc(with: "Type a text to translate.")
            return false
        }
        guard languageLabels.last?.text != "N/A" else {
            setAlertVc(with: "Choose a language to translate to.")
            return false
        }
        return true
    }

    private func performTranslation() {
        guard let textToTranslate = textViews.first?.text,
            let language = languageLabels.last?.text else { return }
        let targetLanguage = getLanguageCode(from: language)
        // Should managage source language ??
        httpClient.request(baseUrl: K.baseURLtranslate, parameters: [K.googleQuery, (K.query, textToTranslate), (K.target, targetLanguage), K.textFormat]) { self.manageTranslateResult(with: $0) }
    }


    private func getLanguageCode(from language: String) -> String {
        return languages.first(where: { $0.name == language })?.language ?? ""
    }

    private func getLanguageName(from code: String) -> String {
        return languages.first(where: { $0.language == code })?.name ?? "N/A"
    }

    private func setPlaceholders() {
        textViews.first?.text = "Type text to translate here..."
        textViews.first?.textColor = UIColor.lightGray
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVc = segue.destination as? LanguagesTable else { return }
        destinationVc.senderTag = (sender as? UIButton)?.tag
        destinationVc.languages = languages
        destinationVc.senderVC = self
    }
}

extension TranslatorVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text == "\n" else { return true }
        textView.resignFirstResponder()
        return false
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type text to translate here..."
            textView.textColor = UIColor.lightGray
            textViews.last?.text.removeAll()
        }
    }
}
