//
//  ViewController.m
//  AppUsingParseCloud
//
//  Created by KHALID ALAHMARI on 1/22/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.UsernameText.delegate=nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)save:(id)sender {
    
    PFObject *query = [PFObject objectWithClassName:@"Users"];
    
    [query setObject:self.UsernameText.text forKey:@"Username"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    
    [query saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
    if (!error)
    {
           // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the Users" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
          //  [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
           [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    }];
    
    [hud hide:YES];

    
    };

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
