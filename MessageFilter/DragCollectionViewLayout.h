//
//  DragCollectionViewLayout.h
//  MessageFilter
//
//  Created by 马远 on 2017/11/13.
//  Copyright © 2017年 马远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DragCollectionViewLayout;

typedef enum : NSUInteger {
    DragOrientationALL = 0,
    DragOrientationHorizontal,
    DragOrientationVertical,
} DragOrientation;

@protocol DragCollectionViewLayoutDelegate<NSObject>


- (void)willDraggingItemWithIndexPath:(NSIndexPath *)indexPath layout:(DragCollectionViewLayout *)layout;

- (void)willMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath layout:(DragCollectionViewLayout *)layout;
- (void)didMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath layout:(DragCollectionViewLayout *)layout;

- (void)endDraggingAtIndexPath:(NSIndexPath *)atIndexPath toIndexPath:(NSIndexPath *)toIndexPath layout:(DragCollectionViewLayout *)layout;

- (BOOL)canMoveItemAtIndexPath:(NSIndexPath *)indexPath layout:(DragCollectionViewLayout *)layout;
- (BOOL)canMoveToIndexPath:(NSIndexPath *)indexPath layout:(DragCollectionViewLayout *)layout;

@end

@interface DragCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, weak)id <DragCollectionViewLayoutDelegate> delegate;
@property (nonatomic, assign)DragOrientation dragOrientation;

@end
