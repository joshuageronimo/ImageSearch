//
//  Photo.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/1/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import Foundation

/// model for the api response
struct APIResponse: Decodable {
    fileprivate let collection: Collection?

    fileprivate struct Collection: Decodable {
        let items: [Photo]?
    }
    
    func getAllImages() -> [Photo]? {
        return collection?.items
    }
}

/// model for Photo
struct Photo: Decodable {
    fileprivate let links: [Link]?
    fileprivate let data: [ImageInfo]?


    fileprivate struct Link: Decodable {
        let href: String?
    }
    
    struct ImageInfo: Decodable {
        let title: String?
        let photographer: String?
        let description: String?
        let location: String?
    }
    
    func getImageLink() -> String? {
        return links?.first?.href
    }
    
    func getImageInfo() -> ImageInfo? {
        return data?.first
    }
}



