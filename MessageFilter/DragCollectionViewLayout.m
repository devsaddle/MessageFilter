//
//  DragCollectionViewLayout.m
//  MessageFilter
//
//  Created by 马远 on 2017/11/13.
//  Copyright © 2017年 马远. All rights reserved.
//

#import "DragCollectionViewLayout.h"

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
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"%@   %@",NSStringFromCGPoint(cell.center),NSStringFromCGPoint(point));
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(willDraggingItemWithIndexPath:layout:)]) {
            [self.delegate willDraggingItemWithIndexPath:indexPath layout:self];
        }
        CGPoint centerPoint = cell.center;
        
        CGFloat spacingX = point.x - centerPoint.x;
        CGFloat spacingY = point.y - centerPoint.y;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.collectionView bringSubviewToFront:cell];
            cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
            cell.alpha = 0.5;
        }];
//        cgf originIndex = [self.collectionView indexPathForCell:cell];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDraggingItemWithIndexPath:layout:)]) {
            [self.delegate didDraggingItemWithIndexPath:indexPath layout:self];
        }
        
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(endDraggingItemWithIndexPath:layout:)]) {
            [self.delegate endDraggingItemWithIndexPath:indexPath layout:self];
        }
        
        
    }
}


@end
