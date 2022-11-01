//
//  SearchResult.swift
//  PhotoGallery
//
//  Created by Elena Pavlova on 01.11.2022.
//

import Foundation

struct SearchResult: Decodable {
    let total: Int
    let results: [Photo]
}

struct Photo: Decodable {
    let width: Int
    let height: Int
    let urls: [URLKind.RawValue : String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
