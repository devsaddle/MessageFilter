//
//  RegularExpression.h
//  MessageFilter
//
//  Created by 马远 on 2017/10/31.
//  Copyright © 2017年 马远. All rights reserved.
//

#import <Foundation/Foundation.h>

NSInteger countOfMatchesInString(NSString *string, NSString *matchString);

NSArray *messageFilterData();

NSString *typeName(NSString *type);

void addOneRule(NSDictionary *rule);
