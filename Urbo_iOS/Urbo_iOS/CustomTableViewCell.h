//
//  CustomTableViewCell.h
//  Urbo_iOS
//
//  Created by Андрей on 12.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *strTitle;
@property (weak, nonatomic) IBOutlet UILabel *strSubtitle;
//@property (weak, nonatomic) IBOutlet UILabel *strCountMess;
@property (weak, nonatomic) IBOutlet UIImageView *imageAlarm;
@property (weak, nonatomic) IBOutlet UIImageView *imagePlace;

@end
