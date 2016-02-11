//
//  UAChatTests.swift
//  UAChatTests
//
//  Created by Ryan Lons on 2/9/16.
//  Copyright © 2016 ryanlons. All rights reserved.
//

import XCTest
@testable import UAChat

class UAChatTests: XCTestCase {
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testCreateMessage()
    {
        let readyExpectation = expectationWithDescription("ready")
        UACFChat.sendMessage("rlons", message: "aaaa", timeout: 60,
                onSuccess: { (messageId) -> () in
                            XCTAssertTrue(messageId.characters.count > 0, "Message ID should not be blank")
                            readyExpectation.fulfill()
                })
                { (error) -> () in
                            XCTFail("The mesage was valid. It should've returned an ID")
                            readyExpectation.fulfill()
                }
        waitForExpectationsWithTimeout(60, handler: { error in XCTAssertNil(error, "Error, timeout") })
    }
    
    
    func testCreateMessageFailsWithNoUsername()
    {
        let readyExpectation = expectationWithDescription("ready")
        UACFChat.sendMessage("", message: "aaaa", timeout: 60,
                onSuccess: { (messageId) -> () in
                            XCTFail("The mesage was invalid. It should've returned an error")
                            readyExpectation.fulfill()
                })
                { (error) -> () in
                            XCTAssertTrue(error.code == 10, "Error Code is \(error.code), should be 10 for validation errors")
                            let expectedDescription = "Username required but is empty"
                            XCTAssertTrue(error.localizedDescription == expectedDescription,
                                "Error description is \(error.debugDescription), expected '\(expectedDescription)'")
                    
                            readyExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in XCTAssertNil(error, "Error, timeout") })
    }

    
    func testCreateMessageFailsWithNoMessage()
    {
        let readyExpectation = expectationWithDescription("ready")
        UACFChat.sendMessage("rlons", message: "", timeout: 60,
                onSuccess: { (messageId) -> () in
                                XCTFail("The mesage was invalid. It should've returned an error")
                                readyExpectation.fulfill()
                            })
                { (error) -> () in
                                XCTAssertTrue(error.code == 10, "Error Code is \(error.code), should be 10 for validation errors")
                                let expectedDescription = "Message required but is empty"
                                XCTAssertTrue(error.localizedDescription == expectedDescription,
                                    "Error description is \(error.debugDescription), expected '\(expectedDescription)'")
                
                                readyExpectation.fulfill()
                            }
        
        waitForExpectationsWithTimeout(60, handler: { error in XCTAssertNil(error, "Error, timeout") })
    }
    
    func testCreateMessageFailsWithNoTimeout()
    {
        let readyExpectation = expectationWithDescription("ready")
        UACFChat.sendMessage("rlons", message: "aaa", timeout: 0,
            onSuccess: { (messageId) -> () in
                XCTFail("The mesage was invalid. It should've returned an error")
                readyExpectation.fulfill()
            })
            { (error) -> () in
                XCTAssertTrue(error.code == 10, "Error Code is \(error.code), should be 10 for validation errors")
                let expectedDescription = "Timeout must be greater than 0"
                XCTAssertTrue(error.localizedDescription == expectedDescription,
                    "Error description is \(error.debugDescription), expected '\(expectedDescription)'")
                
                readyExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(60, handler: { error in XCTAssertNil(error, "Error, timeout") })
    }

//    func testCreateMessageFailsWithIfTimeout()//need a mock for this..
//    {
//       
//    }
    
    func testMessageTimeout()
    {
        let messageText = "Hi how are you?"
        let username = "test-\(NSUUID().UUIDString)"
        
        let readyExpectation = expectationWithDescription("ready")
        UACFChat.sendMessage(username, message: messageText, timeout: 1,
            onSuccess: { (message_id) -> () in
                
                sleep(2)
                
                UACFChat.getMessages(username,
                    onSuccess: { (messagesArray) -> () in
                        XCTAssertTrue(messagesArray.count == 0, "Messages array should have no objects due to timout")
                        readyExpectation.fulfill()
                    },
                    onFailure: { (error) -> () in
                        XCTFail("The request was valid. It should've returned an empty array")
                        readyExpectation.fulfill()
                })
            })
            { (error) -> () in
                XCTFail("The mesage was valid. It should've returned an ID")
                readyExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in XCTAssertNil(error, "Error, timeout") })
    }
    
    
    func testGetMessage()
    {
        let messageText = "Hi how are you?"
        let username = "test-\(NSUUID().UUIDString)"
        
        let readyExpectation = expectationWithDescription("ready")
        UACFChat.sendMessage(username, message: messageText, timeout: 60,
            onSuccess: { (message_id) -> () in
                
                        UACFChat.getMessages(username,
                                    onSuccess: { (messagesArray) -> () in
                                        XCTAssertTrue(messagesArray.count == 1, "Messages array should have 1 object")
                                        XCTAssertTrue(messagesArray[0] == messageText, "The message is \(messagesArray[0]) and should be \(messageText)")
                                        readyExpectation.fulfill()
                                    },
                                    onFailure: { (error) -> () in
                                            XCTFail("")
                                            readyExpectation.fulfill()
                                    })
            })
            { (error) -> () in
                XCTFail("The mesage was valid. It should've returned an ID")
                readyExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in XCTAssertNil(error, "Error, timeout") })
        
    }
    
    func testGetTwoMessages()
    {
        let messageText = "Hi how are you?"
        let message2Text = "Keep austin weird"
        let username = "test-\(NSUUID().UUIDString)"
        
        let readyExpectation = expectationWithDescription("ready")
        //send message 1
        UACFChat.sendMessage(username, message: messageText, timeout: 60,
            onSuccess: { (messageId) -> () in

            //send message 2
                UACFChat.sendMessage(username, message: message2Text, timeout: 60,
                    onSuccess: { (message2Id) -> () in
                    
                            UACFChat.getMessages(username,
                            onSuccess: { (messagesArray) -> () in
                                        XCTAssertTrue(messagesArray.count == 2, "Messages array should have 2 objects")
                                        XCTAssertTrue(messagesArray.contains(messageText), "The message is \(messagesArray[0]) and should be \(messageText)")
                                        XCTAssertTrue(messagesArray.contains(message2Text), "The message is \(messagesArray[1]) and should be \(message2Text)")
                                        readyExpectation.fulfill()
                                        },
                            onFailure: { (error) -> () in
                                        XCTFail("The mesage was valid. It should've returned an array but had error: \(error.localizedDescription)")
                                        readyExpectation.fulfill()
                                        })
                    }, onFailure: { (error) -> () in
                                XCTFail("The mesage was valid. It should've returned an ID but had error: \(error.localizedDescription)")
                })
                
            })
            { (error) -> () in
                XCTFail("The mesage was valid. It should've returned an ID")
                readyExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in XCTAssertNil(error, "Error, timeout") })
    }

    
    
    func testGetMessageFailsWithNoUsername()
    {
        let messageText = "Hi how are you?"
        let username = "test-\(NSUUID().UUIDString)"
        
        let readyExpectation = expectationWithDescription("ready")
        UACFChat.sendMessage(username, message: messageText, timeout: 60,
            onSuccess: { (message_id) -> () in
                
                //NOTE the empty username here
                UACFChat.getMessages("",
                        onSuccess: { (messagesArray) -> () in
                                    XCTFail("The request was invalid. It should've returned an error")
                                    readyExpectation.fulfill()
                                },
                        onFailure: { (error) -> () in
                                    XCTAssertTrue(error.code == 10, "Error Code is \(error.code), should be 10 for validation errors")
                                    let expectedDescription = "Username required but is empty"
                                    XCTAssertTrue(error.localizedDescription == expectedDescription,
                                        "Error description is \(error.debugDescription), expected '\(expectedDescription)'")
                                    readyExpectation.fulfill()
                                })
            })
            { (error) -> () in
                XCTFail("The mesage was valid. It should've returned an ID")
                readyExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in XCTAssertNil(error, "Error, timeout") })
    }

    //This is actually testing serverside logic, and one might argue doesn't need to be tested here.
    //BUT if this imporant, and it were to change, it'd be good for a test to fail to noftify the team that
    //something is up
    func testGetMessagesForUserSouldClearMessages()
    {
        let messageText = "Hi how are you?"
        let username = "test-\(NSUUID().UUIDString)"
        
        let readyExpectation = expectationWithDescription("ready")
        UACFChat.sendMessage(username, message: messageText, timeout: 60,
            onSuccess: { (message_id) -> () in
                
            
                //get the message, this should clear the server for this user
                UACFChat.getMessages(username,
                    onSuccess: { (messagesArray) -> () in
                            XCTAssertTrue(messagesArray.count == 1, "Messages array should have 1 object")
                            XCTAssertTrue(messagesArray[0] == messageText, "The message is \(messagesArray[0]) and should be \(messageText)")
                        
                            UACFChat.getMessages(username,
                                    onSuccess: { (messagesArray) -> () in
                                                    XCTAssertTrue(messagesArray.count == 0, "Messages array should have 0 objects")
                                                    readyExpectation.fulfill()
                                                },
                                    onFailure: { (error) -> () in
                                                    XCTFail("The mesage was valid. It should've returned an (empty) Array")
                                                    readyExpectation.fulfill()
                                                })

                    },
                    onFailure: { (error) -> () in
                        XCTFail("The mesage was valid. It should've returned an Array")
                        readyExpectation.fulfill()})
            
            })
            { (error) -> () in
                XCTFail("The mesage was valid. It should've returned an ID")
                readyExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in XCTAssertNil(error, "Error, timeout") })
    }
    
    
    
}
