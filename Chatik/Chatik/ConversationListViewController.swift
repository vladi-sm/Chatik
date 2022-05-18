//
//  ViewController.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 02.03.2022.
//

import UIKit
import FirebaseFirestore
import CoreData

protocol ThemeDelegate {
    var selectedTheme: Theme { get set }
}

final class ConversationListViewController: UIViewController, ThemeDelegate {
    
    // MARK: - IBOutlets and properties
    
    let dependencyContainer = DependencyContainerSupplier.dependencyContainer
    
    private var channelsList = [Channel]()
    
    @IBOutlet weak var tableViewConversationList: UITableView!
    
    var selectedThemeBuffer: Theme = .classic {
        didSet {
            setTheme()
        }
    }
        
    var selectedTheme: Theme {
        get {
            selectedThemeBuffer
        } set {
            selectedThemeBuffer = newValue
        }
    }
    
    var profileBarButton: UIBarButtonItem!
    
    var settingsBarButton: UIBarButtonItem!
    
    var channelBarButton: UIBarButtonItem!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addAllChannels()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "TinkoffYellow")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.addNavigationBarButtons()
    
        tableViewConversationList.register(UINib(nibName: String(describing: ChannelCell.self), bundle: nil), forCellReuseIdentifier: ChannelCell.identifier) //регистрация ячейки
        
        tableViewConversationList.dataSource = self
        tableViewConversationList.delegate = self
        tableViewConversationList.rowHeight = UITableView.automaticDimension
        tableViewConversationList.estimatedRowHeight = 76
        
    }
    
    // MARK: - IBActions and methods
    
    func addAllChannels(){
        dependencyContainer.getFirebase().getAllChannels{ channels in
            self.channelsList = channels
            self.tableViewConversationList.reloadData()
        }
    }
    
    private func addNavigationBarButtons(){
        
        let channelImage = UIImage(systemName: "plus.message")
        channelBarButton = UIBarButtonItem(image: channelImage, style: .plain, target: self, action: #selector(channelButtonTapped))
        channelBarButton.tintColor = .black
        
        let profileImage = UIImage(systemName: "person.circle")
        profileBarButton = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(profileButtonTapped))
        profileBarButton.tintColor = .black
        
        self.navigationItem.setRightBarButtonItems([channelBarButton, profileBarButton], animated: true)
         
        let settingsImage = UIImage(systemName: "gear")
        settingsBarButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(settingsButtonTapped))
        settingsBarButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = settingsBarButton

    }
    
    func setTheme() {
        
        let appearanceNew = UINavigationBarAppearance()
        
        switch selectedTheme {
        case .classic:
            appearanceNew.backgroundColor = UIColor(named: "TinkoffYellow")
            view.backgroundColor = .white
        case .day:
            appearanceNew.backgroundColor = .dayColor
            view.backgroundColor = .dayColor
        case .night:
            appearanceNew.backgroundColor = .nightColor
            appearanceNew.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearanceNew.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            view.backgroundColor = .nightColor
        }
        
        navigationController?.navigationBar.standardAppearance = appearanceNew
        navigationController?.navigationBar.compactAppearance = appearanceNew
        navigationController?.navigationBar.scrollEdgeAppearance = appearanceNew
        
        let titleColor = selectedTheme == .night ? UIColor.white : UIColor.black
        
        profileBarButton.tintColor = titleColor
        settingsBarButton.tintColor = titleColor
        channelBarButton.tintColor = titleColor
    }

}

// MARK: - Extensions DataSource, Delegate

extension ConversationListViewController: UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelsList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = channelsList[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.identifier, for: indexPath) as? ChannelCell else{
            return UITableViewCell()
        }
        cell.configure(model: model)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let conversationVC = storyboard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
        else { return }
        conversationVC.channel = channelsList[safe: indexPath.row]

        navigationController?.pushViewController(conversationVC, animated: true)
        tableViewConversationList.reloadData()
    }
    
}

// MARK: - Other Extensions

extension ConversationListViewController{
   
    @objc func channelButtonTapped() {
        
        let alertController = UIAlertController(title: "New Channel", message: "Enter channel name and push create", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Сhannel name"
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let createButton = UIAlertAction(title: "Create", style: .default){ [weak self] _ in
            guard let self = self else { return }
            guard let channelName = alertController.textFields?[0].text else { return }
            let randomMessage = self.generateLastMessage()
        
            let newChannel : [String : Any] = [
                "name" : channelName,
                "lastMessage" : randomMessage,
                "lastActivity" : Timestamp(date: Date())
            ]
            
            self.dependencyContainer.getFirebase().addDocument(newChannel)
            self.tableViewConversationList.reloadData()
        }
        alertController.addAction(cancelButton)
        alertController.addAction(createButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func settingsButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let themesVC = storyboard.instantiateViewController(withIdentifier: "ThemesViewController") as? ThemesViewController else { return }
        themesVC.delegate = self
        navigationController?.pushViewController(themesVC, animated: true)
    }
    
    @objc func profileButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        present(profileVC, animated: true, completion: nil)
    }
    
    private func generateLastMessage() -> String {
        let messagesArray: [String?] = ["Hello to all followers", "Good Afternoon followers", "Let's go", "Have a nice day", "Good Night" , nil]
        guard let randomMessage = messagesArray.randomElement(), let message = randomMessage else { return "No message yet" }
        return message
    }
}
