//
//  ViewController.m
//  FYLoadImage
//
//  Created by donotbedidouzu on 16/8/21.
//  Copyright © 2016年 浮云. All rights reserved.
//

#import "APPCell.h"

@interface APPCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@end

@implementation APPCell

- (void)setApp:(AppsModel *)app
{
    _app = app;
    
    // 给cell的子控件赋值
    self.nameLabel.text = app.name;
    self.downloadLabel.text = app.download;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
