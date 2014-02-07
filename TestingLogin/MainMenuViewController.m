//
//  MainMenuViewController.m
//  TestingLogin
//
//  Created by KHALID ALAHMARI on 1/29/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

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

- (IBAction)isSignOutPressed:(UIButton *)sender {
    
    [PFUser logOut];
    
    //[self performSegueWithIdentifier:@"LogoutSuccessfuly" sender:self];
}

@end
