//
//  User.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/21/14.
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
@synthesize numberOfAchievedGoals;
@synthesize numberOfInProgressGoals;
@synthesize isUserloggedin;


-(BOOL) loginToAccountUsingParse
{
    
    PFUser *existingUser=[[PFUser alloc]init];
    NSError *error = nil;
    existingUser=[PFUser logInWithUsername:userUsername password:userPassword error:&error];
    
    if (!error)
    {
        isUserloggedin=YES;
        userID=[existingUser objectForKey:@"UserID"];
        userFirsname=[existingUser objectForKey:@"FirstName"];
        userLastname=[existingUser objectForKey:@"LastName"];
        userUsername=[existingUser objectForKey:@"username"];
        userPassword=[existingUser objectForKey:@"password"];
        userProfileImage=[existingUser objectForKey:@"ProfileImage"];
        userEmailAddres=[existingUser objectForKey:@"email"];
        numberOfAchievedGoals=[[existingUser objectForKey:@"numberOfAchievedGoals"] integerValue];
        numberOfInProgressGoals=[[existingUser objectForKey:@"numberOfInProgressGoals"] integerValue];
    }
    
    else
    {
        NSString *errorString = [[error userInfo] objectForKey:@"error"];
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }
    
    return isUserloggedin;
}


-(BOOL) createAnAccountUsingParse
{
    [self nextIdentifies];
    PFUser *newUser= [PFUser user];
    [newUser setObject:userID forKey:@"UserID"];
    [newUser setObject:userFirsname forKey:@"FirstName"];
    [newUser setObject:userLastname forKey:@"LastName"];
    [newUser setObject:[NSString stringWithFormat:@"%d",numberOfInProgressGoals] forKey:@"numberOfInProgressGoals"];
    [newUser setObject:[NSString stringWithFormat:@"%d",numberOfAchievedGoals] forKey:@"numberOfAchievedGoals"];
    
    newUser.username=userUsername;
    newUser.password=userPassword;
    newUser.email=userEmailAddres;
    
    NSData *pictureData = UIImagePNGRepresentation(userProfileImage);
    
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    
    [newUser setObject:file forKey:@"ProfileImage"];
    
    NSError *error = nil;
    
    [newUser signUp:&error];
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

-(void)nextIdentifies
{
    static NSString* lastID = @"lastID";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger identifier = [defaults integerForKey:lastID] + 1;
    [defaults setInteger:identifier forKey:lastID];
    [defaults synchronize];
    self.userID=[NSString stringWithFormat:@"%ld",(long)identifier];
}


-(void)UserRegistrationUsingDatabase
{
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail");
        
    }
    
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Users (userId,userFirstname,userLastname,userUsername,userPassword,userEmailAddress,numberOfInProgressGoals,numberOfAchievedGoals) VALUES (%ld,'%@','%@','%@','%@','%@','%d','%d')",(long)[userID integerValue],userFirsname,userLastname,userUsername,userPassword,userEmailAddres,numberOfInProgressGoals,numberOfAchievedGoals];
    
    NSLog(@"%@",insertSQL);
    
    BOOL succ=[db executeUpdate:insertSQL];
    
    if (succ==YES)
    {
        NSLog(@"Succseed");
    }
    
    else
    {
        NSLog(@"Fail");
    }
    
    [db close];
}



- (void) getUserInfo: (NSString*) username
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    FMDatabase *db=[FMDatabase databaseWithPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail");
        
    }
    
    NSString *getSQL = [NSString stringWithFormat:@"select * from Users where userUsername='%@';",username];
    
    NSLog(@"%@",getSQL);
    
    User *user;
    
    FMResultSet *result =[db executeQuery:getSQL];
    
    while ([result next])
    {
        user=[[User alloc]init];
        user.userUsername=[result stringForColumn:@"userUsername"];
        
    }

}

-(NSString*)DataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}



@end