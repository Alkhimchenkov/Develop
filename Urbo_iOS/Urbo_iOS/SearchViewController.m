//
//  SearchViewController.m
//  Urbo_iOS
//
//  Created by Андрей on 14.02.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "SearchViewController.h"
#import "SWRevealViewController.h"
#import "UserIsSigned.h"

@interface SearchViewController () <UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableViewController *resultController;
@property (nonatomic, strong) NSArray *arraySearchResult;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if (revealViewController){
        
        [self.sideBarButtonProfile setTarget:self.revealViewController];
        [self.sideBarButtonProfile setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
//    UITableViewController *resultController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
  
    self.resultController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultController];
    
    [self.searchController.searchBar sizeToFit];
    
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.navigationItem.titleView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    self.searchController.searchResultsUpdater = self;

    self.resultController.tableView.dataSource = self;
    
    self.resultController.tableView.delegate = self;
    
    
//    self.searchController.dimsBackgroundDuringPresentation = NO;

//    [self.parentViewController presentViewController:self.searchController animated:YES completion:nil];

    //    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //    [self.searchController.searchBar sizeToFit];
    //    self.searchController.hidesNavigationBarDuringPresentation = NO;
    //    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    //    self.searchController.searchResultsUpdater = self;
    //    self.navigationItem.titleView = self.searchController.searchBar;
    //    self.definesPresentationContext = YES;
    
    
}


#pragma mark - delegate methods UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arraySearchResult.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifer = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.colorArray[indexPath.row]];
//    return cell;
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}



#pragma mark - delegate method UISerachController
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{

    if (![self.searchController.searchBar.text isEqualToString:@""]){
        UserIsSigned *userIsSing = [[UserIsSigned alloc] init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [userIsSing requestFromServer:[UserIsSigned getUrlUserSearch:self.searchController.searchBar.text
                                                                     uid:[[FIRAuth auth].currentUser uid]]];
            NSLog(@"%@", self.searchController.searchBar.text);
            NSLog(@"%@", userIsSing.dataRequest);
        });
    }
}


@end
