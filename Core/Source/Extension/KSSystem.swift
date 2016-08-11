//
//  UIDevice.swift
//  Pods
//
//  Created by king on 16/3/30.
//
//

import Foundation
public class KSSystem {
    public static var isSimulator: Bool = {
        let device = UIDevice.currentDevice()
        var simulator = device.model.containsString("Simulator")
        if !simulator {
            simulator = KSSystem.machineModel.containsString("x86")
        }
        return simulator
    }()
    public static var machineModel: String = {
        var size : Int = 0 // as Ben Stahl noticed in his answer
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](count: Int(size), repeatedValue: 0)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String.fromCString(machine)!
    }()
}