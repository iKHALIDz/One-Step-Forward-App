//
//  Step.m
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/9/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "Progress.h"

@implementation Progress

@synthesize progresslName;
@synthesize progressDescription;
@synthesize progressPercentageToGoal;
@synthesize goalID;
@synthesize progressID;
@synthesize LoggedBy;


-(NSString*)DataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

-(void)nextIdentifies
{
    static NSString* lastID = @"lastID";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger identifier = [defaults integerForKey:lastID] + 1;
    [defaults setInteger:identifier forKey:lastID];
    [defaults synchronize];
    self.progressID= [[NSString stringWithFormat:@"%ld",(long)identifier] integerValue];
}

-(int)nextIdentifies2
{
    static NSString* lastID = @"lastID";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger identifier = [defaults integerForKey:lastID] + 1;
    [defaults setInteger:identifier forKey:lastID];
    [defaults synchronize];
    return [[NSString stringWithFormat:@"%ld",(long)identifier] integerValue];
}


-(NSString *)getCurrentDataAndTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}

-(void)AddProgressltoDatabase
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
  
    
    [self nextIdentifies];
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Progress (progressID,progressDescription,progressPercentageToGoal,goalID,progressDate,createdBy) VALUES (%d,'%@','%f','%d','%@','%d')",self.progressID,self.progressDescription,self.progressPercentageToGoal,self.goalID,[self getCurrentDataAndTime],self.LoggedBy];
    
    NSLog(@"%@",insertSQL);
    
    BOOL succ=[db executeUpdate:insertSQL];
    
    if (succ==YES) {
        NSLog(@"Succseed");
        
        NSString *LoginsertSQL = [NSString stringWithFormat:@"INSERT INTO Logs (logID,userID,logDate,LogContent,logType,logAction) VALUES (%d,'%d','%@','%@','%@','%@')",[self nextIdentifies2],self.LoggedBy,[self getCurrentDataAndTime],self.progressDescription,@"Progress",@"Progress Logged"];
        

        [db executeUpdate:LoginsertSQL];

    }
    else
    {
        NSLog(@"Fail");
    }
    
    [db close];
}


-(void)DeleteProgressFromDatabase
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM Progress WHERE progressID='%d';",self.progressID];
    
    NSLog(@"%@",deleteSQL);
    
    BOOL succ=[db executeUpdate:deleteSQL];
    
    if (succ==YES) {
        NSLog(@"Succseed");
        
        NSString *LoginsertSQL = [NSString stringWithFormat:@"INSERT INTO Logs (logID,userID,logDate,LogContent,logType,logAction) VALUES (%d,'%d','%@','%@','%@','%@')",[self nextIdentifies2],self.LoggedBy,[self getCurrentDataAndTime],self.progressDescription,@"Progress",@"Progress Deleted"];
        
        [db executeUpdate:LoginsertSQL];
    }
    else
    {
        NSLog(@"Fail");
    }
    
    [db close];
    
}

-(void)UpdateProgress
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    
    NSString * insertSQL = [NSString stringWithFormat:@"UPDATE Progress SET progressDescription='%@',progressPercentageToGoal='%f' where progressID='%d';",self.progressDescription,self.progressPercentageToGoal,self.progressID];
    
    BOOL succ=[db executeUpdate:insertSQL];
    
    if (succ==YES) {
        NSLog(@"Succseed");
    }
    else
    {
        NSLog(@"Fail");
    }
    
    [db close];
}

@end
