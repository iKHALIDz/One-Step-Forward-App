//
//  SignoutViewController.m
//  LoginTest
//
//  Created by KHALID ALAHMARI on 1/28/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "SignupViewController.h"


#define PHOTO_LIBRART_BUTTON_TITLE @"Photo Library"
#define PHOTO_ALBUM_BUTTON_TITLE @"Camera Roll"
#define CAMERA_BUTTON_TITLE @"Camera"
#define CANCEL_BUTTON_TITLE @"Cancel"

@interface SignupViewController ()


@end


@implementation SignupViewController

@synthesize imagePicker,ProfileImg;

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
    [self.FirsnameTextbox becomeFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)IsSignUpPressed:(UIBarButtonItem *)sender {
    
    
    NSLog(@"SignUp is Pressed");
    // Create new Object PFUser;
    PFUser *newUser= [PFUser user];
    [newUser setObject:self.FirsnameTextbox.text forKey:@"FirstName"];
    [newUser setObject:self.LastnameTextbox.text forKey:@"LastName"];
    
    newUser.username=self.UsernameTextbox.text;
    newUser.password=self.PasswordTextbox.text;
    newUser.email=self.EmailTextbox.text;
    
    
    
    NSData *pictureData = UIImagePNGRepresentation(self.ProfileImg.image);
    
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];

    [newUser setObject:file forKey:@"ProfileImage"];

    
    [newUser signUpInBackgroundWithBlock:^ (BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             [self performSegueWithIdentifier:@"SignUPDone" sender:self];
         }
         else
         {
             NSString *errorString = [[error userInfo] objectForKey:@"error"];
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
             
         }
     }];

}


#pragma mark Keyboard dissmiss
- (void)touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    
    if (! [self isFirstResponder])
    {
        {
            if ([self.UsernameTextbox isFirstResponder]) {
                [self.UsernameTextbox resignFirstResponder];
            }
            if ([self.PasswordTextbox isFirstResponder]) {
                [self.PasswordTextbox resignFirstResponder];

            }
            
            if ([self.EmailTextbox isFirstResponder]) {
                [self.EmailTextbox resignFirstResponder];
            }

            
        }
    }
    
}



- (IBAction)PickPictureisPressed:(UIButton *)sender {
    
    self.imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    
    if(!self.actionSheet){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Source of Image"
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



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == self.actionSheet.destructiveButtonIndex){
        NSLog(@"destuctivebutton clicked");
    }else if(buttonIndex == self.actionSheet.cancelButtonIndex){
        NSLog(@"cancel clicked");
    }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.allowsEditing = YES;
        picker.delegate = self;
        picker.mediaTypes = @[(NSString *) kUTTypeImage]; // choose both video and image
        NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
        if([choice isEqualToString:PHOTO_LIBRART_BUTTON_TITLE]){
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else if([choice isEqualToString:CAMERA_BUTTON_TITLE]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [self presentViewController:picker animated:YES completion:^{
            NSLog(@"complete picked image");
        }];
        
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    self.ProfileImg.image=[info objectForKey:UIImagePickerControllerEditedImage];
    self.ProfileImg.layer.cornerRadius=45;
    self.ProfileImg.layer.masksToBounds=YES;
    self.ProfileImg.layer.borderWidth=1.0f;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
