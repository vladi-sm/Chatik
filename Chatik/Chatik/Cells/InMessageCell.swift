//
//  InMessageCell.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 16.03.2022.
//

import UIKit

final class InMessageCell: UITableViewCell {

    static let identifier = String(describing: InMessageCell.self)
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var senderLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var messageLabel: UILabel?
    
    public func configure(model: MessageProtocol){
        self.messageLabel?.text = model.content
        senderLabel?.text = model.senderName
        timeLabel?.text = model.created.toString()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bubbleView.layer.cornerRadius = 14
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.messageLabel?.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
