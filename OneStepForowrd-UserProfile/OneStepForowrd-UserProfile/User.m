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


//-(BOOL) userLoging
//{
//    
//    PFUser *d=[[PFUser alloc]init];
//     NSError *error = nil;
//    
//    d=[PFUser logInWithUsername:userUsername password:userPassword error:&error];
//    
//    if (!error) {
//        isUserloggedin=YES;
//
//    }
//    
//    else
//    {
//        NSString *errorString = [[error userInfo] objectForKey:@"error"];
//        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [errorAlertView show];
//    }
//
//
//    return isUserloggedin;
//}




//-(BOOL) UserRegister
//{
//    
//    PFUser *newUser= [PFUser user];
//    [newUser setObject:userFirsname forKey:@"FirstName"];
//    [newUser setObject:userLastname forKey:@"LastName"];
//    
//    newUser.username=userUsername;
//    newUser.password=userPassword;
//    
//    newUser.email=userEmailAddres;
//    
//    NSData *pictureData = UIImagePNGRepresentation(userProfileImage);
//    
//    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
//    
//    [newUser setObject:file forKey:@"ProfileImage"];
//    
//    NSError *error = nil;
//
//    
//    [newUser signUp:&error];
//    
//    //[newUser signUpInBackgroundWithBlock:^ (BOOL succeeded, NSError *error)
//    
//     
//    {
//         if (!error)
//         {
//             isUserloggedin=YES;
//         }
//        
//         else
//         {
//             NSString *errorString = [[error userInfo] objectForKey:@"error"];
//             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//             [errorAlertView show];
//         }
//    }
//    return isUserloggedin;
//}



//create table users(userId integer primary key,
//                   userFirstname text,
//                   userLastname text,
//                   userUsername text,
//                   userPassword text,
//                   userEmailAddress text,
//                   userProfileImage blob);


-(BOOL)UserRegistration
{
    
//    
    SQLiteDB *Database= [SQLiteDB  databaseWithPath:@"Database.sqlite"];
    sqlite3* DBconnection=[Database getConnection];
    sqlite3_stmt *statement=nil;
    
    NSString *insertSQL = @"INSERT INTO users (userId,userFirstname,userLastname,userUsername,userPassword,userEmailAddress) VALUES (?,?,?,?,?,?)";
    
    NSLog(@"%@",insertSQL);
    
    if (sqlite3_prepare_v2(DBconnection, [insertSQL UTF8String],[insertSQL length], &statement, nil) != SQLITE_OK)
    {
        NSLog(@"The SQL STAM isn't preapred");
    }
    
    sqlite3_bind_int(statement, 1, 556);
    sqlite3_bind_text(statement, 2, [self.userFirsname UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [self.userLastname UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [self.userUsername UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [self.userPassword UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [self.userEmailAddres UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(statement))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(DBconnection));
    else
        NSLog(@"Inserted");

    
    sqlite3_finalize(statement);
    sqlite3_close(DBconnection);

    return YES;

}
@end