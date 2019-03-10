import Foundation


public extension Process{
    public func exe(_ launchPath:String,arguments:[String]? = nil) -> (Int32,String){
        self.launchPath = launchPath
        if arguments != nil {
            self.arguments = arguments
        }
        self.standardInput = FileHandle.nullDevice
        let pipe = Pipe()
        self.standardOutput = pipe
        self.standardError = pipe
        let pipeFile = pipe.fileHandleForReading
        self.launch()
        var data = Data()
        while self.isRunning {
            data.append(pipeFile.availableData)
        }
        pipeFile.closeFile()
        self.terminate()
        let terminationString = String(data: data, encoding: String.Encoding.utf8) ?? ""
        let terminationStatus = self.terminationStatus
        return (terminationStatus,terminationString)
    }
    
    public func exe(_ launchPath:String,arguments:[String]? = nil,logBlock:(String)->Void) -> Int32{
        self.launchPath = launchPath
        if arguments != nil {
            self.arguments = arguments
        }
        self.standardInput = FileHandle.nullDevice
        let pipe = Pipe()
        self.standardOutput = pipe
        self.standardError = pipe
        let pipeFile = pipe.fileHandleForReading
        self.launch()
        while self.isRunning {
            logBlock(String(data: pipeFile.availableData, encoding: String.Encoding.utf8) ?? "")
        }
        pipeFile.closeFile()
        self.terminate()
        return self.terminationStatus
    }
    
}
