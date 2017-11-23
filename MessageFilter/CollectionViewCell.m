//
//  CollectionViewCell.m
//  MessageFilter
//
//  Created by 马远 on 2017/10/2.
//  Copyright © 2017年 马远. All rights reserved.
//

#import "CollectionViewCell.h"
#import "RegularExpression.h"

@interface CollectionViewCell()

/** Title Label */
@property (nonatomic, strong) UILabel *titleLabel;
/** Type Label */
@property (nonatomic, strong) UILabel *typeLabel;
/** Rule Label */
@property (nonatomic, strong) UILabel *ruleLabel;

@property (nonatomic, strong) CALayer *shadowLayer;

@end

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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setViewsLayout];
}

#pragma mark - Init View
- (void) initViews {

    self.contentView.layer.cornerRadius = 2;
    self.contentView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeZero;
    self.contentView.layer.shadowOpacity = 1;
    self.contentView.layer.shadowRadius = 3;
    self.contentView.layer.masksToBounds = NO;
    self.layer.masksToBounds = NO;
    
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.ruleLabel];
}

- (void)setViewsLayout {
    CGFloat width = self.frame.size.width;
    self.titleLabel.frame = CGRectMake(10, 10, width - 20, 19);
    self.typeLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 10, width - 20, 16);
    self.ruleLabel.frame = CGRectMake(10, CGRectGetMaxY(self.typeLabel.frame) + 5, width - 20, 15);
    self.shadowLayer.frame = self.bounds;
}


- (void)setRuleData:(NSDictionary *)ruleData {
    _ruleData = ruleData;
    self.titleLabel.text = [ruleData valueForKey:@"name"];
    self.typeLabel.text = typeName([ruleData valueForKey:@"type"]);
    NSString *rule = @"";
    for (NSString *ruleStr in [ruleData valueForKey:@"rules"] ) {
        rule = [[rule stringByAppendingString:ruleStr] stringByAppendingString:@","];
        
    }

    self.ruleLabel.text = rule;
}

#pragma mark - Lazy Load
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];

//        _titleLabel.backgroundColor = [UIColor redColor];
    }
    return _titleLabel;
}

- (UILabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = [UIFont systemFontOfSize:15];
        _typeLabel.textColor = [UIColor colorWithRed:112/255 green:112/255 blue:112/255 alpha:1];
//        _typeLabel.backgroundColor = [UIColor blueColor];
    }
    return _typeLabel;
}

- (UILabel *)ruleLabel {
    if (_ruleLabel == nil) {
        _ruleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _ruleLabel.numberOfLines = 1;
        _ruleLabel.textAlignment = NSTextAlignmentLeft;
        _ruleLabel.font = [UIFont systemFontOfSize:14];
        _ruleLabel.textColor = [UIColor colorWithRed:112/255 green:112/255 blue:112/255 alpha:1];
//        _ruleLabel.backgroundColor = [UIColor yellowColor];
    }
    return _ruleLabel;
}
@end
