//
//  DialogModel.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 09.03.2022.
//

import Foundation
import UIKit


protocol ChannelProtocol: Equatable {
    var identifier: String {get set}
    var name: String {get set}
    var lastMessage: String? {get set}
    var lastActivity: Date? {get set}
}

protocol MessageProtocol{
    var senderName: String {get set}
    var senderId: String {get set}
    var content: String {get set}
    var created: Date {get set}
}

struct Channel: ChannelProtocol {
    var identifier: String
    var name: String
    var lastMessage: String?
    var lastActivity: Date?
    
    init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
}

struct Message: MessageProtocol{
    var senderName: String
    var senderId: String
    var content: String
    var created: Date
    
    init(senderName: String, senderId: String, content: String, created: Date){
        self.senderName = senderName
        self.senderId = senderId
        self.content = content
        self.created = created
    }
}

