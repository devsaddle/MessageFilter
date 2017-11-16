//
//  DragCollectionViewLayout.m
//  MessageFilter
//
//  Created by 马远 on 2017/11/13.
//  Copyright © 2017年 马远. All rights reserved.
//

#import "DragCollectionViewLayout.h"

@interface DragCollectionViewLayout()
{
    CGFloat _spacingX;
    CGFloat _spacingY;
    NSIndexPath *_startIndexPath;
    NSIndexPath *_endIndexPath;
    UICollectionViewCell *_movingCell;
    CGPoint _originalPoint;
}

@end

@implementation DragCollectionViewLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addObserver];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addObserver];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"collectionView"];
}

- (void)addObserver {
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"collectionView"]) {
        [self addGesture];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)addGesture {
    if (self.collectionView == nil) {
        return;
    }
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(langGesture:)];
    [self.collectionView setGestureRecognizers:@[longGesture]];
    
}

- (void)langGesture:(UILongPressGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self.collectionView];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
       // 开始拖动
        _startIndexPath = [self.collectionView indexPathForItemAtPoint:point];
        _movingCell = [self.collectionView cellForItemAtIndexPath:_startIndexPath];
        _originalPoint = _movingCell.center;
        _spacingX = point.x - _originalPoint.x;
        _spacingY = point.y - _originalPoint.y;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.collectionView bringSubviewToFront:_movingCell];
            _movingCell.transform = CGAffineTransformMakeScale(1.1, 1.1);
            _movingCell.alpha = 0.5;
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(willDraggingItemWithIndexPath:layout:)]) {
            [self.delegate willDraggingItemWithIndexPath:_startIndexPath layout:self];
        }
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        // 拖动
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDraggingItemWithIndexPath:layout:)]) {
            [self.delegate didDraggingItemWithIndexPath:_startIndexPath layout:self];
        }
        
        _movingCell.center = CGPointMake(point.x - _spacingX, point.y - _spacingY);

        _endIndexPath = [self.collectionView indexPathForItemAtPoint:_movingCell.center];

        
        
        NSLog(@"section %ld row %ld",_endIndexPath.section ,_endIndexPath.row);
        if (!_endIndexPath) {
            _endIndexPath = _startIndexPath;
        }


        
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:_endIndexPath];
        [self.collectionView performBatchUpdates:^{
            
            
            [self.collectionView moveItemAtIndexPath:_startIndexPath toIndexPath:_endIndexPath];
            
 
        } completion:nil];
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
//            [self.collectionView moveItemAtIndexPath:_startIndexPath toIndexPath:_endIndexPath];
            
        }];
        
       
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        // 拖动结束
        if (self.delegate && [self.delegate respondsToSelector:@selector(endDraggingItemWithIndexPath:layout:)]) {
            [self.delegate endDraggingItemWithIndexPath:_endIndexPath layout:self];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            _movingCell.center = _originalPoint;
            _movingCell.transform = CGAffineTransformMakeScale(1, 1);
            _movingCell.alpha = 1.0;
        }];
    }
}


@end
