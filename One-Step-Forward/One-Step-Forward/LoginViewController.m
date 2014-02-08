//
//  ViewController.m
//  LoginTest
//
//  Created by KHALID ALAHMARI on 1/28/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*
     [self.self.navigationController.navigationBar setBackgroundImage:[UIImage new]
     forBarMetrics:UIBarMetricsDefault];
     self.self.navigationController.navigationBar.shadowImage = [UIImage new];
     self.self.navigationController.navigationBar.translucent = YES;
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)isLoginPressed:(UIButton *)sender {
    
    NSLog(@"Login is Pressed");
    [PFUser logInWithUsernameInBackground:self.UsernameTextbox.text password:self.PasswordTextbox.text block:^ (PFUser *user,NSError *error)
        {
        
        if (user) {
            [self performSegueWithIdentifier:@"LoginSuccessfuly" sender:self];
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
            
        }
    }
}
@end
