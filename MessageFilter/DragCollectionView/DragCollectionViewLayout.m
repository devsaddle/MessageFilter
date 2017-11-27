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
@property (nonatomic, strong)NSIndexPath *indexPath;

- (instancetype)initViewWithCell:(UICollectionViewCell *)cell;

@end

@interface DragCollectionViewLayout()<UIGestureRecognizerDelegate>

@property (nonatomic, assign)CGFloat spacingX;
@property (nonatomic, assign)CGFloat spacingY;
@property (nonatomic, assign)CGPoint originalPoint;

@property (nonatomic, strong)NSIndexPath *atIndexPath;
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

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.indexPath isEqual:_cellTempView.indexPath]) {
            obj.alpha = 0;
        }
    }];
    
    return attributes;
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
    longGesture.delegate = self;
    [self.collectionView setGestureRecognizers:@[longGesture]];
    
}

- (void)langGesture:(UILongPressGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self.collectionView];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
       // 开始拖动
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        UICollectionViewCell *cell  = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(willDraggingItemWithIndexPath:layout:)]) {
            [self.delegate willDraggingItemWithIndexPath:indexPath layout:self];
        }
        
        _atIndexPath = indexPath;
        _originalPoint = cell.center;
        _spacingX = point.x - _originalPoint.x;
        _spacingY = point.y - _originalPoint.y;
        
        _cellTempView = [[CellTempView alloc] initViewWithCell:cell];
        _cellTempView.indexPath = indexPath;
        [self.collectionView addSubview:_cellTempView];
        
        [self invalidateLayout];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        // 拖动
        _cellTempView.center = [self dragOrientationForPoint:point];
        [self invalidateLayout];

        [self moveItem];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        // 拖动结束
        if (self.delegate && [self.delegate respondsToSelector:@selector(endDraggingAtIndexPath:toIndexPath:layout:)]) {
            [self.delegate endDraggingAtIndexPath:_atIndexPath toIndexPath:_toIndexPath layout:self];
        }
        [UIView animateWithDuration:0.3 animations:^{
            _cellTempView.center = _originalPoint;
            _cellTempView.transform = CGAffineTransformMakeScale(1, 1);
            [_cellTempView removeFromSuperview];
            _cellTempView = nil;
        }];
        [self invalidateLayout];

    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    CGPoint point = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (self.delegate && [self.delegate respondsToSelector:@selector(canMoveItemAtIndexPath:layout:)]) {
       return [self.delegate canMoveItemAtIndexPath:indexPath layout:self];
    }
    return YES;
    
}

- (void)moveItem {
    
    NSIndexPath *atIndexPath = _cellTempView.indexPath;
    NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:_cellTempView.center];
    
    if (toIndexPath == nil || atIndexPath == nil) {
        return;
    }
    
    if ([atIndexPath isEqual:toIndexPath]) {
        return;
    }
    
    if ([toIndexPath isEqual:_toIndexPath]) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(canMoveToIndexPath:layout:)]) {
        BOOL canMove = [self.delegate canMoveToIndexPath:toIndexPath layout:self];
        if (!canMove) {
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(willMoveItemAtIndexPath:toIndexPath:layout:)]) {
        [self.delegate willMoveItemAtIndexPath:atIndexPath toIndexPath:toIndexPath layout:self];
    }
    
    _toIndexPath = toIndexPath;
    [self.collectionView performBatchUpdates:^{
        
        _cellTempView.indexPath = toIndexPath;
        [self.collectionView moveItemAtIndexPath:atIndexPath toIndexPath:toIndexPath];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didMoveItemAtIndexPath:toIndexPath:layout:)]) {
            [self.delegate didMoveItemAtIndexPath:atIndexPath toIndexPath:toIndexPath layout:self];
        }
        
    } completion:nil];
    
}


- (CGPoint)dragOrientationForPoint:(CGPoint)point {
    switch (self.dragOrientation) {
        case DragOrientationALL:
            return CGPointMake(point.x - _spacingX, point.y - _spacingY);
            break;
        case DragOrientationHorizontal:
            return CGPointMake(point.x - _spacingX, _originalPoint.y );
            break;
        case DragOrientationVertical:
            return CGPointMake(_originalPoint.x, point.y - _spacingY);
            break;
        default:
            break;
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
