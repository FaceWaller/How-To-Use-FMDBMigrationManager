//
//  Migration.h
//  FMDBMigrationManager
//
//  Created by Alan on 2017/2/8.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBMigrationManager.h"
@interface Migration : NSObject<FMDBMigrating>
- (instancetype)initWithName:(NSString *)name andVersion:(uint64_t)version andExecuteUpdateArray:(NSArray *)updateArray;//自定义方法

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) uint64_t version;
- (BOOL)migrateDatabase:(FMDatabase *)database error:(out NSError *__autoreleasing *)error;


@end
