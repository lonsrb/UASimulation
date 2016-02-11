//
//  UAChat.h
//  UAChat
//
//  Created by Ryan Lons on 2/9/16.
//  Copyright © 2016 ryanlons. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for UAChat.
FOUNDATION_EXPORT double UAChatVersionNumber;

//! Project version string for UAChat.
FOUNDATION_EXPORT const unsigned char UAChatVersionString[];

/*!
 *  @brief Provides all available methods for sending and retriving messages to the UAChat SDK from your app
 *
 */

/*!
 *  @brief Retreives all messages for username. The act of retrieving the messages also deletes them. Meaning they are one time messages
 *
 *  - Parameter username:   The username to get message for. Must be non-empty
 *  - Parameter onSuccess: A block which accepts an array of string to be run if retreival succeeds.
 *  - Parameter onFailure: A block which accepts a NSErray if an error case is encountered
 *
 *   public class func getMessages(username : String, onSuccess:([String])->(), onFailure:(NSError)->());
 */


/*!
 *  @brief Sends a message for username. The message will self delete after the timeout accures
 *
 *  - Parameter username:   The username to send the message for. Must be non-empty
 *  - Parameter message:    A none empty string with representing a message to post
 *  - Parameter timeout:    An Int with value > 0 that specifies the messages time in seconds to live before it expires.
 *  - Parameter onSuccess: A block which accepts a string of the ID of the successful post
 *  - Parameter onFailure: A block which accepts a NSErray if an error case is encountered
 *
 *   public class func sendMessage(username : String, message : String, timeout : Int, onSuccess:(String)->(), onFailure:(NSError)->());
 */
