//
//  SingupViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/20/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "User.h"
#import "MainMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SingupViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

- (IBAction)isBackPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UITextField *firstnameTextbox;

@property (weak, nonatomic) IBOutlet UITextField *lastnameTextbox;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextbox;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextbox;

@property (weak, nonatomic) IBOutlet UITextField *emailTextbox;

@property (strong, nonatomic) UIImagePickerController * imagePicker;

@property (weak, nonatomic) IBOutlet UIImageView *ProfileImg;

@property (nonatomic,weak) UIActionSheet *actionSheet;

@property (weak, nonatomic) IBOutlet UISwitch *shareSwitch;

@property (nonatomic,strong) User *user;

- (IBAction)selectImage:(UIButton *)sender;


- (IBAction)isDoneisPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

-(IBAction)editingChanged;

@end
