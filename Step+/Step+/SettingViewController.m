//
//  SettingViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/30/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)isSignoutPressed:(UIButton *)sender {
    
    [PFUser logOut];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"main" bundle: nil];
    LoginViewController*wViewController = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self presentViewController:wViewController animated:YES completion:nil];

}
@end
