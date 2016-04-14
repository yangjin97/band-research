//
//  Parser.h
//  Normalize
//
//  Created by Harry on 2/25/16.
//  Copyright © 2016 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct trial{
    
    double x;
    double y;
    double z;
    long long time;
    
} trial;

typedef struct sample{
    int size;
    long long startTime;
    trial* data;
}sample;


@interface Parser : NSObject



+(double*)parse:(sample*)input;
+(NSString*)translate:(double*)input;

@end
