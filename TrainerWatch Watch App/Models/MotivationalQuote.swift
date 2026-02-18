//
//  MotivationalQuote.swift
//  TrainerWatch
//
//  Created by Ramone Hayes on 2/17/26.
//

import Foundation

/// Motivational quote from API
/// Design Principle: Keep content brief for quick glances
struct MotivationalQuote: Codable {
    let quote: String
    let author: String
    
    /// API response wrapper for ZenQuotes API
    struct APIResponse: Codable {
        let q: String  // quote
        let a: String  // author
    }
}
