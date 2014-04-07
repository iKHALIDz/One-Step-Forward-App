//
//  TimelinePost.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/6/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "TimelinePost.h"

@implementation TimelinePost

@synthesize PostContent;
@synthesize PostDate;
@synthesize PostOtherRelatedInFormationContent;
@synthesize username;
@synthesize userFirstName;
@synthesize userLastName;
@synthesize userProfilePic;
@synthesize PostType;

-(void) NewTimelinePost
{
    PFObject *newPost = [PFObject objectWithClassName:@"Timeline"];
    
    [newPost setObject:self.username forKey:@"username"];
    [newPost setObject:self.userFirstName forKey:@"userFirstName"];
    [newPost setObject:self.userLastName forKey:@"userLastName"];
    [newPost setObject:self.PostContent forKey:@"PostContent"];
    [newPost setObject:self.PostDate forKey:@"PostDate"];
    [newPost setObject:self.PostOtherRelatedInFormationContent forKey:@"PostOtherRelatedInFormationContent"];
    [newPost setObject:self.PostType forKey:@"PostType"];
    
    NSData *pictureData = UIImagePNGRepresentation(userProfilePic);
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        [newPost setObject:file forKey:@"userProfilePic"];
        [newPost saveEventually];
    }];
}

@end

