//
//  TrochilusMessageObject.m
//  Trochilus
//
//  Created by 王权伟 on 2018/7/3.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "TrochilusMessageObject.h"

@implementation TrochilusMessageObject

+ (instancetype)messageObject {
    
    return [[TrochilusMessageObject alloc] init];
}

- (BOOL)isEmptyWithContentType:(TrochilusContentType)contentType {
    
    //文本
    if (contentType == TrochilusContentTypeText && (self.title == nil || self.text == nil)) {
        return YES;
    }
    else if (contentType == TrochilusContentTypeImage && self.image == nil) {
        return YES;
    }
    else if (contentType == TrochilusContentTypeWebPage && self.url == nil) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isNotEmpty:(NSArray*)attributes {
    return YES;
}

- (NSString *)title {
    return _title == nil ? @"" : _title;
}

- (NSString *)text {
    return _text == nil ? @"" : _text;
}

@end
