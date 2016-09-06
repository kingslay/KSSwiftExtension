//
//  KS.swift
//  Pods
//
//  Created by king on 16/8/20.
//
//

public struct Swifty<Base> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol KSCompatible {
    associatedtype CompatibleType
    var ks: Swifty<CompatibleType> { get }
}

public extension KSCompatible {
    public var ks: Swifty<Self> {
        return Swifty(self)
    }
}

/**
 Extend NSObject with `ks` proxy.
 */
extension NSObject: KSCompatible { }

public struct KS {
    public static let SCREEN_BOUND = UIScreen.mainScreen().bounds
    public static let SCREEN_WIDTH = SCREEN_BOUND.width
    public static let SCREEN_HEIGHT = SCREEN_BOUND.height
    public static let SCREEN_SCALE = UIScreen.mainScreen().scale
    public static let SCREEN_RATIO = SCREEN_WIDTH/320.0
    public static var isSimulator: Bool = {
        let device = UIDevice.currentDevice()
        var simulator = device.model.containsString("Simulator")
        if !simulator {
            simulator = KS.machineModel.containsString("x86")
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
