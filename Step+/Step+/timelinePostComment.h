//
//  timelinePostComment.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface timelinePostComment : NSObject

@property (nonatomic,retain) NSString * From;
@property (nonatomic,retain) NSString * To;
@property (nonatomic,retain) NSString * commentContent;
@property (nonatomic,retain) UIImage *FromuserProfilePic;
@property (nonatomic,retain) NSString *PostID;

@end
