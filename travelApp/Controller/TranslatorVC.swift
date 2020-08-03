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
    private var defaults = UserDefaults.standard
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setPlaceholders()
        requestLanguages()
        languageLabels.last?.text = defaults.string(forKey: K.language) ?? K.defaultLanguage

        NotificationCenter.default.addObserver(self, selector: #selector(updateDefaultLanguage(notification:)), name: .updateLanguage, object: nil)
    }
    
    // MARK: - IBAction methods
    
    @IBAction func detectButtonTapped(_ sender: UIButton) {
        guard let textToDetext = textViews.first?.text else { return }
        httpClient.request(baseUrl: K.baseURLdetect, parameters: [K.googleQuery, (K.query, textToDetext)]) { [unowned self] result in
            self.manageResult(dataType: DetectData.self, with: result)
        }
    }
    
    @IBAction func swapButtonTapped(_ sender: UIButton) {
        guard languageLabelsAreNotEmpty() else { return }
        swapLanguageLabelsText()
        swapTextViewsText()
    }
    
    
    @IBAction func translateButtonTapped(_ sender: UIButton?) {
        guard isTranslationPossible() else { return }
        let parameters = getTranslationParameters()
        requestTranslation(with: parameters)
    }
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        textViews.forEach { $0.text.removeAll() }
    }

    // MARK: - @objc method

    @objc
    func updateDefaultLanguage(notification: Notification) {
        guard let language = notification.userInfo?[K.language] as? String else { return }
        languageLabels.last?.text = language
        textViews.forEach { $0.text.removeAll() }
    }
    
    // MARK: - Managing request result Methods
    
    private func manageResult<T>(dataType: T.Type, with result: Result<T, RequestError>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.setAlertVc(with: error.description)
            }
        case .success(let data):
            DispatchQueue.main.async {
                self.manageSucces(with: data)
            }
        }
    }
    
    // switch on data type, and update UI accordingly
    func manageSucces<T>(with data: T) {
        switch data {
        case let languageData as LanguageData:
            languages = languageData.data.languages
        case let translateData as TranslateData:
            if let detectedLanguageCode = translateData.data.translations.first?.detectedSourceLanguage {
                let detectedLanguage = getLanguageName(from: detectedLanguageCode)
                languageLabels.first?.text = detectedLanguage
            }
            textViews.last?.text = translateData.data.translations.first?.translatedText
        case let detectData as DetectData:
            guard let detectedLanguage = detectData.data.detections.first?.first?.language else { return }
            let language = getLanguageName(from: detectedLanguage)
            languageLabels.first?.text = language
        default: break
        }
    }
    
    // MARK: - Methods
    
    private func requestLanguages() {
        let deviceLanguage = Locale.current.languageCode ?? K.defaultLanguages
        httpClient.request(baseUrl: K.baseURLlanguages, parameters: [K.googleQuery, (K.target, deviceLanguage)]) { [unowned self] result in
            self.manageResult(dataType: LanguageData.self, with: result)}
    }
    
    private func swapLanguageLabelsText() {
        let firstLanguage = languageLabels.first?.text
        languageLabels.first?.text = languageLabels.last?.text
        languageLabels.last?.text = firstLanguage
    }
    
    private func swapTextViewsText() {
        let firstText = textViews.first?.text
        textViews.first?.text = textViews.last?.text
        textViews.last?.text = firstText
    }
    
    private func languageLabelsAreNotEmpty() -> Bool {
        guard languageLabels.first?.text != K.NA,
            languageLabels.last?.text != K.NA else {
                setAlertVc(with: K.missingLanguages)
                return false
        }
        return true
    }
    
    private func isTranslationPossible() -> Bool {
        guard textViews.first?.textColor != UIColor.lightGray else {
            setAlertVc(with: K.missingText)
            return false
        }
        guard languageLabels.last?.text != K.NA else {
            setAlertVc(with: K.missingTranslateLanguage)
            return false
        }
        return true
    }
    
    private func getTranslationParameters() -> [(String, String)] {
        guard let textToTranslate = textViews.first?.text,
            let language = languageLabels.last?.text else { return [] }
        let targetLanguage = getLanguageCode(from: language)
        var parameters = [K.googleQuery, (K.query, textToTranslate), (K.target, targetLanguage), K.textFormat]
        guard languageLabels.first?.text != K.NA,
            let sourceLanguage = languageLabels.first?.text else {
                return parameters
        }
        let sourceLanguageCode = getLanguageCode(from: sourceLanguage)
        parameters.append((K.source, sourceLanguageCode))
        return parameters
    }
    
    private func requestTranslation(with parameters: [(String, String)]) {
        httpClient.request(baseUrl: K.baseURLtranslate, parameters: parameters) { [unowned self] result in
            self.manageResult(dataType: TranslateData.self, with: result)}
    }
    
    private func getLanguageCode(from language: String) -> String {
        return languages.first(where: { $0.name == language })?.language ?? K.emptyString
    }
    
    private func getLanguageName(from code: String) -> String {
        return languages.first(where: { $0.language == code })?.name ?? K.NA
    }
    
    private func setPlaceholders() {
        textViews.first?.text = K.typeHere
        textViews.first?.textColor = UIColor.lightGray
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVc = segue.destination as? LanguagesTableVC else { return }
        destinationVc.senderTag = (sender as? UIButton)?.tag
        destinationVc.languages = languages
        destinationVc.delegate = self
    }
}

// MARK: - UITextViewDelegate

extension TranslatorVC: UITextViewDelegate {
    // dismiss keyboard when return key is tapped
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text == K.returnKey else { return true }
        textView.resignFirstResponder()
        if languageLabels.last?.text != K.NA { translateButtonTapped(nil) }
        return false
    }
    
    // fake placeholder set up for textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = K.typeHere
            textView.textColor = UIColor.lightGray
            textViews.last?.text.removeAll()
        }
    }
}

extension TranslatorVC: LanguagesProtocol {
    func didUpdateLanguage(for tag: Int, with language: String) {
        languageLabels[tag].text = language
    }
}
