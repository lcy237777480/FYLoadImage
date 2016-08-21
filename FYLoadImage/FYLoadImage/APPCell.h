//
//  ViewController.m
//  FYLoadImage
//
//  Created by donotbedidouzu on 16/8/21.
//  Copyright © 2016年 浮云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppsModel.h"

@interface APPCell : UITableViewCell

@property (strong, nonatomic) AppsModel *app;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
