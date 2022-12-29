//
//  MQTTBrokerManager.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 27/12/2022.
//

import SwiftUI
import CocoaMQTT
import CocoaMQTTWebSocket

final class MQTTManager: ObservableObject {
    
    private var mqttClient: CocoaMQTT5?
    
    enum State {
        case connected
        case disconnected
    }
    @Published var state: State = .disconnected
    
    // MARK: Shared Instance
    private static let _shared = MQTTManager()
    
    // MARK: - Accessors
    class func shared() -> MQTTManager {
        return _shared
    }
    
    func initializeMQTT() {
        let websocket = CocoaMQTTWebSocket(uri: "/mqtt")
        mqttClient = CocoaMQTT5(clientID: "CocoaMQTT-\(ProcessInfo().processIdentifier)", host: "broker.emqx.io", port: 8083, socket: websocket)
        mqttClient!.logLevel = .error
        mqttClient!.autoReconnect = true
    }
    
    func connect() {
        DispatchQueue.main.sync {
            if let success = mqttClient?.connect(), success {
                state = .connected
                print("[MQTT]: Connected")
            }
            else {
                state = .disconnected
                print("[MQTT]: Error connecting")
            }
        }
    }

    func subscribe(topic: String) {
        if (state == .disconnected) { return }
        mqttClient!.subscribe(topic, qos: .qos1)
        print("[MQTT]: Subscribed to '\(topic)'")
    }
    
    func unSubscribe(topic: String) {
        if (state == .disconnected) { return }
        mqttClient!.unsubscribe(topic)
        print("[MQTT]: Unsubscribed to '\(topic)'")
    }

    func publish(topic: String, message: String) {
        if (state == .disconnected) { return }
        mqttClient!.publish(topic, withString: message, qos: .qos1, properties: MqttPublishProperties())
        print("[MQTT]: Published '\(message)' to '\(topic)'")
    }
    
    func setMessageCallback(onMessage: @escaping (_ mqtt: CocoaMQTT5, _ message: CocoaMQTT5Message, _ id: UInt16, _ decoded: MqttDecodePublish?) -> Void) {
        if (state == .disconnected) { return }
        mqttClient?.didReceiveMessage = onMessage
    }

    func disconnect() {
        if (state == .disconnected) { return }
        mqttClient?.disconnect()
        print("[MQTT]: Disconnected")
    }
    
}


