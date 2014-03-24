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
    
    NSLog(@"User: %@",[user userID]);
    
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


#pragma mark Pass UserId to the main menu ViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LoginSuccessfuly"])
    {
        UINavigationController *nav = [segue destinationViewController];
        MainMenuViewController *vc =(MainMenuViewController*)nav.topViewController;
        
        [vc setCurrentUserID:user.userID];
        
    }
}
@end




