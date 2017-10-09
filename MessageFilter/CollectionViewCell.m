//
//  CollectionViewCell.m
//  MessageFilter
//
//  Created by 马远 on 2017/10/2.
//  Copyright © 2017年 马远. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

+ (instancetype)collectionViewCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterRuleIdentifiter" forIndexPath:indexPath];
    return cell;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

#pragma mark - Init View
- (void) initViews {
    self.backgroundColor = [UIColor blueColor];
}
@end
