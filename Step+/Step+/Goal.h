//
//  Goal.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/23/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import <Parse/Parse.h>

@interface Goal : NSObject

@property int goalID;
@property (nonatomic,retain) NSString * goalName;
@property (nonatomic,retain) NSString * goalDescription;
@property (nonatomic,retain) NSString * goalDeadline;
@property double goalProgress;
@property BOOL isGoalCompleted;
@property BOOL isGoalinProgress;
@property int numberOfGoalSteps;
@property (nonatomic) NSString *  goalType;
@property (nonatomic,retain) NSString * createdBy;
@property (nonatomic,retain) NSString *goalDate;

-(void)AddGoaltoDatabase;
-(void) AddGoalToParse;

@end
