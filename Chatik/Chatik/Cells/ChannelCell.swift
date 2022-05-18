//
//  ChannelCell.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 31.03.2022.
//

import UIKit

class ChannelCell: UITableViewCell {

    static let identifier = String(describing: ChannelCell.self)
    
    @IBOutlet weak var lastChannelMessageTitle: UILabel!
    @IBOutlet weak var nameChannelTitle: UILabel!
    @IBOutlet weak var lastActivityTitle: UILabel!
    @IBOutlet weak var viewCellChannel: UILabel!
    
    func configure(model: Channel){
        var dateString = "00:00"
        if let date = model.lastActivity{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateString = dateFormatter.string(from: date)
        }
        
        self.nameChannelTitle?.text = model.name
        self.lastActivityTitle?.text = dateString
        if let lastMessage = model.lastMessage{
            self.lastChannelMessageTitle?.text = lastMessage
        }else {
            self.lastChannelMessageTitle?.font = .italicSystemFont(ofSize: 15)
            self.lastChannelMessageTitle?.textColor = .systemGray
            self.lastChannelMessageTitle?.text = "No message yet"
        }
    }
    
    //подготовка ячейки к переиспользованию
    override func prepareForReuse() {
        super.prepareForReuse()
        viewCellChannel.backgroundColor = .white
        self.nameChannelTitle?.text = nil
        self.lastActivityTitle?.text = nil
        self.lastChannelMessageTitle?.textColor = .black
        self.lastChannelMessageTitle?.font = .systemFont(ofSize: 15)
    }
}
