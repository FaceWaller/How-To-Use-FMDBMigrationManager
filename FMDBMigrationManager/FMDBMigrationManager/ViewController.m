//
//  ViewController.m
//  FMDBMigrationManager
//
//  Created by Alan on 2017/2/8.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import "ViewController.h"
#import "Fmdb.h"
#import "FMDBMigrationManager.h"
#import "Migration.h"
@interface ViewController ()
@property(nonatomic,copy)NSString * path;
@property(nonatomic,strong)FMDatabase * db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //定义一个地址存放数据库 为了查看方便我直接放在桌面
    NSString * path=@"/Users/alan/Desktop/fmdbMigration.db";
    _path=path;
    
    //生成数据库
    [self creatSqlite];
    
    //检查并升级数据库
    [self updatePrivateMsg];
  
}

- (void)creatSqlite{
    FMDatabase * db=[FMDatabase databaseWithPath:_path];
    _db=db;
    
    if ([_db open]) {
        //创建一个名为Student的表 包含一个字段name
        BOOL result=[_db executeUpdate:@"CREATE TABLE IF NOT EXISTS Student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        }else{
            NSLog(@"创表失败");
        }
        
        //存入十个小明
        for (int i=0; i<10; i++) {
            
            [_db executeUpdate:@"INSERT INTO Student (name) VALUES (?)",@"小明"];
        }
    }
    
    
    [_db close];
}


- (void)updatePrivateMsg{
    
    FMDBMigrationManager * manager=[FMDBMigrationManager managerWithDatabaseAtPath:_path migrationsBundle:[NSBundle mainBundle]];
    
    Migration * migration_1=[[Migration alloc]initWithName:@"新增USer表" andVersion:1 andExecuteUpdateArray:@[@"create table User(name text,age integer)"]];//从版本生升级到版本1创建一个User表 带有 name,age 字段
    
    
    Migration * migration_2=[[Migration alloc]initWithName:@"USer表新增字段email" andVersion:2 andExecuteUpdateArray:@[@"alter table User add email text"]];//给User表添加email字段
    
    
    
    [manager addMigration:migration_1];
    [manager addMigration:migration_2];
    
    BOOL resultState=NO;
    NSError * error=nil;
    if (!manager.hasMigrationsTable) {
        resultState=[manager createMigrationsTable:&error];
    }
    resultState=[manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
