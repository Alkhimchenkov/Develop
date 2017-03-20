//
//  MainViewController.m
//  Urbo_iOS
//
//  Created by Андрей on 11.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "MainViewController.h"
//#import "LoginViewController.h"
#import "UserIsSigned.h"
#import "CustomTableViewCell.h"
#import "DataModelTable.h"
#import "Communication.h"
//#import "Constatns.h"
//#import "SWRevealViewController.h"
//#import "PopoverViewController.h"
#import "DataProvider.h"
#import "ModalViewController.h"

@import FirebaseMessaging;

@interface MainViewController () <UISearchBarDelegate, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, FIRMessagingDelegate> {//, CLLocationManagerDelegate>UISearchResultsUpdating,,
    GMSPlacePicker *_placePicker;
    GMSPlacesClient *_placesClient;
    
    NSArray <DataModelTable*> *searchResult;
}

@property (strong, nonatomic) NSMutableArray <DataModelTable *> *arrayRowTable;
@property (strong, nonatomic) DataModelTable *rowTable;
//@property (strong, nonatomic) PopoverViewController *itemPopVC;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) Communication *connectTCP;

//@property (strong, nonatomic) IBOutlet UIButton *placeBtn;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

//- (IBAction)buttonLogout:(id)sender;
//- (IBAction)showPopoverView:(id)sender;
///- (IBAction)addPlaceBtn:(id)sender;

@end


@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    _placesClient = [GMSPlacesClient sharedClient];
   
//    SWRevealViewController *revealViewController = self.revealViewController;
//    
//    if (revealViewController) {
//        [self.sidebarButton setTarget:self.revealViewController];
//        [self.sidebarButton setAction:@selector(revealToggle:)];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }

//    self.arrayRowTable = [NSMutableArray arrayWithArray:[[DataProvider sharedInstance] getData]];
//    
//    if (self.arrayRowTable == nil)
//        self.arrayRowTable = [[NSMutableArray alloc] init];
//    else [self.tableView reloadData];


 //   [self initButtonOverTable];
    
//    [self.tableView setDataSource:self];
//    [self.tableView setDelegate:self];
    
    
//    self.connectTCP = [[Communication alloc] init];
//    self.connectTCP->host = @"67.205.37.116";
//    self.connectTCP->port = 3480;
//    [self.connectTCP setup];
//    

    self.searchBar.delegate = self;
    
    [FIRMessaging messaging].remoteMessageDelegate = self;
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable:) name:@"refreshTable" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callSearchPlace) name:@"callSearchPlace" object:nil];
    

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableDidSelectedPopever:) name:@"click" object:nil];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  //  NSLog(@"viewWillAppear");
    
    self.arrayRowTable = [NSMutableArray arrayWithArray:[[DataProvider sharedInstance] getData]];
    
    if (self.arrayRowTable == nil)
        self.arrayRowTable = [[NSMutableArray alloc] init];
    else [self.tableView reloadData];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  //  NSLog(@"viewDidAppear");
}


-(void)dealloc{
 //   NSLog(@"dealloc");
    
//    if (![GLOBAL_APP_DELEGATE isSigned]) {
//        self.arrayRowTable = nil;
//    } else {
//        [[DataProvider sharedInstance] setData:self.arrayRowTable];
//    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.connectTCP close];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self showLoginViewController];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (![GLOBAL_APP_DELEGATE isSigned]) {
        self.arrayRowTable = nil;
    } else {
        [[DataProvider sharedInstance] setData:self.arrayRowTable];
    }
}

// to make the button float over the tableView including tableHeader
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGRect floatingButtonFrame = self.btnCallPlace.frame;
//    floatingButtonFrame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - self.btnCallPlace.frame.size.height - 20;
//    self.btnCallPlace.frame = floatingButtonFrame;
//    [self.view bringSubviewToFront:self.btnCallPlace]; // float over the tableHeader
//
//}

#pragma mark - Delegate Message Cloud Firebase
// The callback to handle data message received via FCM for devices running iOS 10 or above.
- (void)applicationReceivedRemoteMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage{
    // Print full message
    
    [self refreshTable:[NSDictionary dictionaryWithObjectsAndKeys:[NSJSONSerialization JSONObjectWithData:[[remoteMessage.appData objectForKey:@"value"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil], @"message", [NSNumber numberWithInt:1], @"type", nil]];
    
//    [self.delegate reciveDataSubscribe: [NSDictionary dictionaryWithObjectsAndKeys:[NSJSONSerialization JSONObjectWithData:[[remoteMessage.appData objectForKey:@"value"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil], @"message", [NSNumber numberWithInt:1], @"type", nil]];
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"CallPopup"]){
        ModalViewController *modalViewController = segue.destinationViewController;
        modalViewController.rowSelectCell = self.rowTable;
    }
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchBar.showsCancelButton)
        return [searchResult count];
    else
        return [self.arrayRowTable count];
    // return [[DataProvider sharedInstance] getData].count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.rowTable = [self.arrayRowTable objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"CallPopup" sender:nil];

    
  //  [self presentViewController:add animated:NO completion:nil];
    
    
//    if ([self.modelRowTable objectAtIndex:indexPath.row].notification) {
//        self.rowSelectModel = [self.modelRowTable objectAtIndex:indexPath.row];
//        [self performSegueWithIdentifier:@"callPopup" sender:self];
//        [self.modelRowTable objectAtIndex:indexPath.row].openMessage = YES;
//        [self.tableView beginUpdates];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row
//                                                                                           inSection:0]]
//                              withRowAnimation:UITableViewRowAnimationNone];
//        
//        [self.tableView endUpdates];
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     DataModelTable *place = [[DataModelTable alloc] init];
    
    if (!self.searchBar.showsCancelButton)
        place = [self.arrayRowTable objectAtIndex:indexPath.row];
    else
        place = [searchResult objectAtIndex:indexPath.row];
    
//    if ([self.arrayRowTable objectAtIndex:indexPath.row].imagePlace)
    if (place.imagePlace)
        return 134;
    else
        return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    
    CustomTableViewCell *customCell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    customCell.layer.cornerRadius = 5.0f;
    customCell.layer.borderWidth = 1.0f;
    customCell.layer.borderColor = [UIColor blueColor].CGColor;
    customCell.clipsToBounds = YES;
    
    
    DataModelTable *place = [[DataModelTable alloc] init];
    
    if (!self.searchBar.showsCancelButton)
        place = [self.arrayRowTable objectAtIndex:indexPath.row];
    else
        place = [searchResult objectAtIndex:indexPath.row];
   // DataModelTable *place = [self.arrayRowTable objectAtIndex:indexPath.row];
    
    customCell.strTitle.text = place.placeClass.name;
    customCell.strSubtitle.text = place.placeClass.formattedAddress;
    
    customCell.imagePlace.frame = customCell.frame;
    customCell.imagePlace.layer.cornerRadius = 0;
    customCell.imagePlace.clipsToBounds = NO;
    
    
    customCell.strTitle.frame = [self setFrameDefault:customCell.strTitle.frame];
    customCell.strSubtitle.frame = [self setFrameCellTable:customCell.strTitle.frame addPositionY:customCell.strTitle.frame.size.height+1];

    
    if (place.imagePlace) {
        customCell.imagePlace.frame = CGRectMake(0, 0,customCell.frame.size.width, 90);
        
        customCell.imagePlace.layer.cornerRadius = 10.0f;
        customCell.imagePlace.clipsToBounds = YES;
        
        customCell.strTitle.frame = [self setFrameCellTable:customCell.strTitle.frame addPositionY:customCell.imagePlace.frame.size.height+2];
        
        customCell.strSubtitle.frame = [self setFrameCellTable:customCell.strSubtitle.frame addPositionY:customCell.imagePlace.frame.size.height+2];
    }
    
    customCell.imagePlace.clipsToBounds = YES;
    customCell.imagePlace.image = place.imagePlace;
    
    [customCell.strTitle sizeToFit];
    [customCell.strSubtitle sizeToFit];
    
    
    customCell.imageAlarm.hidden = YES;
    
    UIImageView *alarm = customCell.imageAlarm;
    alarm.center = customCell.imagePlace.center;

    CGRect rect = alarm.frame;
    rect.origin = CGPointMake(customCell.imagePlace.frame.size.width - alarm.frame.size.width-10 , alarm.frame.origin.y);
    rect.size   = CGSizeMake(0, 0);
    alarm.frame = rect;
    
    
    [UIView animateWithDuration:0.7f
                          delay:0.3f
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         
   //                      customCell.imageAlarm.hidden = ((place.notification) && (place.openMessage == NO)) ? NO : YES;
                         
                         CGRect rect = alarm.frame;
                         rect.size = CGSizeMake(43, 43);
                         alarm.frame = rect;
                         
                         [customCell.imagePlace addSubview:alarm];
                         
                        // [customCell.imagePlace bringSubviewToFront:customCell.imageAlarm];
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    
//    customCell.imageAlarm.hidden = ((place.notification) && (place.openMessage == NO)) ? NO : YES;
//    
//    UIImageView *alarm = customCell.imageAlarm;
//
//    alarm.center = customCell.imagePlace.center;
//    
//    CGRect rect = alarm.frame;
//    rect.origin = CGPointMake(customCell.imagePlace.frame.size.width - alarm.frame.size.width-10 , alarm.frame.origin.y);
//    alarm.frame = rect;
//    
//    [customCell.imagePlace addSubview:alarm];
//    
//    
//    [customCell.imagePlace bringSubviewToFront:customCell.imageAlarm];

    
    return customCell;
}

-(CGRect)setFrameCellTable:(CGRect)frameCell addPositionY:(CGFloat)addY{
    
    CGRect value = frameCell;
    value.origin.y = value.origin.y + addY;
    return value;
}

-(CGRect)setFrameDefault:(CGRect)frameCell{
    CGRect value = frameCell;
    value.origin.y = 0;
    return value;
}

#pragma mark method Notification
//- (void)refreshTable:(NSNotification*)notification
- (void)refreshTable:(NSDictionary*)notification
{
    if ([self.arrayRowTable count] > 0){
        
  //      NSLog(@"recive message from Server");
        
//        NSDictionary *notif = notification.userInfo;
//        int ttt = [notif[@"type"] intValue];
        
        
 //       int type = [[[notification userInfo] objectForKey:@"type"] intValue];
        int type = [[notification objectForKey:@"type"] intValue];
        
 //       NSLog(@"type %@", [notification userInfo]);
        
        __block BOOL removeObjToEvents;
        
        removeObjToEvents = YES;
        
//        [[[[notification userInfo] objectForKey:@"message"] objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[[notification objectForKey:@"message"] objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
            for (DataModelTable *rowSelectModel in self.arrayRowTable) {
                
                if ([rowSelectModel.placeID isEqualToString:[obj objectForKey:@"place_id"]]){
                    
                    
                    if ((removeObjToEvents) && (type == 2)) {
                        [rowSelectModel.eventsArray removeAllObjects];
                        removeObjToEvents = NO;
                        
                    }
                    
                    (type == 2) ? [rowSelectModel.eventsArray addObject:obj]: (rowSelectModel.notification = obj);
                //    (type == 2) ? (rowSelectModel.eventsArray = obj): (rowSelectModel.notification = obj);
                
                    [self.tableView beginUpdates];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowSelectModel.rowIdx
                                                                                                       inSection:0]]
                                          withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self.tableView endUpdates];
                }
            }
        }];
        
    }
    
}


//- (void)tableDidSelectedPopever:(NSNotification *)notification
//{
// 
//    [self.itemPopVC dismissViewControllerAnimated:NO completion:nil];
//    self.itemPopVC = nil;
//    
//    NSIndexPath *indexpath = (NSIndexPath *)notification.object;
//    switch (indexpath.row) {
//        case 0:
//            break;
//        case 1:
//            [self buttonLogout:self];
//            break;
//    }
//}

//#pragma mark - method delegate popover contorller
//- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
//{
//    return UIModalPresentationNone;
//}
//
//- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
//{
//    [self.itemPopVC dismissViewControllerAnimated:NO completion:nil];
//    return NO;
//}


//#pragma mark - IBAction

//- (IBAction)buttonLogout:(id)sender
//{
//    UserIsSigned *userInfoRequest = [[UserIsSigned alloc] init];
//    [userInfoRequest updateIsSigned:NO];
//  //  [self dismissViewControllerAnimated:NO completion:nil];
//    [self showLoginViewController];
//}

//- (IBAction)showPopoverView:(id)sender
//{
//    self.itemPopVC = [[PopoverViewController alloc] init];
//    self.itemPopVC.modalPresentationStyle = UIModalPresentationPopover;
//    self.itemPopVC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
//    self.itemPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
//    self.itemPopVC.popoverPresentationController.delegate = self;
//    [self presentViewController:self.itemPopVC animated:YES completion:nil];
//}

//- (IBAction)addPlaceBtn:(id)sender {
//    [self callSearchPlace];
//}

- (void)callSearchPlace
{
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
       //     NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            BOOL isBool = YES;
            
            for (DataModelTable *row in self.arrayRowTable) {
                if ([place isEqual:row.placeClass]){
                    isBool = NO;
                }
            }
            
            if (isBool) {
                DataModelTable *rowPlace = [[DataModelTable alloc] init];
                
                rowPlace.placeClass = place;
                rowPlace.placeID    = place.placeID;
                rowPlace.eventsArray = [[NSMutableArray alloc] init];
                rowPlace.openMessage = NO;
                
                ([self.arrayRowTable count] > 0) ? rowPlace.rowIdx = [self.arrayRowTable count] - 1 : (rowPlace.rowIdx = 0);
                
             //   [self.arrayRowTable addObject:rowPlace];
                

                
                [_placesClient lookUpPhotosForPlaceID:place.placeID
                                             callback:^(GMSPlacePhotoMetadataList *photos,
                                                        NSError *__nullable photoError) {
                                                 if (photos != nil) {
                                                     
                                                     GMSPlacePhotoMetadata *lastPhoto = photos.results.firstObject;
                                                     
                                                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                                         [_placesClient loadPlacePhoto:lastPhoto callback:^(UIImage * _Nullable photo, NSError * _Nullable error) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                    if (photo) rowPlace.imagePlace = photo;
                                                                    [self.arrayRowTable addObject:rowPlace];
                                                                    [self.tableView reloadData];
                                                                 });
                                                            
                                                         }];
                                                     });
                                                 }
                                             }];
                
                
                
                
              //  [self.tableView reloadData];
                
            } else {
                
                [self showAlert:@"You already have this place."];
                
                //NSLog(@"You already have this place.");
            
            }
        } else {
            // NSLog(@"No place selected");
        }
    }];
    
}


#pragma mark - call Login View

//-(void)showLoginViewController{
//    if (![GLOBAL_APP_DELEGATE isSigned]) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginViewController *loginView =  (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
//        
//        [loginView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//        [loginView setModalPresentationStyle:UIModalPresentationFullScreen];
//        
//    
//        [self.parentViewController presentViewController:loginView animated:YES completion:nil];
//      }
//}


//#pragma mark - create button over uitableview
//-(void)initButtonOverTable{
//      self.placeBtn.layer.borderColor = UIColorFromHEX(COLOR_ACCENT).CGColor;
//      self.placeBtn.backgroundColor = UIColorFromHEX(COLOR_ACCENT);
//      self.placeBtn.layer.cornerRadius = 48 / 2.0f;
//      self.placeBtn.clipsToBounds = YES;
//      [self.placeBtn addTarget:self action:@selector(callSearchPlace) forControlEvents:UIControlEventTouchDown];
//    
////    self.btnCallPlace = [UIButton buttonWithType:UIButtonTypeCustom];
////    self.btnCallPlace.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height, 48, 48.0);
////    self.btnCallPlace.layer.cornerRadius = 48 / 2.0f;
////    self.btnCallPlace.backgroundColor = UIColorFromHEX(COLOR_ACCENT);
////    self.btnCallPlace.layer.borderWidth = 2.0f;
////    self.btnCallPlace.layer.borderColor = UIColorFromHEX(COLOR_ACCENT).CGColor;
////    self.btnCallPlace.clipsToBounds = YES;
////    
////   // [self.btnCallPlace setBackgroundImage:[UIImage imageNamed:@"ic_dialog_map"] forState:UIControlStateNormal];
////   // [self.btnCallPlace setBackgroundImage:[UIImage imageNamed:@"default_marker"] forState:UIControlStateNormal];
////    
////    
////    [self.btnCallPlace addTarget:self action:@selector(callSearchPlace) forControlEvents:UIControlEventTouchDown];
////    [self.view insertSubview:self.btnCallPlace aboveSubview:self.view];
//}

#pragma mark show Alert
-(void)showAlert:(NSString*)message{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark methor controller Search
-(void)filterContentForSearchtext:(NSString*)searchText{
    
    
    if ((searchText == nil) || (searchText.length == 0)) {
        
        // If empty the search results are the same as the original data
        searchResult = [self.arrayRowTable mutableCopy];
    } else {
        NSMutableArray <DataModelTable*> *searchResultMutable = [[NSMutableArray alloc] init];
        for (DataModelTable *rowTableView in self.arrayRowTable){
            if ([rowTableView.placeClass.formattedAddress containsString:searchText] || [rowTableView.placeClass.name containsString:searchText]){
                [searchResultMutable addObject:rowTableView];
            }
        }
        searchResult = searchResultMutable;
        
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self filterContentForSearchtext:searchText];
    if (searchResult) {
        [self.tableView reloadData];
    }
}


//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//
//    // Set searchString equal to what's typed into the searchbar
//    NSString *searchString = self.searchController.searchBar.text;
//    
//    [self filterContentForSearchtext:searchString];
//
//    if (searchResult) {
//        [self.tableView reloadData];
//    }
//}

#pragma  mark - update current place - Custom Method
//-(void)updateCurrentPlace{
//
//    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
//        if (error != nil) {
//            NSLog(@"Error %@", [error localizedDescription]);
//            return ;
//        }
//        
//        for (GMSPlaceLikelihood *list in likelihoodList.likelihoods) {
//            GMSPlace *place = list.place;
////            NSLog(@"%@ %g", place.name, list.likelihood);
////            NSLog(@"%@ ", place.formattedAddress);
//            
//        }
//        
//    }];
//
//}

@end
