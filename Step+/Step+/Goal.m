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
@synthesize goalPriority;


-(void)AddGoaltoDatabase
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Goals (goalId,GoalName,GoalDesc,GoalDeadline,isGoalCompleted,isGoalinPregress,goalPercentage,CreatedBy,goalDate,numberofStepTaken,goalType,goalpriority) VALUES (%d,'%@','%@','%@','%d','%d','%f','%@','%@','%d','%@','%d')",self.goalID,self.goalName,self.goalDescription,self.goalDeadline,isGoalCompleted,isGoalinProgress,goalProgress,self.createdBy,self.goalDate,self.numberOfGoalSteps,goalType,goalPriority];
    
    
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
    
    NSLog(@"PATH: %@",[paths objectAtIndex:0]);
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
    [newGoal setObject:[NSString stringWithFormat:@"%d",self.goalPriority] forKey:@"goalpriority"];
    
    [newGoal saveEventually];
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
        insertSQL = [NSString stringWithFormat:@"UPDATE Goals SET goalPercentage='%f',numberofStepTaken='%d' where goalId='%d' AND createdBy='%@';",self.goalProgress+progress,self.numberOfGoalSteps,self.goalID,self.createdBy];
    }
    
    else
    {
        insertSQL = [NSString stringWithFormat:@"UPDATE Goals SET goalPercentage='%f',numberofStepTaken='%d' where goalId='%d' AND createdBy='%@';",self.goalProgress-progress,self.numberOfGoalSteps,self.goalID,self.createdBy];
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


-(void) UpdataGoalWithProgressInParse:(double) progress WithMark:(NSString*)mark
{
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    
    [query whereKey:@"goalID" equalTo:[NSString stringWithFormat:@"%d",self.goalID]];
    [query whereKey:@"createdBy" equalTo:self.createdBy];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateGoal, NSError *error){
        if (!error) {
            
            if ([mark isEqualToString:@"+"])
            {
            [updateGoal setObject: [NSString stringWithFormat:@"%f",[[updateGoal objectForKey:@"goalPercentage"] doubleValue]+progress] forKey:@"goalPercentage"];
                
            [updateGoal setObject: [NSString stringWithFormat:@"%d",self.numberOfGoalSteps] forKey:@"numberOfGoalSteps"];
            }
            
            else
            {
                [updateGoal setObject: [NSString stringWithFormat:@"%f",self.goalProgress-progress] forKey:@"goalPercentage"];
                [updateGoal setObject: [NSString stringWithFormat:@"%d",self.numberOfGoalSteps] forKey:@"numberOfGoalSteps"];
            }
            
            [updateGoal saveEventually];
        }
        
        else
        {

            NSLog(@"Error: %@", error);
        }
    }];
    
}

- (void) declareGoalAsAchieved
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE Goals SET isGoalCompleted='1',isGoalinPregress='0',numberofStepTaken='%d',goalPercentage='100.00' where goalId='%d' AND createdBy='%@';",self.numberOfGoalSteps,self.goalID,self.createdBy];
    

    
    
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

- (void) declareGoalAsUNAchieved
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE Goals SET isGoalCompleted='0',isGoalinPregress='1',numberofStepTaken='%d',goalPercentage='100.00' where goalId='%d' AND createdBy='%@';",self.numberOfGoalSteps,self.goalID,self.createdBy];
    
    
    
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


-(void)declareGoalAsAchievedinParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    
    [query whereKey:@"goalID" equalTo:[NSString stringWithFormat:@"%d",self.goalID]];
    [query whereKey:@"createdBy" equalTo:self.createdBy];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateGoal, NSError *error){
        if (!error) {
            
            [updateGoal setObject: @"100.00" forKey:@"goalPercentage"];
            [updateGoal setObject: [NSString stringWithFormat:@"%d",self.numberOfGoalSteps] forKey:@"numberOfGoalSteps"];
            [updateGoal setObject: @YES forKey:@"isGoalCompleted"];
            [updateGoal setObject: @NO forKey:@"isGoalinProgress"];
        }
        
        [updateGoal saveEventually];
    }];
}

-(void)declareGoalAsUNAchievedinParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    
    [query whereKey:@"goalID" equalTo:[NSString stringWithFormat:@"%d",self.goalID]];
    [query whereKey:@"createdBy" equalTo:self.createdBy];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateGoal, NSError *error){
        if (!error) {
            
            [updateGoal setObject: @"100.00" forKey:@"goalPercentage"];
            [updateGoal setObject: [NSString stringWithFormat:@"%d",self.numberOfGoalSteps] forKey:@"numberOfGoalSteps"];
            [updateGoal setObject: @NO forKey:@"isGoalCompleted"];
            [updateGoal setObject: @YES forKey:@"isGoalinProgress"];
        }
        
        [updateGoal saveEventually];
    }];
}


-(void)DeleteGoalFromDatabase
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM Goals WHERE goalId='%d' AND createdBy='%@';",self.goalID,self.createdBy];
    
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

-(void)DeleteGoalFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    
    [query whereKey:@"goalID" equalTo:[NSString stringWithFormat:@"%d",self.goalID]];
    [query whereKey:@"createdBy" equalTo:self.createdBy];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateGoal, NSError *error){
        if (!error) {
            [updateGoal deleteEventually];
        }
    }];
}


-(void) UpdateGoalPriority:(NSInteger) indexP
{
    
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE Goals SET goalPriority='%d' where goalId='%d' AND createdBy='%@';",indexP,self.goalID,self.createdBy];
    
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


-(void) UpdateGoalDB
{
    
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE Goals SET GoalName='%@', GoalDesc ='%@', goalDate = '%@' , goalType='%@' where goalId='%d' AND createdBy='%@';",self.goalName,self.goalDescription,goalDate,goalType,self.goalID,self.createdBy];
    
    
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


-(void) UpdateGoalParse
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    
    [query whereKey:@"goalID" equalTo:[NSString stringWithFormat:@"%d",self.goalID]];
    [query whereKey:@"createdBy" equalTo:self.createdBy];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateGoal, NSError *error){
        if (!error) {
            
            NSLog(@"Found it");
            
            
            [updateGoal setObject:self.goalName forKey:@"GoalName"];
            [updateGoal setObject:self.goalDescription forKey:@"GoalDesc"];
            [updateGoal setObject:self.goalDeadline forKey:@"GoalDeadline"];
            [updateGoal setObject:goalType forKey:@"goalType"];
        }
        [updateGoal saveEventually];
    }];
}

@end
