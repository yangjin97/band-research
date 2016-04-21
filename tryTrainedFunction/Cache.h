//
//  Cache.h
//  tryTrainedFunction
//
//  Created by Harry on 3/31/16.
//  Copyright © 2016 Yang Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"


@interface Cache : NSObject
{
    trial** pool;
    
    int front,back;
    
    long long lastTime;
    
}

-(void)insert:(trial*)t;

-(sample*)getSample:(long long)beginTime;

-(int)countElement;

-(sample*)retrieveData:(long long) begintime r:(long long)retriveTime;


@end
