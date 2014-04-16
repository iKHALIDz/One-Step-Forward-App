//
//  Log.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/17/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import <Parse/Parse.h>

@interface Log : NSObject

@property int logID;
@property (nonatomic,retain) NSString *userUsername;
@property (nonatomic,retain) NSString * logDate;
@property (nonatomic,retain) NSString * logContent;
@property (nonatomic,retain) NSString * logType;
@property (nonatomic,retain) NSString * logAction;
@property int month;
@property int year;

-(void) addLOG;

@end