//
//  Log.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/17/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Log : NSObject

@property int logID;
@property int userID;
@property (nonatomic,retain) NSString * logDate;
@property (nonatomic,retain) NSString * logContent;
@property (nonatomic,retain) NSString * logType;
@property (nonatomic,retain) NSString * logAction;


@end
