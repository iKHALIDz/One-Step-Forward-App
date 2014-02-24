//
//  User.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/19/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "User.h"

@implementation User



@synthesize userFirsname;
@synthesize userLastname;
@synthesize userUsername;
@synthesize userEmailAddres;
@synthesize userPassword;
@synthesize userProfileImage;
@synthesize isUserloggedin;


-(BOOL) userLoging
{
    
    PFUser *d=[[PFUser alloc]init];
     NSError *error = nil;
    
    d=[PFUser logInWithUsername:userUsername password:userPassword error:&error];
    
    if (!error) {
        isUserloggedin=YES;

    }
    
    else
    {
        NSString *errorString = [[error userInfo] objectForKey:@"error"];
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }


    return isUserloggedin;
}




-(BOOL) UserRegister
{
    
    PFUser *newUser= [PFUser user];
    [newUser setObject:userFirsname forKey:@"FirstName"];
    [newUser setObject:userLastname forKey:@"LastName"];
    
    newUser.username=userUsername;
    newUser.password=userPassword;
    
    newUser.email=userEmailAddres;
    
    NSData *pictureData = UIImagePNGRepresentation(userProfileImage);
    
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    
    [newUser setObject:file forKey:@"ProfileImage"];
    
    NSError *error = nil;

    
    [newUser signUp:&error];
    
    //[newUser signUpInBackgroundWithBlock:^ (BOOL succeeded, NSError *error)
    
     
    {
         if (!error)
         {
             isUserloggedin=YES;
         }
        
         else
         {
             NSString *errorString = [[error userInfo] objectForKey:@"error"];
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
         }
    }
    return isUserloggedin;
}


@end
