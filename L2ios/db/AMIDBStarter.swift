//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import UIKit
import GRDB

@objc class AMIDBStarter : NSObject {
    @objc static let sharedInstance = AMIDBStarter()
    
    public var dbQueue : DatabaseQueue? = nil
    
    @objc public func setupDatabase() {
        let fm = FileManager.default
        let url = try! fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let dbURL = url.appendingPathComponent("ami.sqlite")
        let dbQueue = try! DatabaseQueue(path: dbURL.path)
        try! migrator.migrate(dbQueue)
        dbQueue.setupMemoryManagement(in: UIApplication.shared)
        self.dbQueue = dbQueue
    }
    
    lazy var migrator: DatabaseMigrator = {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("m0001_initial_schema") { db in
            try db.create(table: "deviceModel") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("type", .text).notNull()
                t.column("name", .text).notNull()
                t.column("manufacturer", .text).notNull()
                t.column("supportedProtocols", .text).notNull()
                t.column("onboardSensors", .text).notNull()
            }
            
            try db.create(table: "device") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("deviceModelId", .integer).references("deviceModel", column: "id", onDelete: .cascade, onUpdate: .cascade, deferred: false)
                t.column("autogeneratedName", .text).notNull()
                t.column("name", .text).notNull()
                t.column("active", .boolean).notNull()
                t.column("tsAdded", .integer).notNull()
                t.column("tsLastSeen", .integer).notNull()
            }
        }
        
        migrator.registerMigration("m0002_test_populate") { db in
            var model = AMIDeviceModelEntity(id:nil,
                                             type:"T1",
                                             name:"RUUVITAG",
                                             manufacturer:"Ruuvi",
                                             supportedProtocols:"BTL4,BTL5",
                                             onboardSensors:"HUMI,TEMP,BARO,BATT");
            
            try model.insert(db)
            let modelIdRuuvi = model.id
            
            model = AMIDeviceModelEntity(id:nil,
                                         type:"T2",
                                         name:"CC2640",
                                         manufacturer:"TI",
                                         supportedProtocols:"BTL4,BTL5",
                                         onboardSensors:"VOLT");
            
            try model.insert(db)
            let modelIdCC2640 = model.id
            
            // Populate tables with demo data
            for ctr:Int in 1..<11 {
                let even = (ctr % 2 == 0 )
                let modelId = even ? modelIdRuuvi : modelIdCC2640
                let deviceName = even ? "Ruuvitag \(ctr / 2)" : "TI CC2640 \(ctr / 2)"
                var device = AMIDeviceEntity(id: nil,
                                             deviceModelId: modelId,
                                             autogeneratedName:"AutoName\(ctr)",
                                             name: deviceName,
                                             active:true,
                                             tsAdded: CACurrentMediaTime(),
                                             tsLastSeen: CACurrentMediaTime());
                
                try device.insert(db)
            }
        }
        
        return migrator
    }()
}