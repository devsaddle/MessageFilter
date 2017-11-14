//
//  DragCollectionView.h
//  MessageFilter
//
//  Created by 马远 on 2017/11/13.
//  Copyright © 2017年 马远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  DragCollectionView;

@protocol DragCollectionViewDataSource <NSObject>

@required
- (NSInteger)dragCollectionView:(DragCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)dragCollectionView:(DragCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInDragCollectionView:(DragCollectionView *)dragCollectionView;

@end

@protocol DragCollectionViewDelegate <NSObject>

@optional
- (void)dragCollectionView:(DragCollectionView *)dragCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)dragCollectionView:(DragCollectionView *)dragCollectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)dragCollectionView:(DragCollectionView *)dragCollectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

- (CGFloat)dragCollectionView:(DragCollectionView *)dragCollectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;

- (CGFloat)dragCollectionView:(DragCollectionView *)dragCollectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

@end

@interface DragCollectionView : UIView

@property (nonatomic, weak) id<DragCollectionViewDataSource> dataSource;
@property (nonatomic, weak) id<DragCollectionViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;

@end
