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
@property (nonatomic, strong)UILabel *textFiledLeftView;
@property (nonatomic, strong)NSMutableDictionary *ruleDic;
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
    self.textFiledLeftView.frame = CGRectMake(0, 0, 60, self.contentView.bounds.size.height );
}

#pragma mark -

- (void)setTitle:(NSString *)title {
    self.textFiledLeftView.text = title;
}
- (void)setText:(NSString *)text {
    self.textFiled.text = text;
}
- (void)inputEnable:(BOOL)enable {
    self.textFiled.userInteractionEnabled = enable;
}
- (void)setPlacegolderText:(NSString *)text {
    self.textFiled.placeholder = text;
}

- (void)ruleDic:(NSMutableDictionary *)dic {
    self.ruleDic = dic;
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if ([self.textFiledLeftView.text isEqualToString:@"标签"]) {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    return YES;
}
#pragma mark - Lazy Load
- (UITextField *)textFiled {
    if (_textFiled == nil) {
        _textFiled = [[UITextField alloc] initWithFrame:CGRectZero];
        _textFiled.textAlignment = NSTextAlignmentLeft;
        _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFiled.placeholder = @"输入内容";
        _textFiled.returnKeyType = UIReturnKeyDone;
        _textFiled.delegate = self;
        _textFiled.leftView = self.textFiledLeftView;
        _textFiled.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textFiled;
    
}

- (UILabel *)textFiledLeftView {
    if (_textFiledLeftView == nil) {
        _textFiledLeftView = [[UILabel alloc] initWithFrame:CGRectZero];
        _textFiledLeftView.font = [UIFont systemFontOfSize:16];
        _textFiledLeftView.textColor = [UIColor darkGrayColor];
        _textFiledLeftView.textAlignment = NSTextAlignmentCenter;
    }
    return _textFiledLeftView;
}
@end
