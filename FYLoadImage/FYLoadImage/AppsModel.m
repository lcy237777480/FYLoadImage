//
//  ViewController.m
//  FYLoadImage
//
//  Created by donotbedidouzu on 16/8/21.
//  Copyright © 2016年 浮云. All rights reserved.
//

#import "AppsModel.h"

@implementation AppsModel

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    // 创建模型对象
    AppsModel *app = [[AppsModel alloc] init];
    // 使用KVC实现字典转模型
    [app setValuesForKeysWithDictionary:dict];
    // 返回模型对象
    return app;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

@end
