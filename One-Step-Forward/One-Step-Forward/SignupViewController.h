//
//  SignoutViewController.h
//  LoginTest
//
//  Created by KHALID ALAHMARI on 1/28/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "User.h"


@interface SignupViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *FirsnameTextbox;
@property (weak, nonatomic) IBOutlet UITextField *LastnameTextbox;

@property (weak, nonatomic) IBOutlet UITextField *UsernameTextbox;

@property (weak, nonatomic) IBOutlet UITextField *PasswordTextbox;

@property (weak, nonatomic) IBOutlet UITextField *EmailTextbox;

@property (weak, nonatomic) IBOutlet UIImageView *ProfileImg;

- (IBAction)PickPictureisPressed:(UIButton *)sender;

@property (strong, nonatomic) UIImagePickerController * imagePicker;

@property (nonatomic,weak) UIActionSheet *actionSheet;

@property (nonatomic,strong) User *user;



@end
