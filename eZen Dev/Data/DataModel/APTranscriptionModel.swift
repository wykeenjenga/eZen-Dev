//
//  APTranscriptionModel.swift
//  eZen Dev
//
//  Created by Wykee on 04/01/2023.
//  Copyright © 2023 Music of Wisdom. All rights reserved.
//

import Foundation

// MARK: - APTranscriptionModel
struct APTranscriptionModel: Codable {
    let metadata: Metadata
    let results: Results
}

// MARK: - Metadata
struct Metadata: Codable {
    let transactionKey, requestID, sha256, created: String
    let duration: Double
    let channels: Int
    let models: [String]
    let modelInfo: ModelInfo

    enum CodingKeys: String, CodingKey {
        case transactionKey = "transaction_key"
        case requestID = "request_id"
        case sha256, created, duration, channels, models
        case modelInfo = "model_info"
    }
}

// MARK: - ModelInfo
struct ModelInfo: Codable {
    let c12089D007664Ca0951198Fd2E443Ebd: C12089D007664Ca0951198Fd2E443Ebd

    enum CodingKeys: String, CodingKey {
        case c12089D007664Ca0951198Fd2E443Ebd = "c12089d0-0766-4ca0-9511-98fd2e443ebd"
    }
}

// MARK: - C12089D007664Ca0951198Fd2E443Ebd
struct C12089D007664Ca0951198Fd2E443Ebd: Codable {
    let name, version, tier: String
}

// MARK: - Results
struct Results: Codable {
    let channels: [Channel]
}

// MARK: - Channel
struct Channel: Codable {
    let alternatives: [Alternative]
}

// MARK: - Alternative
struct Alternative: Codable {
    let transcript: String
    let confidence: Double
    let words: [Word]
}

// MARK: - Word
struct Word: Codable {
    let word: String
    let start, end, confidence: Double
    let punctuatedWord: String

    enum CodingKeys: String, CodingKey {
        case word, start, end, confidence
        case punctuatedWord = "punctuated_word"
    }
}
