//
//  QuickSubmitViewController.swift
//  Bement
//
//  Created by Runkai Zhang on 8/10/18.
//  Copyright © 2018 Numeric Design. All rights reserved.
//

import UIKit
import CloudKit

class QuickSubmitViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet var form: UIStackView!
    
    @IBOutlet var Placeholder: UILabel!
    
    @IBOutlet var messageField: UITextView!
    
    @IBOutlet var Category: UISegmentedControl!
    
    @IBOutlet var send: UIButton!
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var detailLabel: UILabel!
    
    @IBOutlet var emailLabel: UILabel!
    
    @IBOutlet var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageField.delegate = self
        emailField.delegate = self
        
        textViewDidChange(messageField)
        tools.beautifulButton(send)
        
        send.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        categoryLabel.text = NSLocalizedString("categoryLabel", comment: "")
        emailLabel.text = NSLocalizedString("emailLabel", comment: "")
        detailLabel.text = NSLocalizedString("describeLabel", comment: "")
        Placeholder.text = NSLocalizedString("placeholder", comment: "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            textField.resignFirstResponder()
            self.view.layoutIfNeeded()
        }
        
        return true
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        
        if messageField.text == "" {
            let alert = UIAlertController(title: NSLocalizedString("noText", comment: ""), message: NSLocalizedString("noTextInfo", comment: ""), preferredStyle: .alert)
            let dismiss = UIAlertAction(title: NSLocalizedString("sorry", comment: ""), style: .default, handler: nil)
            alert.addAction(dismiss)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            if emailField.text == "" {
                let alert = UIAlertController(title: NSLocalizedString("noText", comment: ""), message: NSLocalizedString("noTextInfo", comment: ""), preferredStyle: .alert)
                let dismiss = UIAlertAction(title: NSLocalizedString("sorry", comment: ""), style: .default, handler: nil)
                alert.addAction(dismiss)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                
                let alert = UIAlertController(title: nil, message: NSLocalizedString("wait", comment: ""), preferredStyle: .alert)
                    
                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.gray
                loadingIndicator.startAnimating();
                
                DispatchQueue.main.async {
                    alert.view.addSubview(loadingIndicator)
                    self.present(alert, animated: true, completion: nil)
                }
                
                let input = "[" + "\"" + messageField.text + "\"" +  "]"
                
                let client = Algorithmia.client(simpleKey: "simUU2Suq089OuJAHIqumIUPNoR1")
                
                let algo = client.algo(algoUri: "nlp/ProfanityDetection/1.0.0")
                algo.pipe(rawJson: input) { resp, error in
                    
                }
                //获取当前时间
                let now = Date()
                    
                // 创建一个日期格式器
                let dformatter = DateFormatter()
                dformatter.dateFormat = "yyyy/MM/dd/ HH:mm:ss"
                    
                let messageRecord = CKRecord(recordType: "Message")
                    
                messageRecord["time"] = dformatter.string(from: now) as NSString
                messageRecord["message"] = self.messageField.text as NSString
                messageRecord["email"] = self.emailField.text! as NSString
                messageRecord["category"] = self.Category.selectedSegmentIndex
                    
                let myContainer = CKContainer.default()
                let publicDatabase = myContainer.publicCloudDatabase
                
                publicDatabase.save(messageRecord) {
                    (record, error) in
                    if error != nil {
                        
                        let string = String(describing: error)
                        
                        if string != "" {
                            self.uploadError(error!)
                            
                            let alert = UIAlertController(title: "oh no...", message: "An error appeared", preferredStyle: .alert)
                            
                            let dismiss = UIAlertAction(title: "Come on", style: .cancel, handler: nil)
                            alert.addAction(dismiss)
                            
                            DispatchQueue.main.async {
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        
                        return
                    } else {
                    
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        DispatchQueue.main.async {
                            let alertSuccess = UIAlertController(title: "Successful", message: "Successfully uploaded your messages", preferredStyle: .alert)
                            let dismiss = UIAlertAction(title: "Hurray!", style: .cancel, handler: { action in
                                self.performSegue(withIdentifier: "backToLogin", sender: self)
                            })
                            alertSuccess.addAction(dismiss)
                            self.present(alertSuccess, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func uploadError(_ error: Error) {
        let errorRecord = CKRecord(recordType: "Error")
        
        let string = String(describing: error) as NSString
        
        errorRecord["error"] = string 
        
        let myContainer = CKContainer.default()
        let publicDatabase = myContainer.publicCloudDatabase
        
        DispatchQueue.main.async {
            publicDatabase.save(errorRecord) {
                (record, error) in
                if let error = error {
                    print(error)
                    return
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let alpha = CGFloat(textView.text.isEmpty ? 1.0 : 0.0)
        if alpha != Placeholder.alpha {
            UIView.animate(withDuration: 0.3) { self.Placeholder.alpha = alpha } }
    }
}
