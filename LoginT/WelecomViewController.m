//
//  WelecomViewController.m
//  LoginT
//
//  Created by KHALID ALAHMARI on 2/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "WelecomViewController.h"
#import "AppDelegate.h"


@interface WelecomViewController ()

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation WelecomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(NSManagedObjectContext *) managedObjectContext {
    
    
    return [(AppDelegate*)[UIApplication sharedApplication]managedObjectContext];
    
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

- (IBAction)isSigninIsPressed:(UIButton *)sender {
}

- (IBAction)isSignUpIsPressed:(UIButton *)sender {
    
    NSError *error=nil;
    if([self.managedObjectContext hasChanges])
    {
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Save Failed %@", [error localizedDescription]);
            
        }
        else
        {
            NSLog(@"Save Succeeded");
        }
    }
}



@end
