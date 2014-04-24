//
//  SettingViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/30/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//
#import "User.h"

@protocol updateUserinfo <NSObject>

-(void)updateUser:(User *) updatedUser;

@end

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>



@interface SettingViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>


- (IBAction)isSignoutPressed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UISwitch *shareSwitch;

@property (nonatomic,retain) User *currentUser;

- (IBAction)changeOption:(UISwitch *)sender;

@property (strong, nonatomic) UIImagePickerController * imagePicker;
@property (nonatomic,weak) UIActionSheet *actionSheet;

-(IBAction)selectBackgroundImage:(UIButton *)sender;

-(IBAction)selectProfileImage:(UIButton *)sender;

@property (retain) id <updateUserinfo> delegate;


@end

