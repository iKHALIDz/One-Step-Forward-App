//
//  WelecomViewController.h
//  LoginT
//
//  Created by KHALID ALAHMARI on 2/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelecomViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
- (IBAction)isSigninIsPressed:(UIButton *)sender;
- (IBAction)isSignUpIsPressed:(UIButton *)sender;
@end
