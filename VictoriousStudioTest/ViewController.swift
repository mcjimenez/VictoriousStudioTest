//
//  ViewController.swift
//  VictoriousStudioTest
//
//  Created by cjc on 21/04/2017.
//  Copyright © 2017 TokBox. All rights reserved.
//

import UIKit
import OpenTok

let kApiKey = ""
let kSessionId = ""
let kToken = ""

class ViewController: UIViewController {
    
    lazy var session: OTSession = {
        return OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)!
    }()
    
    lazy var publisher: OTPublisher = {
        let settings = OTPublisherSettings()
        settings.cameraResolution = .high //.medium
        settings.cameraFrameRate = .rate30FPS
        return OTPublisher(delegate: self, settings: settings)!
    }()
    
    fileprivate var subscriber: OTSubscriber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doConnect()
    }
    
    fileprivate func doConnect() {
        var error: OTError?
        defer {
            processError(error)
        }
        session.connect(withToken: kToken, error: &error)
    }
    
    fileprivate func doPublish() {
        var error: OTError?
        defer {
            processError(error)
        }
        session.publish(publisher, error: &error)
        
        if let pubView = publisher.view {
            pubView.frame = UIScreen.main.bounds
            view.addSubview(pubView)
        }
    }
    
    fileprivate func processError(_ error:OTError?) {
        if let err = error {
            DispatchQueue.main.async {
                let controller = UIAlertController(title: "error",
                                                   message: err.localizedDescription,
                                                   preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}

extension ViewController: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
        doPublish()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session didFailWithError: \(error.localizedDescription)")
        processError(error)
    }
}

extension ViewController: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
        print("publisher streamCreated")
    }
    
    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
        print("publisher streamDestroyed")
    }
    
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("Publisher didFailWithError: \(error.localizedDescription)")
    }
}

extension ViewController: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
        print("subscriberDidConnect")
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("Subscriber didFailWithError: \(error.localizedDescription)")
        processError(error)
    }
    
    func subscriberVideoDataReceived(_ subscriber: OTSubscriber) {}
}
