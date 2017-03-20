//
//  EventsTableViewController.m
//  Urbo_iOS
//
//  Created by Андрей on 03.02.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "EventsTableViewController.h"
#import "CellModalView.h"

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rowEvents count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    CellModalView *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CellModalView" bundle:nil] forCellReuseIdentifier:identifier];
        //cell = [[CellModalView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    
    cell.strTitle.text = [[_rowEvents objectAtIndex:indexPath.row] objectForKey:@"title"];     
    
    cell.strDetail.text = [[_rowEvents objectAtIndex:indexPath.row] objectForKey:@"message"];
    
    
    return cell;
}



@end
