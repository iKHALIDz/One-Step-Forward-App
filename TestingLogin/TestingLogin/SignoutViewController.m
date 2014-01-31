//
//  SignoutViewController.m
//  LoginTest
//
//  Created by KHALID ALAHMARI on 1/28/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "SignoutViewController.h"

@interface SignoutViewController ()


@end


@implementation SignoutViewController

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
	// Do any additional setup after loading the view.
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
    
    imagePicker.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.ProfileImg.image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
