//
//  User.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/19/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface User : NSObject

@property (strong, nonatomic) NSString  *userFirsname;
@property (strong, nonatomic) NSString *userLastname;
@property (strong, nonatomic) NSString  *userUsername;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSString *userEmailAddres;
@property (strong, nonatomic) UIImage *userProfileImage;
@property BOOL isUserloggedin;


-(BOOL) userLoging;
-(BOOL) UserRegister;

@end
