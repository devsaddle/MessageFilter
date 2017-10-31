//
//  RuleViewController.m
//  MessageFilter
//
//  Created by 马远 on 2017/10/17.
//  Copyright © 2017年 马远. All rights reserved.
//

#import "RuleViewController.h"
#import "InputViewCell.h"
#import "RegularExpression.h"

@interface RuleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong)__block NSMutableDictionary *ruleDictionary;
@property(nonatomic, assign, getter=isNewData)BOOL newsData;

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
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if (self.isNewData) {
        addOneRule(self.ruleDictionary);
    } else {
        updateUserDefaultData(self.ruleDictionary, self.index);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"%@",self.ruleDictionary);
}

#pragma mark -
- (void)ruleData:(NSDictionary *)ruleDic {

    if (!ruleDic || ruleDic.count <= 0) {
        return;
    }
    _ruleDictionary = [NSMutableDictionary dictionaryWithDictionary:ruleDic];
    self.newsData = NO;
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
            return keywords.count + 1;
        } else {
            return 1;
        }
  
    } else if (section == 2) {
        return 1;
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        InputViewCell *cell = [InputViewCell cellWithTableView:tableView forIndexPath:indexPath];
        [cell setTitle:@"标签"];
        [cell setPlacegolderText:@"输入标签"];
        [cell setText:[self.ruleDictionary objectForKey:@"name"]];
        [cell textEditEnd:^(NSString *text) {
            self.ruleDictionary[@"name"] = text;
        }];
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        InputViewCell *cell = [InputViewCell cellWithTableView:tableView forIndexPath:indexPath];
        [cell setTitle:@"类型"];
        [cell setPlacegolderText:@"点击选择过滤类型"];
        [cell setText:typeName([self.ruleDictionary objectForKey:@"type"])];
        [cell inputEnable:NO];
        
        return cell;
  
    }  else if (indexPath.section == 1 && indexPath.row == [(NSArray *)[self.ruleDictionary objectForKey:@"keywords"] count]) {
        static NSString *identifiler = @"ImageTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiler];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiler];
            cell.textLabel.text = @"添加";
            cell.textLabel.textColor = [UIColor blueColor];
            cell.imageView.image = [UIImage imageNamed:@"add"];
        }
        
        return cell;
        
    }  else if (indexPath.section == 1) {
        InputViewCell *cell = [InputViewCell cellWithTableView:tableView forIndexPath:indexPath];
        [cell setTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        [cell setPlacegolderText:@"关键词"];
        [cell setText:[self.ruleDictionary objectForKey:@"keywords"][indexPath.row]];
        [cell textEditEnd:^(NSString *text) {
            NSMutableArray *keywords = [NSMutableArray arrayWithArray:self.ruleDictionary[@"keywords"]];
            keywords[indexPath.row] = text ;
            self.ruleDictionary[@"keywords"] = [keywords copy];
        }];
        return cell;
        
    }else if (indexPath.section == 2 && indexPath.row == 0) {
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
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
       
        [self showActionSheet];
    }
    
    if (indexPath.section == 1 && indexPath.row == [(NSArray *)[self.ruleDictionary objectForKey:@"keywords"] count]) {
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        NSArray *keywords = [self.ruleDictionary objectForKey:@"keywords"];
        if (keywords.count >= 1 && ([keywords lastObject] == nil || [[keywords lastObject] isEqualToString:@""])) {
            return;
        }
        if (keywords) {
            self.ruleDictionary[@"keywords"] = [keywords arrayByAddingObject:@""];
        } else {
            self.ruleDictionary[@"keywords"] = @[@""];
        }
        [self.tableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    updateUserDefaultData(self.ruleDictionary, self.index);
}

#pragma mark -
- (void)showActionSheet {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    InputViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [alert addAction:[UIAlertAction actionWithTitle:typeName(@"1") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.ruleDictionary[@"type"] = @"1";
        [cell setText:action.title];

    }]];
    [alert addAction: [UIAlertAction actionWithTitle:typeName(@"2") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.ruleDictionary[@"type"] = @"2";
        [cell setText:action.title];

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:typeName(@"3") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.ruleDictionary[@"type"] = @"3";
        [cell setText:action.title];

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:typeName(@"4") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.ruleDictionary[@"type"] = @"4";
        [cell setText:action.title];

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
- (NSMutableDictionary *)ruleDictionary {
    if (_ruleDictionary == nil) {
        _ruleDictionary = [NSMutableDictionary dictionary];
        [_ruleDictionary setDictionary:@{@"type":@"1",
                                         @"name":@"",
                                         @"keywords":@[],
                                         @"rule":@""
                                         }];
        self.newsData = YES;
    }
    return _ruleDictionary;
    
}

@end
