import Foundation
import Metal
import MetalPerformanceShaders

public let sharedMetalRenderingDevice = MetalRenderingDevice()

public class MetalRenderingDevice {
    // MTLDevice
    // MTLCommandQueue
    
    public let device: MTLDevice
    public let commandQueue: MTLCommandQueue
    public let shaderLibrary: MTLLibrary
    public let metalPerformanceShadersAreSupported: Bool
    
    lazy var passthroughRenderState: MTLRenderPipelineState = {
        let (pipelineState, _) = generateRenderPipelineState(device:self, vertexFunctionName:"oneInputVertex", fragmentFunctionName:"passthroughFragment", operationName:"Passthrough")
        return pipelineState
    }()

    lazy var colorSwizzleRenderState: MTLRenderPipelineState = {
        let (pipelineState, _) = generateRenderPipelineState(device:self, vertexFunctionName:"oneInputVertex", fragmentFunctionName:"colorSwizzleFragment", operationName:"ColorSwizzle")
        return pipelineState
    }()

    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {fatalError("Could not create Metal Device")}
               self.device = device
               
               guard let queue = self.device.makeCommandQueue() else {fatalError("Could not create command queue")}
               self.commandQueue = queue
               
               if #available(iOS 9, macOS 10.13, *) {
                   self.metalPerformanceShadersAreSupported = MPSSupportsMTLDevice(device)
               } else {
                   self.metalPerformanceShadersAreSupported = false
               }
               
               do {
                   #if targetEnvironment(simulator)
                   let resName: String = "defaultiOSSimulator"
                   #else
                   let resName: String = "defaultiOS"
                   #endif

                   let metalLibURL: URL = Bundle.module.url(forResource: resName, withExtension: "metallib")!
                   self.shaderLibrary = try device.makeLibrary(URL: metalLibURL)
               } catch {
                   fatalError("Could not load library")
               }
    }
}
