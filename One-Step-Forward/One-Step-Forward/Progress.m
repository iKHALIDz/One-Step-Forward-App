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


-(void)AddProgressltoDatabase
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    NSString *createSQL= @"create table IF NOT exists Progress(progressID integer primary key, progressDescription text, progressPercentageToGoal REAL, goalID integer);";
    [db executeUpdate:createSQL];
    
    [self nextIdentifies];
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Progress (progressID,progressDescription,progressPercentageToGoal,goalID) VALUES (%d,'%@','%f','%d')",self.progressID,self.progressDescription,self.progressPercentageToGoal,self.goalID];
    
    
    NSLog(@"%@",insertSQL);
    
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
