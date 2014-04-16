//
//  SettingViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/30/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "User.h"

@interface SettingViewController : UIViewController

- (IBAction)isSignoutPressed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UISwitch *shareSwitch;

@property (nonatomic,retain) User *currentUser;

- (IBAction)changeOption:(UISwitch *)sender;

@end
