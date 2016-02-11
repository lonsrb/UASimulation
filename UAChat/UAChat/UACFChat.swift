//
//  UACFChat.swift
//  UAChat
//
//  Created by Ryan Lons on 2/9/16.
//  Copyright © 2016 ryanlons. All rights reserved.
//

import Foundation

public class UACFChat
{
    private static let serverUrl = "https://shrouded-spire-90401.herokuapp.com"
    private static let errorDomain = "com.ryanlons"//needs to be something
    
    /**
     Retreives all messages for username. The act of retrieving the messages also deletes them. Meaning they are one time messages
     
     - Parameter username:   The username to get message for.
     - Parameter onSuccess: A block which accepts an array of string to be run if retreival succeeds.
     - Parameter onFailure: A block which accepts a NSErray if an error case is encountered
     */
    public class func getMessages(username : String, onSuccess:([String])->(), onFailure:(NSError)->())
    {
        if username.characters.count == 0
        {
            onFailure(NSError(domain: errorDomain, code: 10, userInfo: [ NSLocalizedDescriptionKey: "Username required but is empty"]))
            return
        }
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.URL = NSURL(string: serverUrl+"/chat/"+username)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if error != nil
            {
                onFailure(error!)
                return
            }
            
            do
            {
                var resultsArray : [String] = [String]()
                let jsonArray : NSArray = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSArray
                
                for json in jsonArray
                {
                    if let text : String = json["text"] as? String
                    {
                        resultsArray.append(text)
                    }
                }
                onSuccess(resultsArray)
                
            } catch let error as NSError {
                print("Parsing JSON Failed: \(error.localizedDescription)")
                onFailure(error)
            }
        })
        task.resume()
        
    }
    
    /**
     Sends a message for username. The message will self delete after the timeout accures
     
     - Parameter username:   The username to send the message for.
     - Parameter message:    A none empty string with a message to post
     - Parameter timeout:    An Int with value > 0 that specifies the messages time in seconds to live before it expires.
     - Parameter onSuccess:  A block which accepts a string of the ID of the successful post
     - Parameter onFailure:  A block which accepts a NSErray if an error case is encountered
     */
    public class func sendMessage(username : String, message : String, timeout : Int, onSuccess:(String)->(), onFailure:(NSError)->())
    {
        if username.characters.count == 0
        {
            onFailure(NSError(domain: errorDomain, code: 10, userInfo: [ NSLocalizedDescriptionKey: "Username required but is empty"]))
            return
        }
        
        if message.characters.count == 0
        {
            onFailure(NSError(domain: errorDomain, code: 10, userInfo: [ NSLocalizedDescriptionKey: "Message required but is empty"]))
            return
        }
        
        if timeout <= 0
        {
            onFailure(NSError(domain: errorDomain, code: 10, userInfo: [ NSLocalizedDescriptionKey: "Timeout must be greater than 0"]))
            return
        }
        
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.URL = NSURL(string: serverUrl+"/chat/notifications/register")
        request.HTTPMethod = "POST"
        
        let jsonObject: [String : AnyObject] = [
            "username" : username,
            "text" : message,
            "timeout" : timeout]
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonObject, options:  NSJSONWritingOptions(rawValue:0))
        } catch let error as NSError {
            onFailure(error)
            return
        }
        
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in

            if error != nil
            {
                onFailure(error!)
                return
            }

            do
            {
                let jsonResults : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                if let id : String = jsonResults["id"] as? String
                {
                    onSuccess(id)
                }
                else
                {
                    onFailure(NSError(domain: errorDomain, code: 42, userInfo: [ NSLocalizedDescriptionKey: "Succesful post but no id returned"]))
                }
            } catch let error as NSError {
                onFailure(error)
            }
        })
        
        task.resume()
        
    }
}