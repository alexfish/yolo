//
//  MasterViewController.h
//  Yolo
//
//  Created by Alex Fish on 12/05/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
