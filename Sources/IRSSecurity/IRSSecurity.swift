import Foundation
import IRSProcess

let macosx_profile_path = "MobileDevice/Provisioning Profiles"

enum IRSSecurityError:Int{
    case securityError
}

extension IRSSecurityError:CustomNSError{
    var errorCode: Int{
        return self.rawValue
    }
    var errorUserInfo: [String : Any]{
        return [NSLocalizedDescriptionKey:"security CertUsageAnyCA error"]
    }
    static var errorDomain: String{
        return "IRSProvisioningProfileManagerError"
    }
}

public struct IRSProfile{
    public let localPath:URL
    
    public let appIdentifier:String
    public let name:String
    public let expiretionDate:Date?
    public let creationDate:Date?
    public let teamIdentifier:[String]?
    public let teamName:String?
    
    public init(_ localPath:URL) throws {
        self.localPath = localPath
        let certXML = try securityCertUsageAnyCA(localPath)
        guard let certData = certXML.data(using: .utf8) else{
            throw IRSSecurityError.securityError
        }
        guard let plist = try PropertyListSerialization.propertyList(from: certData, options: PropertyListSerialization.MutabilityOptions(), format: nil) as? [AnyHashable:Any] else{
            throw IRSSecurityError.securityError
        }
        guard let entitlements = plist["Entitlements"] as? [AnyHashable:Any] else {
            throw IRSSecurityError.securityError
        }
        self.appIdentifier = (entitlements["application-identifier"] as? String) ?? ""
        self.name = (plist["Name"] as? String) ?? ""
        self.expiretionDate = plist["ExpirationDate"] as? Date
        self.creationDate = plist["CreationDate"] as? Date
        self.teamIdentifier = plist["TeamIdentifier"] as? [String]
        self.teamName = plist["TeamName"] as? String
    }

    
}

public func getInstalledProfiles() throws-> [IRSProfile]{
    var iRSProfiles:[IRSProfile] = []
    if let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first{
        let profilesDirectory = libraryDirectory.appendingPathComponent(macosx_profile_path)
        let contentsOfProfilesDirectory = try FileManager.default.contentsOfDirectory(atPath: profilesDirectory.path)
        for profile in contentsOfProfilesDirectory{
            var profileUrlOptional:URL?
            if #available(OSX 10.11, *) {
                profileUrlOptional = URL(fileURLWithPath: profile, relativeTo: profilesDirectory)
            } else {
                // Fallback on earlier versions
                profileUrlOptional = URL(string: profile, relativeTo: profilesDirectory)
            }
            guard let profileUrl = profileUrlOptional else{
                continue
            }
            if profileUrl.pathExtension == "mobileprovision"{
                do{
                    let iRSProfile = try IRSProfile(profileUrl)
                    iRSProfiles.append(iRSProfile)
                }catch{
                    print(error)
                }
            }
        }
    }
    return iRSProfiles
}

public func getCodesigningIdentity() throws -> [String]{
    let arguments = ["find-identity","-v","-p","codesigning"]
    let outPut = Process().exe("/usr/bin/security", arguments: arguments)
    if outPut.0 != 0 {
        throw IRSSecurityError.securityError
    }
    let codesigningIdentitys =  outPut.1.components(separatedBy: "\n").filter { (str) -> Bool in
        return !str.isEmpty
        }.filter { (str) -> Bool in
            return str.contains("\"")
    }
    var codesigningIdentitysList:[String] = []
    for codesigningIdentity in codesigningIdentitys {
        guard let firstIndex = codesigningIdentity.firstIndex(of: "\""),let lastIndex = codesigningIdentity.lastIndex(of: "\"") else{
            continue
        }
        let subRang = String.Index.init(encodedOffset: firstIndex.encodedOffset + 1) ..< lastIndex
        codesigningIdentitysList.append(String(codesigningIdentity[subRang]))
    }
    return codesigningIdentitysList
}

public func securityCertUsageAnyCA(_ path:URL) throws -> String{
    let arguments = ["cms","-D","-i",path.path]
    let outPut = Process().exe("/usr/bin/security", arguments: arguments)
    if outPut.0 != 0 {
        throw IRSSecurityError.securityError
    }
    return outPut.1
}
