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
        fileprivate let items: [Photo]?
        fileprivate let metadata: MetaData?
        
        fileprivate struct MetaData: Decodable {
            fileprivate let total_hits: Int?
        }
    }
    
    func getAllImages() -> [Photo]? {
        return collection?.items
    }
    
    func getNumberOfResults() -> Int {
        return collection?.metadata?.total_hits ?? 0
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



