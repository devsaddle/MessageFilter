//
//  DragCollectionViewLayout.h
//  MessageFilter
//
//  Created by 马远 on 2017/11/13.
//  Copyright © 2017年 马远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DragCollectionViewLayout;

@protocol DragCollectionViewLayoutDelegate<NSObject>

- (void)willDraggingItemWithIndexPath:(NSIndexPath *)indexPath layout:(DragCollectionViewLayout *)layout;
- (void)didDraggingItemWithIndexPath:(NSIndexPath *)indexPath layout:(DragCollectionViewLayout *)layout;
- (void)endDraggingItemWithIndexPath:(NSIndexPath *)indexPath layout:(DragCollectionViewLayout *)layout;

@end

@interface DragCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, weak)id <DragCollectionViewLayoutDelegate> delegate;

@end
