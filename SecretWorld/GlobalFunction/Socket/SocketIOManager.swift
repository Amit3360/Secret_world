
//  SocketIOManager.swift
//  SecretWorld
//
//  Created by meet sharma on 15/04/24.
//

import Foundation

import UIKit
import SocketIO
import CoreData
import SwiftyJSON

protocol SocketDelegate {
    func listenedData(data: JSON, response: String)
}
enum SocketError: Error {
    case socketNotInitialized
    case managerNotInitialized
    // Add more cases as needed
}

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient?
    var manager: SocketManager?
    var delegate: SocketDelegate?
    var chatData: (([ChatModel]?) -> ())?
    var homeData: (([HomeModel]?) -> ())?
    var messageData: (([MessageListModel]?) -> ())?
    var groupData: (([GroupChatModel]?) -> ())?
    var sendMessageData:(()->())?
    var seenMessageData:(()->())?
    var getGroupMessageData: (() -> ())?
    var earningData: (([EarningModel]?) -> ())?
    
    private override init() {
        super.init()
        
        initializeSocket()
        loadListeners()
    }
    
    private func initializeSocket() {
        guard let socketURL = URL(string: socketKeys.socketBaseUrl.instance) else {
            print("Invalid socket URL")
            return
        }
        manager = SocketManager(socketURL: socketURL, config: [.log(true), .compress, .connectParams([:])])
        socket = manager?.defaultSocket
      
    }
    
    // MARK: - Socket Connection
    
    func connectMySocket(userId: String) {
        manager?.config = [.log(true), .compress, .connectParams(["userId": userId,"deviceId":Store.deviceToken ?? "","token":Store.authKey ?? ""])]
        print(Store.userId ?? "",Store.deviceToken ?? "",Store.authKey ?? "")
        socket?.on(clientEvent: .connect) { [weak self] _, _ in
            print("Socket connected Successfully")
            
            self?.loadListeners()
        }
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func reConnectSocket(userId: String) {
        initializeSocket()
        connectMySocket(userId: userId)
    }
    
    // MARK: - Event Listeners
    
    func loadListeners() {
        guard let socket = self.socket else {
            print("Socket is not initialized.")
            
            return
        }
        
        socket.on(clientEvent: .statusChange) { data, ack in
            print("Status Change")
        }
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected Successfully")
            
        }
        
        socket.on(clientEvent: .reconnectAttempt) { data, ack in
            print("Reconnect Attempt")
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print("Error: \(data)")
            
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Disconnect")
            
        }
        
        socket.on(socketListeners.userMessageListener.instance) { (data, emitter) in
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let messages = try JSONDecoder().decode([MessageListModel].self, from: jsonData)
                
                self.messageData?(messages)
                
                print("Received Messages: \(data.count)")
            } catch {
                print("Error decoding message: \(error)")
            }
            print("Get Single USer Message Listener========= \(data)")
        }
        
        
        self.socket?.on(socketListeners.messageListListener.instance) { (data, emitter) in
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let messages = try JSONDecoder().decode([ChatModel].self, from: jsonData)
                
                self.chatData?(messages)
                
                print("Received Messages: \(data.count)")
            } catch {
                print("Error decoding message: \(error)")
            }
            print("Get User Chat Listener")
            
        }
        
//        self.socket?.on(socketListeners.groupChatListener.instance) { (data, emitter) in
//            do {
//                // Log the raw data to understand its format
//                print("Raw data received from socket: \(data)")
//
//                // Log the data type
//                print("Data type: \(type(of: data))")
//                NotificationCenter.default.post(name: Notification.Name("GetMessage"), object: nil)
//
//
//                // Check if `data` is an array of arrays
//                if let dataDictArray = data as? [[String: Any]] {
//                    print("Data is an array containing arrays")
//
//                    // Initialize an empty array to hold the decoded messages
//                    var messages = [GroupChatModel]()
//
//                    // Iterate over the array of arrays
//                    for arrayElement in dataDictArray {
//                        for element in arrayElement {
//                            if let dataDict = element as? [String: Any] {
//                                print("Found a dictionary in array element")
//
//                                // Convert the dictionary to JSON data
//                                let jsonData = try JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
//
//                                // Decode the JSON data to a GroupChatModel
//                                let message = try JSONDecoder().decode(GroupChatModel.self, from: jsonData)
//
//                                // Append the decoded message to the messages array
//                                messages.append(message)
//                            } else {
//                                print("Unexpected inner structure: \(element)")
//                            }
//                        }
//                    }
//
//                    // Pass the decoded messages to the handler
//                    self.groupData?(messages)
//
//                    print("Received multiple messages")
//                } else {
//
//                    // Log an error if the data format is unexpected
//                    print("Error: Data is not in expected format. Data: \(data)")
//                }
//            } catch {
//                // Log any decoding errors
//                print("Error decoding message: \(error)")
//            }
//            print("Get GroupMessage Chat Listener")
//        }
        
        self.socket?.on(socketListeners.groupChatListener.instance) { (data, emitter) in
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let messages = try JSONDecoder().decode([GroupChatModel].self, from: jsonData)
                
                self.groupData?(messages)
                
                print("Received Messages: \(data.count)")
            } catch {
                print("Error decoding message: \(error)")
            }
            print("Get GroupMessage Chat Listener")
            
        }
        
        self.socket?.on(socketListeners.sendMessageListener.instance) { (data, emitter) in
            
            self.sendMessageData?()
            
            print("Get send Message Listener")
            
            
        }
        self.socket?.on(socketListeners.refreshMessages.instance) { (data, emitter) in
            
            self.seenMessageData?()
            
            print("refresh Message Listener")
            
            
        }
        self.socket?.on(socketListeners.msgSeenListener.instance) { (data, emitter) in
       
            self.seenMessageData?()
            print("Seen Message Listener--------------")
            
            
        }
        self.socket?.on(socketListeners.getGroupMessageListener.instance) { (data, emitter) in
            
            self.getGroupMessageData?()
            NotificationCenter.default.post(name: Notification.Name("GetGroupMessage"), object: nil)
            print("Get Message Listener triggered")
        }
        
        self.socket?.on(socketListeners.homeListener.instance) { (data, emitter) in
           
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let messages = try JSONDecoder().decode([HomeModel].self, from: jsonData)
             
                self.homeData?(messages)
                guard let firstItem = messages.first,
                         let filteredItems = firstItem.data?.filteredItems else {
                       print("Error: Data structure is not in the expected format")
                       return
                   }
                   
                   // Post Notification with userInfo
                   NotificationCenter.default.post(
                       name: Notification.Name("homeFilter"),
                       object: nil,
                       userInfo: ["filteredItems": filteredItems]
                   )
                print("Received Messages: \(data.count)")
            } catch {
                print("Error decoding message: \(error)")
            }
            
            print("Get Home Listener")
            
        }
        
        self.socket?.on(socketListeners.getEarningListener.instance) { (data, emitter) in
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let messages = try JSONDecoder().decode([EarningModel].self, from: jsonData)
                
                self.earningData?(messages)
                
                print("Received Earning: \(data.count)")
            } catch {
                print("Error decoding message: \(error)")
            }
            print("Get Total Earning")
            
        }
        
    }
    
}

extension SocketIOManager{
    
    func getUserMessage(dict:[String:Any]){
        socket?.emit(socketEmitters.userMessage.instance, dict)
        
    }
    
    func getMessageList(dict:[String:Any]){
        socket?.emit(socketEmitters.messageList.instance, dict)
    }
    
    func sendMessage(dict:[String:Any]){
        socket?.emit(socketEmitters.sendMessage.instance, dict)
    }
    
    func readMessage(dict:[String:Any]){
        socket?.emit(socketEmitters.readMessages.instance, dict)
    }
    
    func blockUnblock(dict:[String:Any]){
        socket?.emit(socketEmitters.blockUnblock.instance, dict)
    }
    
    func home(dict:[String:Any]){
        socket?.emit(socketEmitters.home.instance, dict)
        
    }
    
    func joinGroup(dict:[String:Any]){
        socket?.emit(socketEmitters.joinGroup.instance, dict)
    }
    
    func getGroupChat(dict:[String:Any]){
        socket?.emit(socketEmitters.groupChat.instance, dict)
        print("Emit get groupchat")
    }
    
    func getEarnings(dict:[String:Any]){
        socket?.emit(socketEmitters.getEarning.instance, dict)
        print("Emit getEarnings")
        
    }
    
    func readyUser(dict:[String:Any]){
        socket?.emit(socketEmitters.readyUser.instance, dict)
        print("Emit ready user")
    }
    
    func hideProfile(dict:[String:Any]){
        socket?.emit(socketEmitters.hideProfile.instance, dict)
        print("Emit hideProfile")
    }
    
    func completedBy(dict:[String:Any]){
        socket?.emit(socketEmitters.completedBy.instance, dict)
        print("Emit Completed By")
    }
    
    func pinChat(dict:[String:Any]){
        socket?.emit(socketEmitters.pinMsg.instance, dict)
        print("pin chat emit")
    }
    
    func muteChat(dict:[String:Any]){
        socket?.emit(socketEmitters.muteMsg.instance, dict)
        print("mute chat emit")
    }
    
    func archiveChat(dict:[String:Any]){
        socket?.emit(socketEmitters.archiveMsg.instance, dict)
        print("archive chat emit")
    }
    
    func deleteChat(dict:[String:Any]){
        socket?.emit(socketEmitters.deleteMsg.instance, dict)
        print("delete chat emit")
    }
    func setNickname(dict:[String:Any]){
        socket?.emit(socketEmitters.setNickname.instance, dict)
        print("nickname emit")
    }
    func messageReact(dict:[String:Any]){
        socket?.emit(socketEmitters.reaction.instance, dict)
        print("message react emit")
    }
    func seenMsg(dict: [String: Any]) {
        socket?.emit(socketEmitters.msgSeen.instance, dict)
        print("seen message emit")
    }
    func sendImgVideo(dict: [String: Any]) {
        socket?.emit(socketEmitters.eventVideo.instance, dict)
    }
}

