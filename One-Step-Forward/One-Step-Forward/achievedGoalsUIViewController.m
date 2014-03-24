//
//  achievedGoalsUIViewController.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/19/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "achievedGoalsUIViewController.h"

@interface achievedGoalsUIViewController ()

@end

@implementation achievedGoalsUIViewController

@synthesize tableView = _tableView;
@synthesize achievedGoalsArray;
@synthesize radialView;
@synthesize currentGoal;

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
    currentGoal=[[Goal alloc]init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
	MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
	// Only required in this demo to align vertically the progress views.
	view.center = CGPointMake(30,30);
    
	return view;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return achievedGoalsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    goalTableViewCell *cell = (goalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"goalTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    [cell.goalName setText:(NSString *)[[achievedGoalsArray objectAtIndex:indexPath.row] goalName]];
    CGRect frame = CGRectMake(50,50, 50, 50);
    radialView = [self progressViewWithFrame:frame];
    radialView.progressTotal = 100;
    radialView.progressCounter = [[achievedGoalsArray objectAtIndex:indexPath.row] goalProgress];
    radialView.startingSlice = 3;
    radialView.theme.sliceDividerThickness = 1;
    radialView.theme.sliceDividerHidden = NO;
    radialView.label.textColor = [UIColor blueColor];
    radialView.label.shadowColor = [UIColor clearColor];
    [cell.progressPercentageView addSubview:radialView];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    currentGoal.goalID=[[NSString stringWithFormat:@"%d",[[achievedGoalsArray objectAtIndex:indexPath.row] goalID]] integerValue];
    currentGoal.goalName=[NSString stringWithFormat:@"%@",[[achievedGoalsArray objectAtIndex:indexPath.row] goalName]];
    currentGoal.goalDescription=[NSString stringWithFormat:@"%@",[[achievedGoalsArray objectAtIndex:indexPath.row] goalDescription]];
    currentGoal.goalDeadline=[NSString stringWithFormat:@"%@",[[achievedGoalsArray objectAtIndex:indexPath.row] goalDeadline]];
    currentGoal.goalProgress=[[achievedGoalsArray objectAtIndex:indexPath.row] goalProgress];
    currentGoal.createdBy=[NSString stringWithFormat:@"%@",[[achievedGoalsArray objectAtIndex:indexPath.row] createdBy]];
    currentGoal.goalDate=[NSString stringWithFormat:@"%@",[[achievedGoalsArray objectAtIndex:indexPath.row] goalDate]];
    currentGoal.goalSteps=[[achievedGoalsArray objectAtIndex:indexPath.row] goalSteps];
    
    [self performSegueWithIdentifier:@"achievedGoalsToDetails" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"achievedGoalsToDetails"])
    {
        detailsViewController *nav = [segue destinationViewController];
        
        [nav setCurrentGoal:currentGoal];
    }
}


@end
