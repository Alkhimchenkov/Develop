//
//  SidebarViewController.m
//  Urbo_iOS
//
//  Created by Андрей on 13.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"

@interface SidebarViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _menuItems = [NSArray arrayWithObjects:@"info",@"map", @"search", @"checkin", @"profile", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return _menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [_menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 150;
    }
    else {
        return 44;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SWRevealViewController *revealController = self.revealViewController;
    
    NSInteger row = indexPath.row;
    
    if (_rowSelected == 0) _rowSelected++;
    
    if (row == _rowSelected) {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }

    if (row == 1){
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController =  (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"MainNavigator"]; //initWithRootViewController:viewNew];

        [revealController pushFrontViewController:navigationController animated:YES];
    }
    
    if (row == 0) row = _rowSelected;
    
    _rowSelected = row;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[self.menuItems objectAtIndex:indexPath.row] capitalizedString];
    
//    if ([segue.identifier isEqualToString:@"showPhoto"]){
//        
//       // UINavigationController *navController = segue.destinationViewController;
//     //   ProfileViewController *profileController = [navController childViewControllers].firstObject;
//        //NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [self.menuItems objectAtIndex:indexPath.row]];
//        //photoController.photoFilename = photoFilename;
//    }
    
    
}

@end
