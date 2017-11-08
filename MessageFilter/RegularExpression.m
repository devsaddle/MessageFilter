//
//  RegularExpression.m
//  MessageFilter
//
//  Created by 马远 on 2017/10/31.
//  Copyright © 2017年 马远. All rights reserved.
//

#import "RegularExpression.h"

#define USER_DEFAULT_MESSAGEFILTER_RULE @"MessageFilterData"
#define USER_DEFAULT_SUITE_NAME @"group.yuan.messagefilter"

NSInteger countOfMatchesInString(NSString *rule, NSString *string) {
    
    NSError *error;
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:rule options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) return -1;
    NSInteger count = [regular numberOfMatchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    return count;
}


NSUserDefaults *userDefault() {
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:USER_DEFAULT_SUITE_NAME];
    return userDefault;
    
}

//    @{@"type":@"1", // 1 关键词过滤 2 号码过滤 3 正则过滤内容 4 正则过滤号码
//      @"name":@"名称", // 标签
//      @"rules":@[@"word1",@"word2",@"word3"], // 关键词\号码数组\正则表达式};  

NSArray *messageFilterData(void) {
    if ([userDefault() objectForKey:@"MessageFilterData"]) {
        return [userDefault() objectForKey:@"MessageFilterData"];
    }
    
    NSArray *messageFilterData = @[@{@"type":@"1",
                                     @"name":@"关键词过滤",
                                     @"rules":@[@"退订",@"回T",@"复T",@"百度",@"搜狐"]},
                                   
                                   @{@"type":@"2",
                                     @"name":@"号码过滤",
                                     @"rules":@[@"10086",@"10655024113090",]},
                                   
                                   @{@"type":@"3",
                                     @"name":@"正则内容过滤",
                                     @"rules":@[@"word1"]},
                                   
                                   @{@"type":@"4",
                                     @"name":@"正则号码过滤",
                                     @"rules":@[@"code2"]}];
    [userDefault() setObject:messageFilterData forKey:USER_DEFAULT_MESSAGEFILTER_RULE];
    
    return messageFilterData;
}
    


NSString *typeName(NSString *type) {
    NSDictionary *typeMap =
    @{@"1":@"关键词过滤",
      @"2":@"号码过滤",
      @"3":@"正则过滤内容",
      @"4":@"正则过滤号码"
      };
    if (type && [typeMap objectForKey:type]) {
        return typeMap[type];
    }
    return @"";
}


NSInteger typeOfRule(NSDictionary *rule) {
    
    if ([rule objectForKey:@"type"]) {
        return [[rule objectForKey:@"type"] integerValue];
    }
    return 0;
}

void addOneRule(NSDictionary *rule) {
    if (rule && rule.count > 0) {
       NSArray *ruleData = [messageFilterData() arrayByAddingObject:rule];
        [userDefault() setObject:ruleData forKey:USER_DEFAULT_MESSAGEFILTER_RULE];
    }
}


void updateUserDefaultData(NSDictionary *data, NSUInteger index) {

    NSMutableArray *rule = [NSMutableArray arrayWithArray:messageFilterData()];
    rule[index] = data;
    [userDefault() setObject:rule forKey:USER_DEFAULT_MESSAGEFILTER_RULE];
}

