//
//  User.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/19/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "User.h"

@implementation User


@synthesize userID;
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
    
        userID=[d objectForKey:@"UserID"];
    }

    else
    {
        NSString *errorString = [[error userInfo] objectForKey:@"error"];
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }

    return isUserloggedin;
}


-(NSString*)DataFilePath{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",[paths objectAtIndex:0]);
    
    return [paths objectAtIndex:0];
}

-(void)UserRegistrationUsingDB
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail");
        
    }
    
    
    NSString *createSQL= @"create table IF NOT exists Users(userId integer primary key,userFirstname text, userLastname text, userUsername text, userPassword text, userEmailAddress text, userProfileImage blob);";
        [db executeUpdate:createSQL];
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Users (userId,userFirstname,userLastname,userUsername,userPassword,userEmailAddress) VALUES (%ld,'%@','%@','%@','%@','%@')",(long)[userID integerValue],userFirsname,userLastname,userUsername,userPassword,userEmailAddres];
    
    NSLog(@"%@",insertSQL);
    
    BOOL succ=[db executeUpdate:insertSQL];
    
    if (succ==YES) {
        NSLog(@"Succseed");
    }
    
    else
    {
        NSLog(@"Fail");
    }
    
    [db close];
}


-(BOOL) UserRegister
{
    [self nextIdentifies];
    
    PFUser *newUser= [PFUser user];
    [newUser setObject:userID forKey:@"UserID"];
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
             [self UserRegistrationUsingDB];
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


#pragma mark Create a random unrepeatable number

-(void)nextIdentifies
{
    static NSString* lastID = @"lastID";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger identifier = [defaults integerForKey:lastID] + 1;
    [defaults setInteger:identifier forKey:lastID];
    [defaults synchronize];
    self.userID=[NSString stringWithFormat:@"%ld",(long)identifier];
}

@end
