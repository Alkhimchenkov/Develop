//
//  ModalViewController.h
//  Urbo_iOS
//
//  Created by Андрей on 20.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModelTable.h"



@interface ModalViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView   *viewCellSelect;
@property (nonatomic, strong) IBOutlet UIButton *buttonPane1;
@property (nonatomic, strong) IBOutlet UIButton *buttonPane2;
@property (nonatomic, strong) IBOutlet UIView *containerPane;

@property (nonatomic, strong) UIView *paneView;
@property (nonatomic, strong) UIView *paneView1;
@property (nonatomic, strong) UIView *paneView2;

//@property (strong, nonatomic) NSArray <DataModelTable *> *rowSelectCell;
@property (strong, nonatomic) DataModelTable *rowSelectCell;




@property (strong, nonatomic) IBOutlet UILabel *strTitle;
@property (strong, nonatomic) IBOutlet UILabel *strSubTitle;


- (IBAction)didPressbuttonPane1:(id)sender;
- (IBAction)didPressbuttonPane2:(id)sender;

@end
