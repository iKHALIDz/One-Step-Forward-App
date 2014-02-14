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


@synthesize goalsdescription,goalsName,goalDeadline;

@synthesize tableView;

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
    
    goalsName=[[NSMutableArray alloc]initWithObjects:@"Ahmed",@"Ali",nil];
    goalsdescription=[[NSMutableArray alloc]initWithObjects:@"Ahmed Description",@"Ali Description",nil];
    goalDeadline = [[NSMutableArray alloc]initWithObjects:@"22/5/2013",@"22/5/2014",nil];
    


}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [goalsName count];
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    goalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    cell.goalDescription.text=[goalsdescription objectAtIndex:indexPath.row];
    //cell.goalDeadline.text = [goalDeadline objectAtIndex:indexPath.row];
    cell.goalName.text=[goalsName objectAtIndex:indexPath.row];
    
    return cell;
}



@end
