//
//  timelinePostLike.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/9/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface timelinePostLike : NSObject

@property (nonatomic,retain) NSString * From;
@property (nonatomic,retain) NSString * To;
@property (nonatomic,retain) UIImage *FromuserProfilePic;
@property (nonatomic,retain) NSString *PostID;
@property (nonatomic,retain) NSString *ItemRID;
@property BOOL isLiked;

-(void) like;
-(void) unlike;


@end
