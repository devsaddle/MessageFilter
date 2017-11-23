//
//  CollectionViewCell.h
//  MessageFilter
//
//  Created by 马远 on 2017/10/2.
//  Copyright © 2017年 马远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

+ (instancetype)collectionViewCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong)NSDictionary *ruleData;
@end
