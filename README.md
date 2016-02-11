# UASimulation
UAChat is a simple ephemeral text message service

UAChat allows you to easily send a retrive messages for users by username

UAChat has two methods availble for use:


-- SEND MESSAGE

description:
Sends a message for username. The message will self delete after the timeout accures

signature:
public class func sendMessage(username : String, message : String, timeout : Int, onSuccess:(String)->(), onFailure:(NSError)->());

params:
username:   The username to send the message for. Must be non-empty
message:    A none empty string with representing a message to post
timeout:    An Int with value > 0 that specifies the messages time to live before it expires.
onSuccess:  A block which accepts a string of the ID of the successful post
onFailure:  A block which accepts a NSErray if an error case is encountered


-- GET MESSAGES

description:
Retreives all messages for username. The act of retrieving the messages also deletes them. Meaning they are one time messages

signature:
public class func getMessages(username : String, onSuccess:([String])->(), onFailure:(NSError)->());

params:
username:   The username to get message for. Must be non-empty
onSuccess: A block which accepts an array of string to be run if retreival succeeds.
onFailure: A block which accepts a NSErray if an error case is encountered

---------------------

-- Installation
At present, there are two versions, one to run on the simulator and one to run on a device.
Select the appropriate version for your environemt (device vs sim) and drag the UAChat.framework into your project.

Next open your blue project settings file and drag the framework from the project navigator into the "Embedded Binaries" section in your targets General Tab.
And now you should be good to go. You can email lonsrb@gmail.com with any questions.

-- Note tests can be run via command line with:
xcodebuild test -scheme UAChat -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.2'