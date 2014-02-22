//
//  ViewController.h
//  LoginTest
//
//  Created by KHALID ALAHMARI on 1/28/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"


@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *UsernameTextbox;

@property (weak, nonatomic) IBOutlet UITextField *PasswordTextbox;


- (IBAction)isLoginPressed:(UIButton *)sender;

@property (nonatomic,strong) User *user;



@end
