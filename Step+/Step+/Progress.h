//
//  Progress.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import <Parse/Parse.h>



@interface Progress : NSObject

@property (nonatomic,retain) NSString * progressDescription;
@property double progressPercentageToGoal;
@property int goalID;
@property int progressID;
@property (nonatomic,retain) NSString * LoggedBy;
@property int stepOrder;
@property (nonatomic,retain) NSString * progressDate;
@property int numberOfCommentss;
@property int numberOfLikes;


-(void)AddProgressltoDatabase;
-(void)DeleteProgressFromDatabase;
-(void)DeleteSingleProgressFromDatabase;
-(void)UpdateProgress;

-(void)AddProgresslToParse;
-(void)DeleteProgressFromParse;
-(void)UpdateProgressToParse;
-(void)DeleteSingleProgressFromParse;


@end
