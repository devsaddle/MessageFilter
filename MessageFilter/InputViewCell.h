//
//  InputViewCell.h
//  MessageFilter
//
//  Created by 马远 on 2017/10/17.
//  Copyright © 2017年 马远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

- (void)setTitle:(NSString *)title;
- (void)setText:(NSString *)text;
- (void)setPlacegolderText:(NSString *)text;
- (void)inputEnable:(BOOL)enable;
- (void)ruleDic:(NSMutableDictionary *)dic;
- (void)textEditEnd:(void(^)(NSString *text))completed;
@end
