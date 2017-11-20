//
//  DragCollectionViewLayout.m
//  MessageFilter
//
//  Created by 马远 on 2017/11/13.
//  Copyright © 2017年 马远. All rights reserved.
//

#import "DragCollectionViewLayout.h"
@interface CellTempView : UIView

@property (nonatomic, strong)UICollectionViewCell *cell;
@property (nonatomic, strong)UIImageView *cellScreenshotImageView;
- (instancetype)initViewWithCell:(UICollectionViewCell *)cell;

@end

@interface DragCollectionViewLayout()

@property (nonatomic, assign)CGFloat spacingX;
@property (nonatomic, assign)CGFloat spacingY;
@property (nonatomic, assign)CGPoint originalPoint;

@property (nonatomic, strong)NSIndexPath *startIndexPath;
@property (nonatomic, strong)NSIndexPath *toIndexPath;

@property (nonatomic, strong)CellTempView *cellTempView;

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
        UICollectionViewCell *cell  = [self.collectionView cellForItemAtIndexPath:_startIndexPath];
        _originalPoint = cell.center;
        _spacingX = point.x - _originalPoint.x;
        _spacingY = point.y - _originalPoint.y;
        
        _cellTempView = [[CellTempView alloc] initViewWithCell:cell];
        [self.collectionView addSubview:_cellTempView];
        
//        [UIView animateWithDuration:0.3 animations:^{
        
//            [self.collectionView bringSubviewToFront:_movingCell];
//            _movingCell.transform = CGAffineTransformMakeScale(1.1, 1.1);
//            _movingCell.alpha = 0.5;
//        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(willDraggingItemWithIndexPath:layout:)]) {
            [self.delegate willDraggingItemWithIndexPath:_startIndexPath layout:self];
        }
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        // 拖动
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDraggingItemWithIndexPath:layout:)]) {
            [self.delegate didDraggingItemWithIndexPath:_startIndexPath layout:self];
        }
        
        _cellTempView.center = CGPointMake(point.x - _spacingX, point.y - _spacingY);
            [self invalidateLayout];

//        NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:_movingCell.center];

        
//
//        NSLog(@"section %ld row %ld",toIndexPath.section ,toIndexPath.row);
//        if (toIndexPath == nil || _startIndexPath  == nil) {
//            return;
//        }
//
//        if ([_startIndexPath isEqual:toIndexPath]) {
//            return;
//        }
//
//        if ([toIndexPath isEqual:_toIndexPath]) {
//            return;
//        }
//
//        _toIndexPath = toIndexPath;
//
//        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:_toIndexPath];
//        [self.collectionView performBatchUpdates:^{
//
//
//            [self.collectionView moveItemAtIndexPath:_startIndexPath toIndexPath:_toIndexPath];
//            [self invalidateLayout];
//
//        } completion:nil];
        
        

       
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        // 拖动结束
        if (self.delegate && [self.delegate respondsToSelector:@selector(endDraggingItemWithIndexPath:layout:)]) {
            [self.delegate endDraggingItemWithIndexPath:_toIndexPath layout:self];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            _cellTempView.center = _originalPoint;
            _cellTempView.transform = CGAffineTransformMakeScale(1, 1);
            [_cellTempView removeFromSuperview];
        }];
    }
}




@end


@implementation CellTempView

- (instancetype)initViewWithCell:(UICollectionViewCell *)cell {
    self = [super initWithFrame:cell.frame];
     if (self) {
         self.layer.cornerRadius = 2;
         self.layer.backgroundColor = [UIColor whiteColor].CGColor;
         self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
         self.layer.shadowOffset = CGSizeZero;
         self.layer.shadowOpacity = 1;
         self.layer.shadowRadius = 3;
         self.layer.masksToBounds = NO;
         self.alpha = 0.8;
         self.transform = CGAffineTransformMakeScale(1.1, 1.1);

         
         self.cell = cell;
         self.cellScreenshotImageView = [[UIImageView alloc] initWithFrame:self.bounds];
         self.cellScreenshotImageView.contentMode = UIViewContentModeScaleAspectFill;
         self.cellScreenshotImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
         self.cellScreenshotImageView.image = [self screenshotForView:cell];
         [self addSubview:self.cellScreenshotImageView];
     }
     return self;
}

- (UIImage *)screenshotForView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
