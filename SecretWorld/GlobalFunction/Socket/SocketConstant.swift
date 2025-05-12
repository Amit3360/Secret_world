//
//  SocketConstant.swift
//  SecretWorld
//
//  Created by meet sharma on 15/04/24.
//

import Foundation

enum socketKeys : String {
//    case socketBaseUrl = "http://18.218.117.223:8081/"
    case socketBaseUrl = "https://ws.secretworld.ai/"
   
    var instance : String {
        return self.rawValue
    }
}
enum socketEmitters:String {
    
    //MARK: EMITTERS
    
    case sendMessage = "sendMessage"
    case messageList = "getMessages"
    case userMessage = "getUserMessages"
    case readMessages = "readMessages"
    case blockUnblock = "blockAndUnblockUser"
    case home = "home"
    case joinGroup = "joinRoom"
    case groupChat = "getGroupChat"
    case getEarning = "earnings"
    case readyUser = "userReady"
    case hideProfile = "hideProfile"
    case completedBy = "completedBy"
    case pinMsg = "pinMsg"
    case muteMsg = "muteMsg"
    case archiveMsg = "archiveMsg"
    case deleteMsg = "deleteMsg"
    case setNickname = "setNickname"
    case reaction = "reaction"
    case eventVideo = "addMedia"
    case msgSeen = "msgSeen"
    
    var instance : String {
        return self.rawValue
    }
}
enum socketListeners : String{
    
    //MARK: - LISTeNER
    case messageListListener = "getMessages"
    case sendMessageListener = "sendMessage"
    case userMessageListener = "getUserMessages"
    case homeListener = "home"
    case groupChatListener = "getGroupChat"
    case getGroupMessageListener = "getGroupMessage"
    case getEarningListener = "earnings"
    case msgSeenListener = "msgSeen"
    case refreshMessages = "refreshMessages"
    var instance : String {
        return self.rawValue
    }
}

