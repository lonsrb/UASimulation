//
//  ViewController.swift
//  ReferenceApp
//
//  Created by Ryan Lons on 2/9/16.
//  Copyright © 2016 ryanlons. All rights reserved.
//

import UIKit
import UAChat

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var timeoutTextField: UITextField!
    @IBOutlet weak var sendMessageInfoLabel: UILabel!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var shareResultsButton: UIButton!
    
    private let successColor : UIColor = UIColor(hue: 0.5, saturation: 0.8, brightness: 0.8, alpha: 1)
    private let errorColor : UIColor = UIColor(hue: 0, saturation: 1, brightness: 0.6, alpha: 1)
    private var messagesArray : [String] = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        messagesTableView.tableFooterView = UIView() //this hides all empty tableview cells, cleaner looking UI
        shareResultsButton.alpha = 0
    }
    
    
    @IBAction func sendMessageTapped(sender: UIButton)
    {
        if messageTextField.text?.characters.count == 0
        {
            self.animateInfoLabel(self.sendMessageInfoLabel, message: "message is empty", color: self.errorColor)
            return
        }
        if usernameTextField.text?.characters.count == 0
        {
            self.animateInfoLabel(self.sendMessageInfoLabel , message: "username is empty", color: self.errorColor)
            return
        }
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.shareResultsButton.alpha = 0
        })
        
        //show loading label
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.sendMessageInfoLabel.text = "Processing.."
            self.sendMessageInfoLabel.textColor = UIColor.grayColor()
            self.sendMessageInfoLabel.alpha = 1
        })
        
        //use a default timeout for convienince
        let timeoutToUse : Int = timeoutTextField.text?.characters.count == 0 ? 60 : Int(timeoutTextField.text!)!
        UACFChat.sendMessage(usernameTextField.text!, message: messageTextField.text!, timeout: timeoutToUse,
            onSuccess: { (messageId) -> () in
                
                print("messageId -> \(messageId)")
                dispatch_async(dispatch_get_main_queue(),{
                    self.messageTextField.text = ""
                    self.animateInfoLabel(self.sendMessageInfoLabel, message: "Success!!", color: self.successColor)
                })
                
                
            })
            { (error) -> () in
                print("ERROR -> \(error.localizedDescription)")
                self.animateInfoLabel(self.sendMessageInfoLabel, message: error.localizedDescription, color: self.errorColor)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messagesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as UITableViewCell!
        cell.textLabel?.text = messagesArray[indexPath.row]
        return cell
    }
   
    @IBAction func ShareResultsTapped(sender: UIButton)
    {
        if usernameTextField.text?.characters.count == 0 || messagesArray.count == 0
        {
            displayAlert("Unable to share", message: "Must have username and search results in order to share")
            return
        }
        
        let message = "Strings for \(usernameTextField.text), \(messagesArray.joinWithSeparator(", "))"
        
        let activityViewController = UIActivityViewController(activityItems: [message as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    @IBAction func getMessagesTapped(sender: UIButton)
    {
        if usernameTextField.text?.characters.count > 0
        {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.sendMessageInfoLabel.text = "Processing.."
                self.sendMessageInfoLabel.textColor = UIColor.grayColor()
                self.sendMessageInfoLabel.alpha = 1
            })
            
            UACFChat.getMessages(usernameTextField.text!, onSuccess: { (newMessagesArray) -> () in
                    self.messagesArray = newMessagesArray
                    dispatch_async(dispatch_get_main_queue(),{
                        self.messagesTableView.reloadData()
                        if self.messagesArray.count == 0 //no messages retreived
                        {
                            self.animateInfoLabel(self.sendMessageInfoLabel, message: "No new messages", color: self.successColor)
                        }
                        else //we got messages, show them off
                        {
                            UIView.animateWithDuration(0.2, animations: { () -> Void in
                                self.shareResultsButton.alpha = 1
                            })

                            self.animateInfoLabel(self.sendMessageInfoLabel, message: "\(self.messagesArray.count) messages retrieved", color: self.successColor)
                        }

                    })
                },
                onFailure: { (error) -> () in
                self.animateInfoLabel(self.sendMessageInfoLabel, message: error.localizedDescription, color: self.errorColor)
            })
        }
        else //show an validation error alert
        {
            self.animateInfoLabel(self.sendMessageInfoLabel , message: "username is empty", color: self.errorColor)
        }
    }
    
    private func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
        return
    }
    
    
    private func animateInfoLabel(label : UILabel, message : String, color : UIColor)
    {
        label.text = message
        label.textColor = color
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            label.alpha = 1
            }, completion: { (finished) -> Void in
                if finished
                {
                    UIView.animateWithDuration(0.3, delay: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        label.alpha = 0
                        }, completion: { (finished) -> Void in
                    })
                }
        })
    }
}

