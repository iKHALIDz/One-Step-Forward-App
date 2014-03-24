//
//  SingupViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/20/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "SingupViewController.h"

#define PHOTO_LIBRART_BUTTON_TITLE @"Choose Existing"
#define PHOTO_ALBUM_BUTTON_TITLE @"Choose Existing"
#define CAMERA_BUTTON_TITLE @"Take a photo"
#define CANCEL_BUTTON_TITLE @"Cancel"

@interface SingupViewController ()

@end

@implementation SingupViewController



@synthesize imagePicker,ProfileImg;
@synthesize user;


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
    
    [self.firstnameTextbox becomeFirstResponder];
    user=[[User alloc]init];
    self.doneButton.enabled=NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)isBackPressed:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.firstnameTextbox]) {
        [self.lastnameTextbox becomeFirstResponder];
        
    } else if ([textField isEqual:self.lastnameTextbox]) {
        [self.usernameTextbox becomeFirstResponder];
        
    } else if ([textField isEqual:self.usernameTextbox]) {
        [self.passwordTextbox becomeFirstResponder];
        
    } else if ([textField isEqual:self.passwordTextbox]) {
        [self.emailTextbox becomeFirstResponder];
    }
    else
        [self.firstnameTextbox becomeFirstResponder];

    return YES;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.ProfileImg.image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    self.ProfileImg.layer.cornerRadius = 5.0;
    self.ProfileImg.layer.masksToBounds = YES;
    
    self.ProfileImg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.ProfileImg.layer.borderWidth = 1.0;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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


- (IBAction)selectImage:(UIButton *)sender {
    
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

- (IBAction)isDoneisPressed:(UIBarButtonItem *)sender {
    
    [user setUserUsername:self.usernameTextbox.text];
    [user setUserPassword:self.passwordTextbox.text];
    [user setUserFirsname:self.firstnameTextbox.text];
    [user setUserLastname:self.lastnameTextbox.text];
    [user setUserEmailAddres:self.emailTextbox.text];
    [user setUserProfileImage:self.ProfileImg.image];
    [user setNumberOfAchievedGoals:0];
    [user setNumberOfInProgressGoals:0];
    
    BOOL x=[user createAnAccountUsingParse];
    if (x==YES)
    {
        [user UserRegistrationUsingDatabase];
        [self performSegueWithIdentifier:@"SignUpSuccessfuly" sender:self];
    }
}


- (IBAction)editingChanged
{
    // make sure all fields are have something in them
    
    if ((self.firstnameTextbox.text.length > 0) &&  (self.lastnameTextbox.text.length > 0) && ( self.usernameTextbox.text.length > 0)&& (self.passwordTextbox.text.length > 0) && (self.emailTextbox.text.length > 0))
    {
        self.doneButton.enabled=YES;
    }
    
    else
    {
        self.doneButton.enabled=NO;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SignUpSuccessfuly"])
    {
        UINavigationController *nav = [segue destinationViewController];
        MainMenuViewController *vc =(MainMenuViewController*)nav.topViewController;
        
        [vc setCurrentUser:user];
    }
}

@end
