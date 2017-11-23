//
//  RegularExpression.h
//  MessageFilter
//
//  Created by 马远 on 2017/10/31.
//  Copyright © 2017年 马远. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 匹配字符串

 @param rule 规则、正则表达式
 @param string 要匹配的字符串
 @return 匹配到的数量  -1 表达式错误
 */
NSInteger countOfMatchesInString(NSString *rule, NSString *string);

/**
 UserDefault
 */
NSUserDefaults *userDefault(void);

/**
 UserDefault中的规则数据
 */
NSArray *messageFilterData(void);

/**
 保存数据到 UserDefault
 */
void savaToUserDefault(NSArray *filterArray);

/**
 根据 type 类型返回对应的描述

 @param type 类型 1-4
 @return 描述
 */
NSString *typeName(NSString *type);


/**
 添加一条规则

 @param rule 规则
 */
void addOneRule(NSDictionary *rule);


/**
 更新UserDefault中的数据

 @param data 更新的数据
 */
void updateUserDefaultData(NSDictionary *data, NSUInteger index);

NSInteger typeOfRule(NSDictionary *rule);
