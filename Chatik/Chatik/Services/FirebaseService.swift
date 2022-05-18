//
//  FirebaseService.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 31.03.2022.
//

import Foundation
import FirebaseFirestore

protocol FirebaseService{
    
    func createMessage(_ message: [String : Any], for channel: Channel?, completion: @escaping () -> Void)
    func getAllMessages(for channel: Channel?, completion: @escaping ([Message]) -> ())
    func getAllChannels(completion: @escaping ([Channel]) -> ())
    func addDocument(_ channel: [String: Any])
    func getDeviceUUID() -> String
}

class FirebaseServiceImp: FirebaseService {
    
    init(){}
    
    private lazy var db = Firestore.firestore()
    private lazy var ref = db.collection("channels")
    
    private func getMessagesReference(channel: Channel?) -> CollectionReference? {
        guard let identifier = channel?.identifier, identifier.count > 0 else { return nil }
        return db.collection("channels").document(identifier).collection("messages")
    }

    public func createMessage(_ message: [String : Any], for channel: Channel?, completion: @escaping () -> Void) {

        ref.addSnapshotListener { snap, err in

            guard err == nil else {
                print(err!.localizedDescription)
                return
            }
            guard let snap = snap else { return }
            
            snap.documents.forEach { [weak self] in
                if self?.channelFromSnapshot($0) == channel {
                    self?.db.collection("channels").document($0.documentID).collection("messages").addDocument(data: message)
                }
            }
        }
        
        completion()
    }
    
    public func getAllMessages(for channel: Channel?, completion: @escaping ([Message]) -> ()){
        
        let messagesReference = getMessagesReference(channel: channel)
        
        messagesReference?.addSnapshotListener{ snap, err in
            
            guard err == nil else {
                print(err!.localizedDescription)
                return
            }
            
            var messagesList = [Message]()
            guard let snap = snap else { return }
            
            snap.documents.forEach {
                
                let dataBase = $0.data()
                
                guard let content = dataBase["content"] as? String,
                      let created = dataBase["created"] as? Timestamp,
                      let senderId = dataBase["senderId"] as? String,
                      let senderName = dataBase["senderName"] as? String
                else { return }
                messagesList.append(Message(senderName: senderName, senderId: senderId, content: content, created: created.dateValue()))
            }
            messagesList.sort { $0.created > $1.created }
            completion(messagesList)
        }
    }
    
    public func getAllChannels(completion: @escaping ([Channel]) -> ()){
        ref.addSnapshotListener{ snap, err in
            
            guard err == nil else{
                print(err!.localizedDescription)
                return
            }
            var channelsList = [Channel]()
            
            guard let snap = snap else { return }
            
            snap.documents.forEach {
                guard let channel = self.channelFromSnapshot($0) else { return }
                channelsList.append(channel)
            }
            let baseDate = Date(timeIntervalSince1970: 0)
            channelsList.sort { $0.lastActivity ?? baseDate > $1.lastActivity ?? baseDate }
            completion(channelsList)
        }
    }
    
    
    func channelFromSnapshot(_ snap: QueryDocumentSnapshot) -> Channel? {
        let dataBase = snap.data()
        guard let name = dataBase["name"] as? String,
              let lastMessage = dataBase["lastMessage"] as? String,
              let lastActivityBuffer = dataBase["lastActivity"] as? Timestamp
        else { return nil }
        let identifier =  snap.documentID
        let lastActivity = lastActivityBuffer.dateValue()

        return Channel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
    }
    
    public func addDocument(_ channel: [String: Any]) {
       ref.addDocument(data: channel)
    }
    
    public func getDeviceUUID() -> String {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
            assertionFailure("Nil while unwrapping UIDevice.current.identifierForVendor?.uuidString")
            return ""
        }
        return uuid
    }
}
