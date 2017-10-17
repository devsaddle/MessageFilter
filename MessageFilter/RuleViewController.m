//
//  RuleViewController.m
//  MessageFilter
//
//  Created by 马远 on 2017/10/17.
//  Copyright © 2017年 马远. All rights reserved.
//

#import "RuleViewController.h"
#import "InputViewCell.h"

@interface RuleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong)NSDictionary *ruleDictionary;

@end

@implementation RuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Views
- (void)setNavBar {
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(rightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setViewsLayout];
}

- (void)setViewsLayout {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.tableView.frame = CGRectMake(0, 0, width, height - 64);
}

#pragma mark - Private Method
- (void)rightBarButtonItem {
    
}

#pragma mark -
- (void)ruleData:(NSDictionary *)ruleDic {
//    @{@"type":@"1", // 1 关键词过滤 2 号码过滤 3 正则过滤内容 4 正则过滤号码
//      @"name":@"名称", // 标签
//      @"keywords":@[@"word1",@"word2",@"word3"], // 关键词\号码数组
//      @"rule":@"规则"};  // 正则表达式
    if (!ruleDic || ruleDic.count <= 0) {
        return;
    }
    self.ruleDictionary = ruleDic;
    NSInteger type = [[ruleDic objectForKey:@"type"] integerValue];
    switch (type) {
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        default:
            break;
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        NSInteger type = [[self.ruleDictionary objectForKey:@"type"] integerValue];
        if (type == 1 || type == 2) {
            NSArray *keywords = [self.ruleDictionary objectForKey:@"keywords"];
            return keywords.count;
        } else {
            return 1;
        }
  
    } else if (section == 2) {
        return 2;
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        InputViewCell *cell = [InputViewCell cellWithTableView:tableView forIndexPath:indexPath];
        [cell setTitle:@"标签"];
        [cell setPlacegolderText:@"输入标签"];
        [cell setText:[self.ruleDictionary objectForKey:@"name"]];
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        InputViewCell *cell = [InputViewCell cellWithTableView:tableView forIndexPath:indexPath];
        [cell setTitle:@"类型"];
        [cell setPlacegolderText:@"点击选择过滤类型"];
        [cell setText:[self.ruleDictionary objectForKey:@"type"]];
        [cell inputEnable:NO];
        return cell;
  
    } else if (indexPath.section == 1) {
        InputViewCell *cell = [InputViewCell cellWithTableView:tableView forIndexPath:indexPath];
        [cell setTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        [cell setPlacegolderText:@"关键词"];
        [cell setText:[self.ruleDictionary objectForKey:@"keywords"][indexPath.row]];
        return cell;
        
    } else if (indexPath.section == 2) {
        static NSString *identifiler = @"ImageTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiler];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiler];
            cell.textLabel.text = @"测试规则";
            cell.imageView.image = [UIImage imageNamed:@"test"];
        }
        
        return cell;
        
    }
    
    return nil;
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self showActionSheet];
    }
    
}

#pragma mark -
- (void)showActionSheet {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"关键词过滤" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction: [UIAlertAction actionWithTitle:@"号码过滤" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"正则过滤内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"正则过滤号码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
    
}
@end
