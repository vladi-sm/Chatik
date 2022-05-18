//
//  ProfileViewController.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 27.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets and properties
    
    enum TextFieldType: Int {
        case userName, userInfo
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userInfoTextField: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var editProfileImageButton:  UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var saveGSDButton: UIButton!
    
    @IBOutlet weak var saveOperationButton: UIButton!
    
    private var userNameBuffer: String = ""
    private var userInfoBuffer: String = ""
    
    private var imagePhoto = UIImagePickerController()
    
    private var activityIndicator: UIActivityIndicatorView?
    
    private var userImage: UIImage? {
        profileImageView.image ?? UIImage(systemName: "person.fill")
    }
    
    let defaultProfileImageView: UIImageView = {
        let defaultImage = UIImageView()
        defaultImage.image = UIImage(systemName: "person.fill")
        defaultImage.translatesAutoresizingMaskIntoConstraints = false
        return defaultImage
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        userInfoTextField.delegate = self
        userNameTextField.tag = TextFieldType.userName.rawValue
        userInfoTextField.tag = TextFieldType.userInfo.rawValue
        imagePhoto.delegate = self
        
        editButton.layer.cornerRadius = 14
        cancelButton.layer.cornerRadius = 14
        saveGSDButton.layer.cornerRadius = 14
        saveOperationButton.layer.cornerRadius = 14
        profileImageView.layer.cornerRadius = 121
        profileImageView.addSubview(defaultProfileImageView)
        
        defaultProfileImageView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        defaultProfileImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        defaultProfileImageView.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        defaultProfileImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        defaultProfileImageView.rightAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        defaultProfileImageView.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 250, y: 600, width: 100, height: 100))
        activityIndicator?.style = .large
        activityIndicator?.tintColor = .black
        
        if let activityIndicator = activityIndicator {
            view.addSubview(activityIndicator)
        }
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator?.isHidden = true

    }
    
    // MARK: - IBActions and methods
    
    func saveButtonTapped() {
        saveGSDButton.isEnabled = false
        saveOperationButton.isEnabled = false
    }
    
    func saveFinishElementState() {
        self.editButton.isHidden = false
        self.saveGSDButton.isHidden = true
        self.saveOperationButton.isHidden = true
        self.cancelButton.isHidden = true
        
        self.userNameTextField.isEnabled = false
        self.userInfoTextField.isEnabled = false
    }
    
    func startActivityIndicator() {
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.isHidden = false
        
    }
    
    @IBAction func saveGCDTapped(_ sender: Any) {
        saveButtonTapped()
        guard let userImage = self.userImage else { return }
        
        startActivityIndicator()
        
        GCDManager.save(userName: userNameBuffer, userInfo: userInfoBuffer, userProfileImage: userImage) {
            self.stopActivityIndicator()
            self.saveFinishElementState()
        }
    }
    
    @IBAction func saveOperationTapped(_ sender: Any) {
        saveButtonTapped()
        
        guard let userImage = self.userImage else { return }
        
        startActivityIndicator()
        
        let saver = OperationSaver(userName: userNameBuffer, userInfo: userInfoBuffer, userProfileImage: userImage)
        saver.completionBlock = {
            OperationQueue.main.addOperation {
                self.stopActivityIndicator()
                self.saveFinishElementState()
            }
        }
        OperationQueue().addOperation(saver)
    }
    
    @IBAction func closeProfileButtonPressed(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editImagePressed(_ sender: Any) {
        
        // создание алерт контроллера
        let alertController = UIAlertController(title: "Profile Image", message: "Make photo or choose image from gallery", preferredStyle: .actionSheet)
        //кнопка перехода к камере
        let cameraButton = UIAlertAction(title: "Camera", style: .default){ [weak self] _ in
            self?.imagePhoto.sourceType = .camera
            self?.imagePhoto.allowsEditing = true
            self?.present(self!.imagePhoto, animated: true, completion: nil)
        }
        //кнопка перехода к галерее
        let galleryButton = UIAlertAction(title: "Gallery", style: .default){ [weak self] _ in
            self?.imagePhoto.sourceType = .photoLibrary
            self?.imagePhoto.allowsEditing = true
            self?.present(self!.imagePhoto, animated: true, completion: nil)
        }
        //кнопка отмены
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // добавляем кнопки в Alert Controller
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            alertController.addAction(cameraButton)
        }
        else{
            alertController.message = "Choose image from gallery. Camera not available"
        }
        alertController.addAction(galleryButton)
        alertController.addAction(cancelButton)
        // отображаем Alert Controller
        self.present(alertController, animated: true, completion: nil)
        
    }
}

// MARK: - ProfileVC Extension

extension ProfileViewController: UITextFieldDelegate{
   
    @IBAction func editProfilePressed(_ sender: Any) {
        self.editButton.isHidden = true
        self.editProfileImageButton.isHidden = true
        
        self.saveGSDButton.isHidden = false
        self.saveOperationButton.isHidden = false
        self.cancelButton.isHidden = false
        
        self.userNameTextField.isEnabled = true
        self.userInfoTextField.isEnabled = true
        self.userNameTextField.becomeFirstResponder()// поставить курсор в текстовое поле
        
        self.saveGSDButton.isEnabled = false
        self.saveOperationButton.isEnabled = false
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.editButton.isHidden = false
        self.saveGSDButton.isHidden = true
        self.saveOperationButton.isHidden = true
        self.cancelButton.isHidden = true
        
        self.userNameTextField.isEnabled = false
        self.userInfoTextField.isEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldType = TextFieldType(rawValue: textField.tag)
        
        guard let text = textField.text, let textRange = Range(range, in: text) else {return true}
        let newText = text.replacingCharacters(in: textRange, with: string)
        
        var isSavingEnabled = false
        
        switch textFieldType {
        case .userName:
            isSavingEnabled = newText != userNameBuffer || userInfoTextField.text != userInfoBuffer
            userNameBuffer = newText
        case .userInfo:
            isSavingEnabled = newText != userInfoBuffer || userNameTextField.text != userNameBuffer
            userInfoBuffer = newText
        case .none:
            isSavingEnabled = false
        }
        
        self.saveGSDButton.isEnabled = isSavingEnabled
        self.saveOperationButton.isEnabled = isSavingEnabled
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.userNameTextField{
            self.userNameTextField.resignFirstResponder()// убрать курсор из текстового поля
            self.userInfoTextField.becomeFirstResponder()
        }else if textField == self.userInfoTextField{
            self.userInfoTextField.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            
            defaultProfileImageView.image = pickedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
}
