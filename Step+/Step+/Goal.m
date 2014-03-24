//
//  Goal.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/23/14.
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
@synthesize numberOfGoalSteps;
@synthesize isGoalCompleted;
@synthesize isGoalinProgress;
@synthesize createdBy;
@synthesize goalDate;



//-(void)nextIdentifies
//{
//    static NSString* lastID = @"lastID";
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    NSInteger identifier = [defaults integerForKey:lastID] + 1;
//    [defaults setInteger:identifier forKey:lastID];
//    [defaults synchronize];
//    self.goalID= [[NSString stringWithFormat:@"%ld",(long)identifier] integerValue];
//}
//
//
//-(NSString *)getCurrentDataAndTime
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
//    NSDate *Todaydata=[NSDate date];
//    
//    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
//    
//    return currentData;
//}



-(void)AddGoaltoDatabase
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    // 0 means False
    // 1 means True

    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Goals (goalId,GoalName,GoalDesc,GoalDeadline,isGoalCompleted,isGoalinPregress,goalPercentage,CreatedBy,goalDate,numberofStepTaken,goalType) VALUES (%d,'%@','%@','%@','%d','%d','%f','%@','%@','%d','%@')",self.goalID,self.goalName,self.goalDescription,self.goalDeadline,isGoalCompleted,isGoalinProgress,goalProgress,self.createdBy,self.goalDate,self.numberOfGoalSteps,goalType];
    
    
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


-(NSString*)DataFilePath
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}


-(void) AddGoalToParse
{
    PFObject *newGoal = [PFObject objectWithClassName:@"Goal"];
    
    [newGoal setObject:[NSString stringWithFormat:@"%d",self.goalID] forKey:@"goalID"];
    [newGoal setObject:self.goalName forKey:@"GoalName"];
    [newGoal setObject:self.goalDescription forKey:@"GoalDesc"];
    [newGoal setObject:self.goalDeadline forKey:@"GoalDeadline"];
    [newGoal setObject:@NO forKey:@"isGoalCompleted"];
    [newGoal setObject:@YES forKey:@"isGoalinProgress"];
    [newGoal setObject:[NSString stringWithFormat:@"%f",self.goalProgress] forKey:@"goalPercentage"];
    [newGoal setObject:self.createdBy forKey:@"createdBy"];
    [newGoal setObject:goalDate forKey:@"goalDate"];
    [newGoal setObject:[NSString stringWithFormat:@"%d",self.numberOfGoalSteps] forKey:@"numberOfGoalSteps"];
    [newGoal setObject:self.goalType forKey:@"goalType"];
    
    [newGoal saveEventually];
}

@end
