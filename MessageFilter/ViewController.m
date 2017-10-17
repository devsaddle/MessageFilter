//
//  ViewController.m
//  MessageFilter
//
//  Created by 马远 on 2017/10/1.
//  Copyright © 2017年 马远. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "RuleViewController.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Views
- (void)setNavBar {
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightItem;

}

#pragma mark - Private Method
- (void)rightBarButtonItem {
    RuleViewController *ruleViewController = [[RuleViewController alloc] init];
    [self.navigationController pushViewController:ruleViewController animated:YES];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 20;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [CollectionViewCell collectionViewCell:collectionView indexPath:indexPath];
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 60) * 0.5, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 20;
}


//cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    RuleViewController *ruleViewController = [[RuleViewController alloc] init];
    [ruleViewController ruleData:@{@"type":@"1",
                                   @"name":@"名称",
                                   @"keywords":@[@"word1",@"word2",@"word3"],
                                   @"rule":@"规则"}];
    [self.navigationController pushViewController:ruleViewController animated:YES];
}


#pragma mark -
- (NSUserDefaults *)userDefault {
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.yuan.messagefilter"];
    return userDefault;
    
}

- (void)addRule:(NSInteger)type {
    
    
}

- (NSArray *)getAllRules {
    
    return @[@{@"type":@"12",
               @"name":@"名称",
               @"keywords":@[@"word1",@"word2",@"word3"],
               @"rule":@"规则"},
             
             @{@"type":@"12",
               @"name":@"名称",
               @"keywords":@[@"word1",@"word2",@"word3"],
               @"rule":@"规则"},
             
             @{@"type":@"12",
               @"name":@"名称",
               @"keywords":@[@"word1",@"word2",@"word3"],
               @"rule":@"规则"}];
}

@end
