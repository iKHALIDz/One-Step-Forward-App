//
//  TimelinePost.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/6/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface TimelinePost : NSObject

@property (nonatomic,retain) NSString * username;
@property (nonatomic,retain) NSString * userFirstName;
@property (nonatomic,retain) NSString * userLastName;
@property (nonatomic,retain) UIImage *userProfilePic;
@property (nonatomic,retain) NSString *PostDate;
@property (nonatomic,retain) NSString *PostContent;
@property (nonatomic,retain) NSString *PostOtherRelatedInFormationContent;
@property (nonatomic,retain) NSString * PostType;
@property (nonatomic,retain) NSString * postID;


-(void) NewTimelinePost;

@end
