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
#import "APPCell.h"

@interface ViewController ()<UITableViewDataSource>

@end

@implementation ViewController{
    
    /// 数据源数组
    NSArray *_appsList;
    /// 全局队列
    NSOperationQueue *_queue;
    /// 图片缓存池
    NSMutableDictionary *_imagesCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 实例化队列
    _queue = [[NSOperationQueue alloc] init];
    // 实例化图片缓存池
    _imagesCache = [[NSMutableDictionary alloc] init];
    
    [self loadJsonData];
}
#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _appsList.count;
}

/*
 问题1 : 列表显示出来后，并不显示图片，来回滚动cell或者点击cell ，图片才会显示。
 解决方法：自定义cell
 
 
 问题2 : 当有网络延迟时,来回滚动cell,会出现cell上图片的闪动;因为cell有复用
 解决办法 : 占位图
 
 问题3 : 图片每次展示,都要重新下载
 解决办法 : 设计内存缓存策略 ()
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppsCell" forIndexPath:indexPath];
    
    // 获取cell对应的数据模型
    AppsModel *app = _appsList[indexPath.row];
    
    // 给cell传入模型对象
    cell.app = app;
    
    // 在建立下载操作之前,判断要下载的图片在图片缓存池里面有没有
    UIImage *memImage = [_imagesCache objectForKey:app.icon];
    if (memImage != nil) {
        NSLog(@"从内存中加载...%@",app.name);
        cell.iconImageView.image = memImage;
        return cell;
    }
    
    // 在图片下载之前,先设置占位图
    cell.iconImageView.image = [UIImage imageNamed:@"user_default"];
    
#pragma NSBlockOperation实现图片的异步下载
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        // 模拟网络延迟
        [NSThread sleepForTimeInterval:0.2];
        
        // URL
        NSURL *URL = [NSURL URLWithString:app.icon];
        // data
        NSData *data = [NSData dataWithContentsOfURL:URL];
        // image
        UIImage *image = [UIImage imageWithData:data];
        
        // 图片下载完成之后,回到主线程更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.iconImageView.image = image;
            
            // 把图片保存到图片缓存池
            if (image != nil) {
                [_imagesCache setObject:image forKey:app.icon];
            }
        }];
    }];
    
    // 把操作添加到队列
    [_queue addOperation:op];
    
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
