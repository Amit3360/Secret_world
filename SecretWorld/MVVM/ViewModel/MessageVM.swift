//
//  MessageVM.swift
//  SecretWorld
//
//  Created by Ideio Soft on 08/04/25.
//

import Foundation
import UIKit

class MessageVM{
    func fileUploadAudio(audio: URL, onSuccess: @escaping ((FileUploadData?) -> ())) {
        do {
            let audioData = try Data(contentsOf: audio)
            let audioFileName = audio.lastPathComponent // Extracts file name from URL
            
            // Ensure the type is "wav" since we are recording in WAV format
            let audioStruct = ImageStructInfo(
                fileName: audioFileName,
                type: "wav", // Set to WAV
                data: audioData,
                key: "media"
            )
            
            let param:parameters = ["Images":audioStruct]
            print("Uploading audio file:", param)
            
            WebService.service(API.uploadImage, param: param, service: .post, showHud: true, is_raw_form: false) { (model: FileUploadModel, _, _) in
                onSuccess(model.data)
            }
        } catch {
            print("Error loading audio file:", error.localizedDescription)
        }
    }
}
