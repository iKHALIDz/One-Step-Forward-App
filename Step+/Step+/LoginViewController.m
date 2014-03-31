//
//  LoginViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/20/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480) ? regular : longScreen)

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize currentUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Login Background, and to support iPhone 5 Background
    self.backgroundImage.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"LoginBackground@2x",@"LoginBackground-568@2x")];
    
    // To make the navigationController.navigationBar translucent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)isLoginisPressed:(UIButton *)sender {
    
    User *user=[[User alloc]init];
    currentUser=[[User alloc]init];
    
    [user setUserUsername:self.usernameTextField.text];
    [user setUserPassword:self.passwordTextField.text];
    
    
    BOOL x=[user loginToAccountUsingParse];
    if (x==YES)
    {
        currentUser=[currentUser getUserInfo:self.usernameTextField.text];
        
        [self performSegueWithIdentifier:@"LoginSuccessfuly" sender:self];
    }
    
}

- (void)touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (! [self isFirstResponder])
    {
        {
            if ([self.usernameTextField isFirstResponder]) {
                [self.usernameTextField resignFirstResponder];
            }
            if ([self.passwordTextField isFirstResponder]) {
                [self.passwordTextField resignFirstResponder];
                
            }
            
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.usernameTextField isFirstResponder]) {
        [self.usernameTextField resignFirstResponder];
    }
    
    if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LoginSuccessfuly"])
    {
        UINavigationController *nav = [segue destinationViewController];
        MainMenuViewController *vc =(MainMenuViewController*)nav.topViewController;
        
        [vc setCurrentUser:currentUser];
    }
}

@end
