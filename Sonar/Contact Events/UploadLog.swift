//
//  UploadLog.swift
//  Sonar
//
//  Created by NHSX on 4/24/20.
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation

struct UploadLog: Codable, Equatable {
    let date: Date
    let event: Event

    init(date: Date = Date(), event: Event) {
        self.date = date
        self.event = event
    }

    enum Event: Equatable {
        // This startDate and symptoms are optional because we didn't
        // use to store this with the request. Unfortunately, it' non-
        // trivial to strip this out as part of JSON decoding, so we're
        // left with this as a vestigal annoyance.
        case requested(Requested?)

        case started(lastContactEventDate: Date)
        case completed(error: String?)

        var key: String {
            switch self {
            case .requested: return "requested"
            case .started: return "started"
            case .completed: return "completed"
            }
        }
    }

    struct Requested: Equatable {
        let startDate: Date
        let symptoms: Symptoms
    }
}

extension UploadLog.Event: Codable {
    private enum CodingKeys: CodingKey {
        case key
        case startDate
        case symptoms
        case lastContactEventDate
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .key) {
        case "requested":
            var requested: UploadLog.Requested? = nil
            if
                let startDate = try container.decode(Date?.self, forKey: .startDate),
                let symptoms = try container.decode(Symptoms?.self, forKey: .symptoms)
            {
                requested = UploadLog.Requested(startDate: startDate, symptoms: symptoms)
            }
            self = .requested(requested)
        case "started":
            let lastContactEventDate = try container.decode(Date.self, forKey: .lastContactEventDate)
            self = .started(lastContactEventDate: lastContactEventDate)
        case "completed":
            let error = try container.decode(String?.self, forKey: .error)
            self = .completed(error: error)
        default:
            throw Error.invalidCase
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        switch self {
        case .requested(let requested):
            try container.encode(requested?.startDate, forKey: .startDate)
            try container.encode(requested?.symptoms, forKey: .symptoms)
        case .started(let lastContactEventDate):
            try container.encode(lastContactEventDate, forKey: .lastContactEventDate)
        case .completed(let error):
            try container.encode(error, forKey: .error)
        }
    }

    enum Error: Swift.Error {
        case invalidCase
    }
}
