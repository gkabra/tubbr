//
//  SearchTracksResponseModel.swift
//  TubbrAssignment
//
//  Created by Gaurav Kabra on 12/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

// MARK: - SearchTracksResponseModel
public struct SearchTracksResponseModel: Codable {
    public let tracks: [Track]
}

// MARK: - Track
public struct Track: Codable {
    public let album: Album
    public let artists: [Artist]
    public let availableMarkets: [String]
    public let discNumber, durationMS: Int
    public let explicit: Bool
    public let externalIDS: ExternalIDS
    public let externalUrls: ExternalUrls
    public let href: String
    public let id: String
    public let isLocal: Bool
    public let name: String
    public let popularity: Int
    public let previewURL: String?
    public let trackNumber: Int
    public let type, uri: String

    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case externalIDS = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isLocal = "is_local"
        case name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type, uri
    }
}

// MARK: - Album
public struct Album: Codable {
    public let albumType: String
    public let artists: [Artist]
    public let availableMarkets: [String]
    public let externalUrls: ExternalUrls
    public let href: String
    public let id: String
    public let images: [Image]
    public let name, releaseDate, releaseDatePrecision: String
    public let totalTracks: Int
    public let type, uri: String

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

// MARK: - Artist
public struct Artist: Codable {
    public let externalUrls: ExternalUrls
    public let href: String
    public let id, name, type, uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}

// MARK: - ExternalUrls
public struct ExternalUrls: Codable {
    public let spotify: String
}

// MARK: - Image
public struct Image: Codable {
    public let height: Int
    public let url: String
    public let width: Int
}

// MARK: - ExternalIDS
public struct ExternalIDS: Codable {
    public let isrc: String
}
