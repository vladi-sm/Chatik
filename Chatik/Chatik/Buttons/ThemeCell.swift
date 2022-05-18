//
//  ThemeCellTableViewCell.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 17.03.2022.
//

import UIKit

enum Theme: Int {
    case classic, day, night
}

class ThemeCell: UITableViewCell {

    static let identifier = String(describing: ThemeCell.self)
    
    var typeTheme: Theme = .classic {
        didSet {
            coloring()
        }
    }
    
    var selectedTheme: Theme = .classic {
        didSet {
            bordering()
        }
    }
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var themeName: UILabel!
    @IBOutlet weak var leftChat: UIView!
    @IBOutlet weak var rightChat: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func coloring() {
        
        themeName.text = "\(typeTheme)"
        
        switch typeTheme {
        case .classic:
            container.backgroundColor = .white
            leftChat.backgroundColor = UIColor(named: "Light")
            rightChat.backgroundColor = .systemGray6
        case .day:
            container.backgroundColor = .white
            leftChat.backgroundColor = .systemTeal
            rightChat.backgroundColor = .systemGray6
        case .night:
            container.backgroundColor = .black
            leftChat.backgroundColor = .systemGray2
            rightChat.backgroundColor = .systemGray4
        }
        
        container.layer.cornerRadius = 7
        container.layer.masksToBounds = true
        
        leftChat.layer.cornerRadius = 7
        leftChat.layer.masksToBounds = true
        
        rightChat.layer.cornerRadius = 7
        rightChat.layer.masksToBounds = true
        
        bordering()
    }
    
    func bordering(){
        
        if typeTheme == selectedTheme {
            container.layer.borderColor = UIColor.yellow.cgColor
            container.layer.borderWidth = 3
        } else {
            container.layer.borderWidth = 2
            container.layer.borderColor = UIColor.systemGray2.cgColor
        }
        
        themeName.textColor = selectedTheme == .night ? .white : .black
        
        switch selectedTheme {
        case .classic:
            contentView.backgroundColor = .classicColor
        case .day:
            contentView.backgroundColor = .dayColor
        case .night:
            contentView.backgroundColor = .nightColor
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
