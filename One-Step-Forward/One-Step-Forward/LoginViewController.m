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


@synthesize user;


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
    
    user=[[User alloc]init];
    NSLog(@"Im at LoginViewController ViewDidLoad");
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Login

- (IBAction)isLoginPressed:(UIButton *)sender {
    
    [user setUserUsername:self.UsernameTextbox.text];
    [user setUserPassword:self.PasswordTextbox.text];
    
    BOOL x=[user userLoging];
    
    if(x==YES)
    {
        [self performSegueWithIdentifier:@"LoginSuccessfuly" sender:self];
    }
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


/*
 // First set up a callback.
 - (void)handleUserLogin:(PFUser *)user error:(NSError *)error {
 if (user) {
 // Do stuff after successful login.
 } else {
 // The login failed. Check error to see why.
 }
 }
 
 // Then, elsewhere in your code...
 [PFUser logInWithUsernameInBackground:@"myname"
 password:@"mypass"
 target:self
 selector:@selector(handleUserLogin:error:)];
 */


