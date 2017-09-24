//
//  Quote.swift
//  CarpeDiem
//
//  Created by Eric Mao on 2/12/17.
//  Copyright © 2017 Eric Mao. All rights reserved.
//

import Foundation
import os.log

class Quote: NSObject, NSCoding {
    
    //MARK: Properties
    
    var author: String
    var body: String
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("quotes")
    
    //MARK: Types
    
    struct PropertyKey {
        static let author = "author"
        static let body = "body"
    }
    
    //MARK: Initialization
    init?(author: String, body: String) {
        
        //Initialization should fail if there is no quote body
        guard !body.isEmpty else {
            return nil
        }
        
        //Initialize stored properties
        
        //Set author to "Anonymous" if an author isn't provided
        if author.isEmpty {
            self.author = "Anonymous"
        } else {
            self.author = author

        }
        self.body = body
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(author, forKey: PropertyKey.author)
        aCoder.encode(body, forKey: PropertyKey.body)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let author = aDecoder.decodeObject(forKey: PropertyKey.author) as? String else {
            os_log("Unable to decode the author for a Quote object.", log: OSLog.default, type: .debug)
            return nil
        }
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let body = aDecoder.decodeObject(forKey: PropertyKey.body) as? String else {
            os_log("Unable to decode the body for a Quote object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(author: author, body: body)
    }
    
}
