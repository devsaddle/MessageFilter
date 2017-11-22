//
//  DragCollectionView.m
//  MessageFilter
//
//  Created by 马远 on 2017/11/13.
//  Copyright © 2017年 马远. All rights reserved.
//

#import "DragCollectionView.h"
#import "DragCollectionViewLayout.h"

@interface DragCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)DragCollectionViewLayout *collectionViewLayout;
@end

@implementation DragCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViewsWithFrame:frame];
    }
    return self;
}


#pragma mark - Init Views
- (void)initializeViewsWithFrame:(CGRect)frame {
    if (_collectionViewLayout == nil) {
        _collectionViewLayout = [[DragCollectionViewLayout alloc] init];
    }
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:_collectionViewLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = self.backgroundColor;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_collectionView];
        
    }
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInDragCollectionView:)]) {
        return [self.dataSource numberOfSectionsInDragCollectionView:self];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dragCollectionView:numberOfItemsInSection:)]) {
        return [self.dataSource dragCollectionView:self numberOfItemsInSection:section];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dragCollectionView:cellForItemAtIndexPath:)]) {
        return [self.dataSource dragCollectionView:self cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCollectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate dragCollectionView:self didSelectItemAtIndexPath:indexPath];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCollectionView:layout:sizeForItemAtIndexPath:)]) {
       return  [self.delegate dragCollectionView:self layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCollectionView:layout:insetForSectionAtIndex:)]) {
        return  [self.delegate dragCollectionView:self layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCollectionView:layout:insetForSectionAtIndex:)]) {
        return  [self.delegate dragCollectionView:self layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCollectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
      return  [self.delegate dragCollectionView:self layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    return 0;
}
@end
