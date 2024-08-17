//
//  NoticeListDTO.swift
//  koin
//
//  Created by JOOMINKYUNG on 8/13/24.
//

import Foundation

struct NoticeListDTO {
    let articles: [NoticeArticleDTO]
    let totalCount, currentCount, totalPage, currentPage: Int
    
    enum CodingKeys: String, CodingKey {
        case articles
        case totalCount = "total_count"
        case currentCount = "current_count"
        case totalPage = "total_page"
        case currentPage = "current_page"
    }
}

struct NoticeArticleDTO {
    let id, boardID: Int
    let title, content, nickname: String
    let hit: Int
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case boardID = "board_id"
        case title, content, nickname, hit
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
