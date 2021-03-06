import Vapor

public struct UAPusherConfig {
    
    var applicationGroups: [ApplicationGroup] = []
    
    public init(drop: Droplet) throws {
        
        // Set config
        guard let config: Config = drop.config["uapusher"] else {
            throw Abort.custom(
                status: .internalServerError,
                message: "UAPusher error - uapusher.json config is missing."
            )
        }
        
        try self.init(config: config)
    }
    
    public init(config: Config) throws {
        guard let applicationGroups = config["applicationGroups"]?.object else {
            throw Abort.custom(
                status: .internalServerError,
                message: "UAPusher error - applicationGroups are not set."
            )
        }
        
        if (applicationGroups.count < 1){
            throw Abort.custom(
                status: .internalServerError,
                message: "UAPusher error - there are no applicationGroups."
            )
        }
        
        for applicationGroup in applicationGroups {
            
            var group = ApplicationGroup(name: applicationGroup.key, applications: [])
            
            // Try to get the apps inside the  applicationGroup
            guard let applications = applicationGroup.value.object else {
                throw Abort.custom(
                    status: .internalServerError,
                    message: "UAPusher error - applicationGroup is missing applications."
                )
            }
            
            for application in applications {
                
                let appName = application.key
                
                guard let masterSecret = application.value.object?["masterSecret"]?.string else {
                    throw Abort.custom(
                        status: .internalServerError,
                        message: "UAPusher error - application is missing masterSecret."
                    )
                }
                
                guard let appKey = application.value.object?["appKey"]?.string else {
                    throw Abort.custom(
                        status: .internalServerError,
                        message: "UAPusher error - application is missing appKey."
                    )
                }
                
                group.applications.append(
                    Application(
                        name: appName,
                        masterSecret: masterSecret,
                        appKey: appKey
                    )
                )
            }
            
            // Store the group
            self.applicationGroups.append(group)
        }
    }
}
