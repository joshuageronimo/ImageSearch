//
//  Photo.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/1/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import Foundation

struct NASAImageAPI: Decodable {
    let collection: Collection

    struct Collection: Decodable {
        let items: [Photo]
    }
    
    func getAllImages() -> [Photo] {
        return collection.items
    }
}

struct Photo: Decodable {
    let links: [Link]
    let data: [ImageInfo]


    struct Link: Decodable {
        let link: String
    }
    
    struct ImageInfo: Decodable {
        let title: String
        let photographer: String
        let description: String
        let location: String
    }
}



