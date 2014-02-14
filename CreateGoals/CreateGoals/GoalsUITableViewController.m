//
//  GoalsUITableViewController.m
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "GoalsUITableViewController.h"

@interface GoalsUITableViewController ()

@end

@implementation GoalsUITableViewController


@synthesize goalsdescription,goalsName,goalDeadline;
@synthesize newg_goaldeadline;
@synthesize newg_goalsdescription;
@synthesize newg_goalname;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    goalsName=[[NSMutableArray alloc]initWithObjects:@"Ahmed",@"Ali",nil];
    goalsdescription=[[NSMutableArray alloc]initWithObjects:@"Ahmed Description",@"Ali Description",nil];
    goalDeadline = [[NSMutableArray alloc]initWithObjects:@"22/5/2013",@"22/5/2014",nil];
    
    if(newg_goaldeadline !=nil)
    {
        [goalDeadline addObject:newg_goaldeadline];
        NSLog(@"%@",newg_goaldeadline);
    }
    
    if (newg_goalname!=nil)
    {
        [goalsName addObject:goalsName];
        NSLog(@"%@",newg_goalname);
    }
    
    if (newg_goalsdescription!=nil)
    {
        [goalsdescription addObject:newg_goalsdescription];
        NSLog(@"%@",newg_goalsdescription);
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    goalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
    
    cell.goalDescription.text=[goalsdescription objectAtIndex:indexPath.row];
    cell.goalDeadline.text = [goalDeadline objectAtIndex:indexPath.row];
    cell.goalName.text=[goalsName objectAtIndex:indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
