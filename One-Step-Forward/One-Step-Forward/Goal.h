//
//  Goals.h
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/9/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Progress.h"
#import "FMDatabase.h"

typedef enum { OneTime,Weakly,Monthly,Yearly,Progressive } goalType;

@interface Goal : NSObject

@property int goalID;
@property (nonatomic,retain) NSString * goalName;
@property (nonatomic,retain) NSString * goalDescription;
@property (nonatomic,retain) NSString * goalDeadline;
@property double goalProgress;
@property BOOL isGoalCompleted;
@property BOOL isGoalinProgress;
@property (nonatomic,retain) NSArray * goalSteps;
@property (nonatomic) goalType  goalType;
@property (nonatomic,retain) NSString * createdBy;

-(void)AddGoaltoDatabase;
-(void)declareGoalAsAchieved;
-(void) UpdataGoalWithProgress:(double) progress WithMark:(NSString*)mark;

-(void)DeleteGoalFromDatabase;


@end