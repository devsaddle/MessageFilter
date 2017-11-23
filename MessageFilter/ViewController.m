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
#import "RegularExpression.h"
#import "DragCollectionView.h"

@interface ViewController ()<DragCollectionViewDelegate,DragCollectionViewDataSource>
@property (weak, nonatomic) DragCollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViews];
    [self setNavBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.collectionView reloadData];
    
}

#pragma mark - Init Views
- (void)setViews {
    DragCollectionView *view = [[DragCollectionView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    view.dataSource = self;
    view.delegate = self;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"FilterRuleIdentifiter"];

    self.collectionView = view;
    [self.view addSubview:view];
    
}

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
- (NSInteger)dragCollectionView:(DragCollectionView *)dragCollectionView numberOfItemsInSection:(NSInteger)section {
    
    return messageFilterData().count;
    
}

- (UICollectionViewCell *)dragCollectionView:(DragCollectionView *)dragCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = messageFilterData()[indexPath.row];
    CollectionViewCell *cell = [CollectionViewCell collectionViewCell:dragCollectionView.collectionView indexPath:indexPath];
    [cell setData:data];
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (CGSize)dragCollectionView:(DragCollectionView *)dragCollectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 60) * 0.5, 100);
}

- (UIEdgeInsets)dragCollectionView:(DragCollectionView *)dragCollectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

//cell的最小行间距
- (CGFloat)dragCollectionView:(DragCollectionView *)dragCollectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 20;
}


//cell被选择时被调用
- (void)dragCollectionView:(DragCollectionView *)dragCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RuleViewController *ruleViewController = [[RuleViewController alloc] init];
    ruleViewController.index = indexPath.row;
    [ruleViewController ruleData:messageFilterData()[indexPath.row]];
    [self.navigationController pushViewController:ruleViewController animated:YES];
}

- (void)dragCollectionView:(DragCollectionView *)dragCollectionView endMoveAtIndexPath:(NSIndexPath *)atIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSArray *filterArray = messageFilterData();
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:filterArray];
    id atObjct = tmpArray[atIndexPath.row];
    [tmpArray removeObject:atObjct];
    [tmpArray insertObject:atObjct atIndex:toIndexPath.row];
    savaToUserDefault([tmpArray copy]);
}
#pragma mark -


@end
