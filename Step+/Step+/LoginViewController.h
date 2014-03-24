//
//  LoginViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/20/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "MainMenuViewController.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (nonatomic,strong) User *user;

@property (weak, nonatomic) IBOutlet UITextField* usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField* passwordTextField;

- (IBAction)isLoginisPressed:(UIButton *)sender;



@end
