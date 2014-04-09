//
//  UserProfileViewControllerDetailsViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/8/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "UserProfileViewControllerDetailsViewController.h"

@interface UserProfileViewControllerDetailsViewController ()

@end

@implementation UserProfileViewControllerDetailsViewController

@synthesize cgoal;
@synthesize gPosts;
@synthesize currentUser;

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
    
    NSLog(@"T: %d",cgoal.goalID);
    NSLog(@"%d",[gPosts count]);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"timelineCell";
    
    timelineCell *cell = (timelineCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"timelineCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.name.text=[NSString stringWithFormat:@"%@ %@",[[gPosts objectAtIndex:indexPath.row] userFirstName],[[gPosts objectAtIndex:indexPath.row] userLastName]];
    cell.postContent.text=[NSString stringWithFormat:@"%@",[[gPosts objectAtIndex:indexPath.row] PostContent]];
    cell.timedate.text=[NSString stringWithFormat:@"%@",[[gPosts objectAtIndex:indexPath.row] PostDate]];
    
    cell.userpic.image=[[gPosts objectAtIndex:indexPath.row] userProfilePic];
    
    return cell;
}


- (IBAction)send:(UIButton *)sender {
    
    NSLog(@"Goal%@",cgoal.createdBy);
    NSLog(@"Goal%@",currentUser.userUsername);
    NSLog(@"Goal%d",cgoal.goalID);
    
    
    PFObject *newGoalSuggestion= [PFObject objectWithClassName:@"GoalSuggestion"];
    
    [newGoalSuggestion setObject: cgoal.createdBy forKey:@"To"];
    
    [newGoalSuggestion setObject: currentUser.userUsername  forKey:@"From"];
    
    [newGoalSuggestion setObject: [NSString stringWithFormat:@"%d",cgoal.goalID ] forKey:@"GoalID"];
    
    [newGoalSuggestion setObject: self.suggestionTextField.text forKey:@"SuggestionText"];

    
    NSData *pictureData = UIImagePNGRepresentation(currentUser.userProfileImage);
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [newGoalSuggestion setObject:file forKey:@"FromuserProfilePic"];
        [newGoalSuggestion saveEventually];
    }];
}

@end
