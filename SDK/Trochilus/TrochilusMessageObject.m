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

- (void)setImage:(id)image {
    
    if ([image isKindOfClass:[NSURL class]]) {
        
        [self downloadImageWithUrl:image];
        
    }
    else if ([image isKindOfClass:[NSString class]]) {
        
    }
    else if ([image isKindOfClass:[UIImage class]]) {
        _image = image;
    }
    
}

- (void)downloadImageWithUrl:(NSURL *)url {
    
    
}

@end
