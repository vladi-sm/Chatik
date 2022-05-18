//
//  ConversionViewController.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 15.03.2022.
//

import UIKit
import FirebaseFirestore

final class ConversationViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var chatName: UINavigationItem!
    
    @IBOutlet weak var messageTableView: UITableView!
    
    //let firebaseService = FirebaseServiceImp.shared
    
    let dependencyContainer: DependencyContainer = DependencyContainerSupplier.dependencyContainer
    
    var channel: Channel?
    
    static let title: String? = "Chat name"

    var messagesList = [MessageProtocol]()
    
    var contents = ["Best code", "Hi", "For fun", "Testing...", "Coding!", "Hello again!"]
    
    var fakeMessage: [String : Any] { [
        "content" : contents.randomElement() ?? "noText",
        "created" : Timestamp(date: Date()),
        "senderName" : "Vladislav",
        "senderId" : dependencyContainer.getFirebase().getDeviceUUID()
    ] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = channel?.name
        addMessageSender()
        
        addAllMessages()
        
        chatName.title = title ?? "Anonymous"
        
        messageTableView.register(UINib(nibName: String(describing: InMessageCell.self), bundle: nil), forCellReuseIdentifier: InMessageCell.identifier)
        messageTableView.register(UINib(nibName: String(describing: SendingMessageCell.self), bundle: nil), forCellReuseIdentifier: SendingMessageCell.identifier)
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 80
        messageTableView.translatesAutoresizingMaskIntoConstraints = false
        
        messageTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messageTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messageTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        messageTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func addMessageSender() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.message.fill"), style: .plain, target: self, action: #selector(sendFakeMessage))
    }
    
    func addAllMessages() {
        dependencyContainer.getFirebase().getAllMessages(for: channel) { messages in
            self.messagesList = messages
            self.messageTableView.reloadData()
        }
    }
    
    @objc func sendFakeMessage() {
        dependencyContainer.getFirebase().createMessage(fakeMessage, for: channel) {
            self.addAllMessages()
        }
    }

}

extension ConversationViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let modelMessage = messagesList[indexPath.row]
        var cell: UITableViewCell
        
        if modelMessage.senderId != dependencyContainer.getFirebase().getDeviceUUID() {
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: InMessageCell.identifier, for: indexPath) as? InMessageCell else{
                return UITableViewCell()
            }
            newCell.configure(model: modelMessage)
            cell = newCell
        } else {
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: SendingMessageCell.identifier, for: indexPath) as? SendingMessageCell else{
                return UITableViewCell()
            }
            newCell.configure(model: modelMessage)
            cell = newCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


