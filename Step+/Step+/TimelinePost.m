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
@synthesize postID;
@synthesize whoLikePost;
@synthesize isLiked;
@synthesize whoCommentPost;


-(void) NewTimelinePost
{
    whoLikePost=[[NSMutableArray alloc]init];
    whoCommentPost=[[NSMutableArray alloc]init];
    

    self.postID=[self nextIdentifies];
    
    PFObject *newPost = [PFObject objectWithClassName:@"Timeline"];
    [newPost setObject:self.postID forKey:@"postID"];
    [newPost setObject:self.username forKey:@"username"];
    [newPost setObject:self.userFirstName forKey:@"userFirstName"];
    [newPost setObject:self.userLastName forKey:@"userLastName"];
    [newPost setObject:self.PostContent forKey:@"PostContent"];
    [newPost setObject:self.PostDate forKey:@"PostDate"];
    [newPost setObject:self.PostOtherRelatedInFormationContent forKey:@"PostOtherRelatedInFormationContent"];
    [newPost setObject:self.PostType forKey:@"PostType"];
    [newPost setObject:whoLikePost forKey:@"whoLikePost"];
    [newPost setObject:whoCommentPost forKey:@"whoCommentPost"];
    
    NSData *pictureData = UIImagePNGRepresentation(userProfilePic);
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        [newPost setObject:file forKey:@"userProfilePic"];
        [newPost saveEventually];
    }];
}

-(NSString *)nextIdentifies
{
    static NSString* lastID = @"PostlastID";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger identifier = [defaults integerForKey:lastID] + 1;
    [defaults setInteger:identifier forKey:lastID];
    [defaults synchronize];
    return [NSString stringWithFormat:@"%ld",(long)identifier];
}


-(void) UpdatePostLikes
{
    PFQuery *query = [PFQuery queryWithClassName:@"Timeline"];
    [query whereKey:@"postID" equalTo:postID];
    [query whereKey:@"username" equalTo:username];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
       
        if (!error)
        {

            [object setObject:whoLikePost forKey:@"whoLikePost"];
            
            [object saveEventually];
        }
        
        else
        {
            
            //NSLog(@"error");
        }
    
    }];
}

-(void) UpdatePostComments
{
    PFQuery *query = [PFQuery queryWithClassName:@"Timeline"];
    [query whereKey:@"postID" equalTo:postID];
    [query whereKey:@"username" equalTo:username];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error)
        {
            [object setObject:whoCommentPost forKey:@"whoCommentPost"];
            
            [object saveEventually];
        }
        
        else
        {
            
            //NSLog(@"error");
        }
        
    }];
}


@end

