//
//  SettingViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/30/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "SettingViewController.h"

#define PHOTO_LIBRART_BUTTON_TITLE @"Choose Existing"
#define PHOTO_ALBUM_BUTTON_TITLE @"Choose Existing"
#define CAMERA_BUTTON_TITLE @"Take a photo"
#define CANCEL_BUTTON_TITLE @"Cancel"


@interface SettingViewController ()
{
    
    NSInteger tag;
    
}

@end

@implementation SettingViewController
@synthesize imagePicker;
@synthesize currentUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (currentUser.wantsToShare==YES)
    {
        self.shareSwitch.on=YES;
    
    }
    else
    {
        self.shareSwitch.on=NO;
        
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (tag==0) // Background View
    {
        currentUser.userBackgroundImage=[info objectForKey:UIImagePickerControllerEditedImage];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [currentUser UpdateBackgroundPic];
        [[self delegate]updateUser:currentUser];

    }
    
    if (tag==1) // Profile View
    {
     //   NSLog(@"UserProfile");
        currentUser.userProfileImage=[info objectForKey:UIImagePickerControllerEditedImage];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [currentUser UpdateProfilePic];
        [[self delegate]updateUser:currentUser];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.mediaTypes = @[(NSString *) kUTTypeImage]; // choose both video and image
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([choice isEqualToString:PHOTO_LIBRART_BUTTON_TITLE]){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if([choice isEqualToString:CAMERA_BUTTON_TITLE]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:picker animated:YES completion:^{
    }];
}




- (IBAction)isSignoutPressed:(UIButton *)sender {
    
    [PFUser logOut];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"main" bundle: nil];
    LoginViewController*wViewController = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self presentViewController:wViewController animated:YES completion:nil];

}


- (IBAction)isDonePressed:(UIBarButtonItem *)sender{
    
    [currentUser UpdateUserDataDB];
    [currentUser UpdateUserParse];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)changeOption:(UISwitch *)sender {
    
    if (self.shareSwitch.on)
    {
        currentUser.wantsToShare=YES;
    
    }
    else
    {
        currentUser.wantsToShare=NO;
        
    }
}

-(IBAction)selectBackgroundImage:(UIButton *)sender
{
    tag=0;
    
    self.imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    
    if(!self.actionSheet){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@""
                                                                delegate:self cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            [actionSheet addButtonWithTitle:PHOTO_LIBRART_BUTTON_TITLE];
        }
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [actionSheet addButtonWithTitle:CAMERA_BUTTON_TITLE];
        }
        
        [actionSheet addButtonWithTitle:CANCEL_BUTTON_TITLE];
        [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
        [actionSheet showInView:sender];
        
        self.actionSheet = actionSheet;
    }
    
}

-(IBAction)selectProfileImage:(UIButton *)sender
{
    tag=1;
    
    self.imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    
    if(!self.actionSheet){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@""
                                                                delegate:self cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            [actionSheet addButtonWithTitle:PHOTO_LIBRART_BUTTON_TITLE];
        }
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [actionSheet addButtonWithTitle:CAMERA_BUTTON_TITLE];
        }
        
        [actionSheet addButtonWithTitle:CANCEL_BUTTON_TITLE];
        [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
        [actionSheet showInView:sender];
        
        self.actionSheet = actionSheet;
    }
}

@end
