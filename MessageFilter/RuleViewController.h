//
//  RuleViewController.h
//  MessageFilter
//
//  Created by 马远 on 2017/10/17.
//  Copyright © 2017年 马远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuleViewController : UIViewController

@property(nonatomic, assign)NSUInteger index;

- (void)ruleData:(NSDictionary *)ruleDic;
- (void)deleteCompletion:(void (^)(NSUInteger index))completion;
@end
