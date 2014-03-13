//
//  Goals.m
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/9/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "Goal.h"

@implementation Goal

@synthesize goalID;

@synthesize goalName;
@synthesize goalDescription;
@synthesize goalProgress;
@synthesize goalDeadline;
@synthesize goalType;
@synthesize goalSteps;
@synthesize isGoalCompleted;
@synthesize isGoalinProgress;
@synthesize createdBy;


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
    self.goalID= [[NSString stringWithFormat:@"%ld",(long)identifier] integerValue];
}

-(void)AddGoaltoDatabase
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    NSString *createSQL= @"create table IF NOT exists Goals(goalId integer primary key,GoalName text, GoalDesc text, GoalDeadline text, isGoalCompleted integer, isGoalinPregress integer, goalPercentage REAL,CreatedBy text);";
    [db executeUpdate:createSQL];
    
    // 0 means False
    // 1 means True
    [self nextIdentifies];
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Goals (goalId,GoalName,GoalDesc,GoalDeadline,isGoalCompleted,isGoalinPregress,goalPercentage,CreatedBy) VALUES (%d,'%@','%@','%@','%d','%d','%f','%@')",self.goalID,self.goalName,self.goalDescription,self.goalDeadline,0,1,0.0,self.createdBy];
    
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

- (void) declareGoalAsAchieved
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    // 0 means False
    // 1 means True
    
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE Goals SET isGoalCompleted='1',isGoalinPregress='0',goalPercentage='100.00' where goalId='%d';",self.goalID];
    NSLog(@"%@",insertSQL);
    BOOL succ=[db executeUpdate:insertSQL];
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

-(void) UpdataGoalWithProgress:(double) progress WithMark:(NSString*)mark
{

    
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *insertSQL;
    
    if ([mark isEqualToString:@"+"])
    {
        insertSQL = [NSString stringWithFormat:@"UPDATE Goals SET goalPercentage='%f' where goalId='%d';",self.goalProgress+progress,self.goalID];
    }
    
    else
    {
        insertSQL = [NSString stringWithFormat:@"UPDATE Goals SET goalPercentage='%f' where goalId='%d';",self.goalProgress-progress,self.goalID];
    }
    
    NSLog(@"%@",insertSQL);
    BOOL succ=[db executeUpdate:insertSQL];
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

-(void)DeleteGoalFromDatabase
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM Goals WHERE goalId='%d';",self.goalID];
    
    NSLog(@"%@",deleteSQL);
    
    BOOL succ=[db executeUpdate:deleteSQL];
    
    if (succ==YES) {
        NSLog(@"Succseed");
        
        NSString *deleteSQLP = [NSString stringWithFormat:@"DELETE FROM Progress WHERE goalId='%d';",self.goalID];
        
        NSLog(@"%@",deleteSQLP);
        BOOL succ=[db executeUpdate:deleteSQLP];
        
        if (succ==YES) {
            NSLog(@"Succseed");
        }
        else
        {
            NSLog(@"Fail");
        }
    }
    
    else
    {
        NSLog(@"Fail");
    }
    
    [db close];
}

@end