//
//  DetailViewController.h
//  Yolo
//
//  Created by Alex Fish on 12/05/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
