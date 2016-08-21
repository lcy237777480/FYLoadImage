//
//  ViewController.m
//  FYLoadImage
//
//  Created by donotbedidouzu on 16/8/21.
//  Copyright © 2016年 浮云. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AppsModel.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<UITableViewDataSource>

@end

@implementation ViewController{
    
    /// 数据源数组
    NSArray *_appsList;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadJsonData];
}
#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _appsList.count;
}

/*
 问题1 : 列表显示出来后，并不显示图片，来回滚动cell或者点击cell ，图片才会显示。
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppsCell" forIndexPath:indexPath];
    
    // 获取cell对应的数据模型
    AppsModel *app = _appsList[indexPath.row];
    
    // 给cell的子控件赋值
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.download;
    
    //利用SDWebImage框架 下载图片
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:app.icon]];
    
    return cell;
}


/// 获取json数据的主方法
- (void)loadJsonData
{
    // 创建网络请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // json数据的地址
    NSString *URLString = @"https://raw.githubusercontent.com/zhangxiaochuZXC/ServerFile20/master/apps.json";
    
    // 网络请求管理者发送GET请求,获取json数据;
    // 默认是异步执行的,回调默认是主线程
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *responseObject) {
        // 定义临时的可变的数组
        NSMutableArray *tmpM = [NSMutableArray arrayWithCapacity:responseObject.count];
        
        // 下一步 : 拿着字典数组responseObject,实现字典转模型
        [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // obj : 就是数组里的元素(字典)
            AppsModel *app = [AppsModel appWithDict:obj];
            
            // 把模型对象添加到可变数组
            [tmpM addObject:app];
        }];
        
        // 给数据源数组赋值
        _appsList = tmpM.copy;
        // 刷新列表
        [self.tableView reloadData];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
