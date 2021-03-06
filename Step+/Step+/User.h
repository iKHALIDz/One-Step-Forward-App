//
//  User.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/21/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "FMDatabase.h"
#import "UIImage+ResizeImage.h"

@interface User : NSObject

@property (strong, nonatomic) NSString  *userID;
@property (strong, nonatomic) NSString  *userFirsname;
@property (strong, nonatomic) NSString *userLastname;
@property (strong, nonatomic) NSString  *userUsername;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSString *userEmailAddres;
@property (strong, nonatomic) UIImage *userProfileImage;
@property int numberOfInProgressGoals;
@property int numberOfAchievedGoals;
@property BOOL isUserloggedin;
@property BOOL wantsToShare;
@property (strong, nonatomic) UIImage *userBackgroundImage;

-(BOOL) loginToAccountUsingParse;
-(BOOL) createAnAccountUsingParse;
-(void)UserRegistrationUsingDatabase;
- (User*) getUserInfo: (NSString*) username;

-(void)UpdateUserDataDB;
-(void)UpdateUserParse;
-(void)UpdateProfilePic;
-(void)UpdateBackgroundPic;



@end
