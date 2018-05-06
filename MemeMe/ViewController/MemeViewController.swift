//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Sergio Costa on 22/04/18.
//  Copyright © 2018 Sergio Costa. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    //Mark:- UI Outlets
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottonText: UITextField!    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //Mark:- Properties
    var activeField : UITextField?
    var meme: Meme?
    let imagePicker = UIImagePickerController()
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -5]
    
    func save(image: UIImage){
        // Create the meme obj
        let meme = Meme(topText: topText.text!, bottomtext: bottonText.text!, originalImage: memeImage.image!, memedImage: image, path: URL.init(string: "empty")!)
        MemeHandler.sharedInstance.memes.append(meme)
        MemeHandler.sharedInstance.saveMeme(meme)
    }
    
    //MARK:- UIViewController Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        configureTextfield(textField: topText)
        configureTextfield(textField: bottonText)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MemeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    //MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = pickedImage
            shareButton.isEnabled = true
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }

    //MARK:- Button Actions
    @IBAction func cancelMeme(_ sender: Any){
        bottonText.text = ""
        topText.text = ""
        memeImage.image = nil
        shareButton.isEnabled = false
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromAlbum(_ sender:Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender:Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        // image to share
        hideToolBarAndNaviBar()
        
        let memedImage = self.takePrintScreen()
        
        showToolBarAndNaviBar()
        
        let imageToShare = [memedImage]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        // so that iPads won't crash
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        activityViewController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.save(image: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- Hide/Show Toolbar and NavBar
    func hideToolBarAndNaviBar(){
        toolBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    func showToolBarAndNaviBar(){
        toolBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- UITextFieldDelegate / Keyboard Handle
    func configureTextfield(textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if activeField == bottonText{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if activeField == bottonText{
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
