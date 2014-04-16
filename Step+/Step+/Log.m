//
//  Log.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/17/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "Log.h"

@implementation Log

@synthesize logID,userUsername,logContent,logAction,logDate,logType;
@synthesize month;
@synthesize year;


-(NSString*)DataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"PATH: %@",[paths objectAtIndex:0]);
    
    return [paths objectAtIndex:0];
}


-(void) addLOG
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    [self nextIdentifies];
    
    NSString *LoginsertSQL = [NSString stringWithFormat:@"INSERT INTO Logs (logID,userUsername,logDate,LogContent,logType,logAction,month,year) VALUES ('%d','%@','%@','%@','%@','%@','%d','%d')",logID,userUsername,logDate,logContent,logType,logAction,month,year];
    
    NSLog(@"%@",LoginsertSQL);
    
    BOOL succ=[db executeUpdate:LoginsertSQL];
    
    if (succ==YES)
    {
        NSLog(@"Succseed");
    }
    else
    {
        NSLog(@"Fail");
    }
    
    [db close];
    
}

-(void)nextIdentifies
{
    static NSString* lastID = @"LastLogID";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger identifier = [defaults integerForKey:lastID] + 1;
    [defaults setInteger:identifier forKey:lastID];
    [defaults synchronize];
    self.logID= [[NSString stringWithFormat:@"%ld",(long)identifier] integerValue];
}

@end



