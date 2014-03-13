//
//  Step.h
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/9/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Progress : NSObject

@property (nonatomic,retain) NSString * progresslName;
@property (nonatomic,retain) NSString * progressDescription;
@property double progressPercentageToGoal;
@property int goalID;
@property int progressID;

-(void)AddProgressltoDatabase;
-(void)DeleteProgressFromDatabase;
-(void)UpdateProgress;

@end
