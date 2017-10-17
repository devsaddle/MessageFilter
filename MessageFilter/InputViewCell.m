//
//  InputViewCell.m
//  MessageFilter
//
//  Created by 马远 on 2017/10/17.
//  Copyright © 2017年 马远. All rights reserved.
//

#import "InputViewCell.h"

@interface InputViewCell()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *textFiled;

@end

@implementation InputViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifiler = @"InputTableViewCell";
    InputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiler];
    if (cell == nil) {
        cell = [[InputViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiler];
    }
    return cell;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    [self.contentView addSubview:self.textFiled];
}

- (void)setViewsLayout {
    self.textFiled.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    
}

#pragma mark -
char *charTitle = "标签";

- (void)setData {
    
}
- (void)setTitle:(NSString *)title {
    
    charTitle = [title cStringUsingEncoding:NSUTF8StringEncoding];
    
}
- (void)inputEnable:(BOOL)enable {
    self.textFiled.userInteractionEnabled = enable;
}



#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    
//    return NO;
//}

#pragma mark - Lazy Load
- (UITextField *)textFiled {
    if (_textFiled == nil) {
        _textFiled = [[UITextField alloc] initWithFrame:CGRectZero];
        _textFiled.textAlignment = NSTextAlignmentLeft;
        _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFiled.placeholder = @"测试文字";
        _textFiled.returnKeyType = UIReturnKeyDone;
        _textFiled.delegate = self;

        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        leftLabel.font = [UIFont systemFontOfSize:16];
        leftLabel.textColor = [UIColor darkGrayColor];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = [NSString stringWithCString:charTitle encoding:NSUTF8StringEncoding];
        _textFiled.leftView = leftLabel;
        _textFiled.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textFiled;
    
}
@end
