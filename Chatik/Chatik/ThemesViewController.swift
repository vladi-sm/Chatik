//
//  ThemesViewController.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 17.03.2022.
//

import UIKit

final class ThemesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var containerView: UIView!
    
    var delegate: ThemeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = cancelBarButton
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: String(describing: ThemeCell.self), bundle: nil), forCellReuseIdentifier: ThemeCell.identifier)
        
        tableView.isScrollEnabled = false
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        
        setTheme(delegate?.selectedTheme ?? .classic)
    }
}

extension ThemesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height/3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThemeCell.identifier, for: indexPath) as? ThemeCell else{
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.typeTheme = .classic
        case 1:
            cell.typeTheme = .day
        case 2:
            cell.typeTheme = .night
        default:
            cell.typeTheme = .classic
        }
        
        cell.selectedTheme = delegate?.selectedTheme ?? .classic
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedTheme = Theme(rawValue: indexPath.row) ?? .classic
        
        delegate?.selectedTheme = selectedTheme
        
        for cell in tableView.visibleCells {
            guard let cell = cell as? ThemeCell else { return }
            cell.selectedTheme = selectedTheme
        }
        
        setTheme(selectedTheme)
    }
    
    func setTheme(_ theme: Theme) {
        switch theme {
        case .classic:
            containerView.backgroundColor = .classicColor
            view.backgroundColor = .classicColor
        case .day:
            containerView.backgroundColor = .dayColor
            view.backgroundColor = .dayColor
        case .night:
            containerView.backgroundColor = .nightColor
            view.backgroundColor = .nightColor
        }
    }
    
}
extension ThemesViewController{
    
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
