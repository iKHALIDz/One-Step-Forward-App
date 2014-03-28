//
//  Progress.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "Progress.h"

@implementation Progress

@synthesize progressDescription;
@synthesize progressPercentageToGoal;
@synthesize goalID;
@synthesize progressID;
@synthesize LoggedBy;
@synthesize stepOrder;
@synthesize progressDate;


//NSString *createSQL3= @"create table IF NOT exists Progress(progressID integer, progressDescription text, progressPercentageToGoal REAL, goalID integer,progressDate text,createdBy int,stepOrder int);";
//
//[db executeUpdate:createSQL3];


-(NSString*)DataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

-(void)AddProgressltoDatabase
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Progress (progressID,progressDescription,progressPercentageToGoal,goalID,progressDate,createdBy,stepOrder) VALUES (%d,'%@','%f','%d','%@','%@','%d')",self.progressID,self.progressDescription,self.progressPercentageToGoal,self.goalID,progressDate,self.LoggedBy,self.stepOrder];
    
    
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


-(void) AddProgresslToParse
{
    PFObject *newProgress = [PFObject objectWithClassName:@"Progress"];
    
    [newProgress setObject:[NSString stringWithFormat:@"%d",self.progressID] forKey:@"progressID"];
    [newProgress setObject:[NSString stringWithFormat:@"%d",self.goalID] forKey:@"goalID"];
    
    [newProgress setObject:self.progressDescription forKey:@"ProgressName"];
    [newProgress setObject:[NSString stringWithFormat:@"%.f",self.progressPercentageToGoal] forKey:@"ProgressPercentage"];
    
    [newProgress setObject:[NSString stringWithFormat:@"%d",self.stepOrder] forKey:@"stepOrder"];
    [newProgress setObject:[NSString stringWithFormat:@"%@",self.LoggedBy] forKey:@"createdBy"];
    
    [newProgress setObject:self.progressDate forKey:@"LogDate"];
    
    [newProgress saveEventually];
}

-(void)DeleteProgressFromDatabase
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }

    NSString *deleteSQLP = [NSString stringWithFormat:@"DELETE FROM Progress WHERE goalId='%d' AND createdBy='%@';",self.goalID,self.LoggedBy];

    
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

-(void)DeleteProgressFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
    
    [query whereKey:@"goalID" equalTo:[NSString stringWithFormat:@"%d",self.goalID]];
    [query whereKey:@"createdBy" equalTo:self.LoggedBy];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * updateGoals, NSError *error){
        if (!error) {
            
            for (PFObject* obj in updateGoals)
            {
                [obj deleteEventually];
            }
        }
    }];
}


@end
