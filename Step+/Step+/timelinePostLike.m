//
//  timelinePostLike.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/9/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "timelinePostLike.h"

@implementation timelinePostLike

@synthesize PostID,From,To,FromuserProfilePic,ItemRID;
@synthesize isLiked;


-(void)like
{
    PFQuery *query = [PFQuery queryWithClassName:@"PostLike"];
    
    [query whereKey:@"From" equalTo:self.From];
    [query whereKey:@"PostID" equalTo:PostID];
    
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error)
        {
            [object setObject:@YES forKey:@"isLiked"];
            [object saveEventually];
        }
        else
        {
            PFObject *newPostlike = [PFObject objectWithClassName:@"PostLike"];
            
            [newPostlike setObject:To forKey:@"To"];
            [newPostlike setObject:From forKey:@"From"];
            [newPostlike setObject:@YES forKey:@"isLiked"];
            [newPostlike setObject:PostID forKey:@"PostID"];
            [newPostlike setObject:self.ItemRID forKey:@"ItemID"];
            
            NSData *pictureData = UIImagePNGRepresentation(FromuserProfilePic);
            PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [newPostlike setObject:file forKey:@"FromuserProfilePic"];
                [newPostlike saveEventually];
            }];
        }
        
    }];
    
}
    

-(void)unlike
{
    PFQuery *query = [PFQuery queryWithClassName:@"PostLike"];

    [query whereKey:@"From" equalTo:self.From];
    [query whereKey:@"PostID" equalTo:PostID];

    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error)
        {
            [object setObject:@NO forKey:@"isLiked"];
            [object saveEventually];
        }
        else
        {
            PFObject *newPostlike = [PFObject objectWithClassName:@"PostLike"];
            
            [newPostlike setObject:To forKey:@"To"];
            [newPostlike setObject:From forKey:@"From"];
            [newPostlike setObject:@NO forKey:@"isLiked"];
            [newPostlike setObject:PostID forKey:@"PostID"];
            [newPostlike setObject:self.ItemRID forKey:@"ItemID"];
            
            NSData *pictureData = UIImagePNGRepresentation(FromuserProfilePic);
            PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [newPostlike setObject:file forKey:@"FromuserProfilePic"];
                [newPostlike saveEventually];
            }];
        }
        
    }];
}
@end
