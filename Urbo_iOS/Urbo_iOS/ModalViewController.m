//
//  ModalViewController.m
//  Urbo_iOS
//
//  Created by Андрей on 20.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "ModalViewController.h"
#import "Panel.h"
#import "Constatns.h"
#import "CellNotifModalView.h"
#import "SingletonImageObject.h"
#import "EventsTableViewController.h"
#import "Button+Border.h"

@interface ViewPresentation : UIPresentationController

@property (nonatomic, readonly) UIView *dimmingView;

@end


@implementation ViewPresentation

- (UIView *)dimmingView {
    static UIView *instance = nil;
    if (instance == nil) {
        instance = [[UIView alloc] initWithFrame:self.containerView.bounds];
        instance.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return instance;
}


-(void)presentationTransitionWillBegin{
//    NSLog(@"presentationTransitionWillBegin");
    
    [[self containerView] addSubview:self.dimmingView];
    [self.dimmingView addSubview:self.presentedViewController.view];
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 1;
    } completion:nil];
}


- (void)presentationTransitionDidEnd:(BOOL)completed {
  //  NSLog(@"presentationTransitionDidEnd");
    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
}


- (void)dismissalTransitionDidEnd:(BOOL)completed{
  //  NSLog(@"dismissalTransitionDidEnd");
    if (!completed)
        [self.dimmingView removeFromSuperview];
}

-(CGRect)frameOfPresentedViewInContainerView{
  //  NSLog(@"frameOfPresentedViewInContainerView");
    return CGRectMake(0, 70, self.containerView.frame.size.width, self.containerView.frame.size.height-150);
}


@end


@interface ModalViewController () <UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITapGestureRecognizer *tapOutsideRecognizer;

@property (nonatomic, strong) UITableView *tableNotification;
@property (nonatomic, strong) UITableView *tableEvents;

@property (nonatomic, strong) NSArray *notificRowText;
@property (nonatomic, strong) EventsTableViewController *eventsController;


@property (strong, nonatomic) IBOutlet Button_Border *notification;

@property (strong, nonatomic) IBOutlet Button_Border *events;


@end

@implementation ModalViewController


-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
     //_rowText = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4,",@"5", nil];
    
   // self.detail = [[Panel alloc] init];
    
    // Do any additional setup after loading the view.

//    CALayer *layer = [CALayer layer];
//    
//    
// //   CALayer *border = [CALayer layer];
//    layer.backgroundColor = UIColorFromHEX(COLOR_MAIN).CGColor;
//    
//   /// layer.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
//    [self.buttonPane1.layer addSublayer:layer];
    
    
    
    self.viewCellSelect.backgroundColor = UIColorFromHEX(COLOR_MAIN);
   // self.viewCellSelect.layer.cornerRadius = 8.0;
    
  //  self.containerPane.layer.cornerRadius = 8.0;
    
    
    self.containerPane.layer.borderWidth = 1.0;
    self.containerPane.layer.borderColor = [UIColor redColor].CGColor;
    
//    self.buttonPane1.layer.borderWidth = 1.0;
//    self.buttonPane1.layer.borderColor = [UIColor blueColor].CGColor;
 //   self.buttonPane1.layer.cornerRadius = 8.0;
    
//    self.buttonPane2.layer.borderWidth = 1.0;
//    self.buttonPane2.layer.borderColor = [UIColor purpleColor].CGColor;
 //   self.buttonPane2.layer.cornerRadius = 8.0;
    
    self.paneView = [Panel createWithParentView:self.containerPane];
    

    
  //  NSLog(@"viewDidLoad");
    
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.strTitle.text = self.rowSelectCell.placeClass.name;
    self.strSubTitle.text = self.rowSelectCell.placeClass.formattedAddress;
    
    _notificRowText = [NSArray arrayWithObjects:self.rowSelectCell.notification, nil];
    
    if ([_notificRowText count] == 0) {
        _notificRowText = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Ooops!",@"title",
                                                                                               @"You have no any notification here.", @"message", nil], nil];
    }
    
//    [[self.rowSelectCell.eventsArray objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [_eventsRowText addObject:obj];
//    }];

 //   NSLog(@"viewWillAppear");

}


- (void)viewDidLayoutSubviews
{
    [self.notification addBottomBorderWithColor:[UIColor redColor] andWidth:1.0 ];
    
    CGRect frame = self.paneView.frame;
    CGRect frameParent = self.containerPane.frame;
    frame.size.width = frameParent.size.width * 2;
    frame.size.height = frameParent.size.height;
    [self.paneView setFrame:frame];

    
    self.paneView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frameParent.size.width, frameParent.size.height)];
    self.paneView1.backgroundColor = [UIColor greenColor];
    
    self.paneView1.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                       UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    [self.paneView addSubview:self.paneView1];
    
    _tableNotification = [[UITableView alloc] initWithFrame:self.paneView1.bounds];
    self.tableNotification.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                         UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    
    
    [self.paneView1 addSubview:self.tableNotification];
    [_tableNotification setDataSource:self];
    [_tableNotification setDelegate:self];
    
    _tableNotification.estimatedRowHeight = 44;
    _tableNotification.rowHeight = UITableViewAutomaticDimension;
    

    self.paneView2 = [[UIView alloc] initWithFrame:CGRectMake(frameParent.size.width, 0, frameParent.size.width, frameParent.size.height)];
  //  self.paneView2.backgroundColor = [UIColor yellowColor];
    self.paneView2.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                       UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    [self.paneView addSubview:self.paneView2];
    
    
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(self.paneView2.bounds.origin.x, 0,
                                                               self.paneView2.bounds.size.width, 50)];
  //  viewTop.backgroundColor = [UIColor blackColor];
    
    [self.paneView2 addSubview:viewTop];
    
    UIButton *buttonEvets = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonEvets setTitle:@"Create" forState:UIControlStateNormal];
    buttonEvets.frame = CGRectMake(20, 10, 100, 30);
    buttonEvets.backgroundColor = UIColorFromHEX(COLOR_MAIN);
    
    [viewTop addSubview:buttonEvets];
    
    
//   _tableEvents = [[UITableView alloc] initWithFrame:self.paneView2.bounds];
    _tableEvents = [[UITableView alloc] initWithFrame:CGRectMake(self.paneView2.bounds.origin.x,
                                                                 self.paneView2.bounds.origin.y + 50,
                                                                 self.paneView2.bounds.size.width,
                                                                 self.paneView2.bounds.size.height - 50)];
    
    self.tableEvents.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                       UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);


    [self.paneView2 addSubview:self.tableEvents];
    

    if (_eventsController == nil) {
        _eventsController = [[EventsTableViewController alloc] init];
        
        NSMutableArray *arrayEvents = [[NSMutableArray alloc] init];
        
        for (NSDictionary *rowArray in self.rowSelectCell.eventsArray) {
            [arrayEvents addObject:rowArray];
        }
        
        [self.eventsController setRowEvents:arrayEvents];
    }
        
    [_tableEvents setDataSource:_eventsController];
    [_tableEvents setDelegate:_eventsController];

    _tableEvents.estimatedRowHeight = 44;
    _tableEvents.rowHeight = UITableViewAutomaticDimension;
    

  //  NSLog(@"viewDidLayoutSubviews");
    
}


- (void)viewDidAppear:(BOOL)animated {
    if (!self.tapOutsideRecognizer) {
        self.tapOutsideRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
        self.tapOutsideRecognizer.numberOfTapsRequired = 1;
        self.tapOutsideRecognizer.cancelsTouchesInView = NO;
        self.tapOutsideRecognizer.delegate = self;
        [self.view.window addGestureRecognizer:self.tapOutsideRecognizer];
    }
    
//    NSLog(@"viewDidAppear");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:nil];
        
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil]) {
            [self.view.window removeGestureRecognizer:sender];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return [[ViewPresentation alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}



- (IBAction)didPressbuttonPane1:(id)sender
{
    
    [self.notification addBottomBorderWithColor:[UIColor redColor] andWidth:1.0 ];
    [self.events removeBottomBorder];
    
    __block CGRect frame = self.paneView.frame;
    
    // Animate move
    [UIView animateWithDuration:0.4 animations:^{
        frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
        [self.paneView setFrame:frame];
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)didPressbuttonPane2:(id)sender
{
    
    [self.events addBottomBorderWithColor:[UIColor redColor] andWidth:1.0 ];
    [self.notification removeBottomBorder];
    
    __block CGRect frame = self.paneView.frame;
    CGRect frameParent = self.containerPane.frame;
    
    // Animate move
    [UIView animateWithDuration:0.4 animations:^{
        frame = CGRectMake(0 - frameParent.size.width, frame.origin.y, frame.size.width, frame.size.height);
        [self.paneView setFrame:frame];
    } completion:^(BOOL finished) {
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_notificRowText count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";

        CellNotifModalView *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
 
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"CellNotifModalView" bundle:nil] forCellReuseIdentifier:identifier];
            
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
    
        
        cell.titleText.text = [[_notificRowText objectAtIndex:indexPath.row] objectForKey:@"title"];

        cell.detailText.text = [[_notificRowText objectAtIndex:indexPath.row] objectForKey:@"message"];

        
  //      cell.imageView.image =  [[SingletonImageObject sigleton]
    //                                   imageFromCache:[[_notificRowText objectAtIndex:indexPath.row]
      //                                                 objectForKey:@"file_path"]];
        
        
        return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return UITableViewAutomaticDimension;
}


@end
