import Vapor

public final class Provider: Vapor.Provider {
    
    var config: UAPusherConfig
    
    public func boot(_ drop: Droplet) {
        drop.uapusher = UAManager(uaPusherConfig: config, drop: drop)
    }
    
    public init(drop: Droplet) throws {
        config = try UAPusherConfig(drop: drop)
    }
    
    public init(config: Config) throws {
        guard let config: Config = config["uapusher"] else {
            throw Abort.custom(
                status: .internalServerError,
                message: "UAPusher error - uapusher.json config is missing."
            )
        }
        
        self.config = try UAPusherConfig(config: config)
    }
    
    // is automatically called directly after boot()
    public func afterInit(_ drop: Droplet) {
    }
    
    // is automatically called directly after afterInit()
    public func beforeRun(_: Droplet) {
    }
    
    public func beforeServe(_: Droplet) {
    }
}
