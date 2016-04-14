//
//  Cache.m
//  tryTrainedFunction
//
//  Created by Harry on 3/31/16.
//  Copyright © 2016 Yang Jin. All rights reserved.
//

#import "Cache.h"

#define MAXN 1010

#define LENGTH 1000

@implementation Cache

- (id)init {
    self = [super init];
    if (self) {
        
        
        
        pool = malloc((MAXN)*sizeof(trial*));
        
        front = 0;
        back = 0;
        lastTime = 0;
        
        
        
    }
    return self;
}

int forward(int k){
    k++;
    if(k==MAXN)return 0;
    else return k;
}

-(int)countElement{
    return (back+MAXN-front)%MAXN;
}

-(int)countElementFrom:(int)start{
    return (back+MAXN-start)%MAXN;
}



-(void)insert:(trial*)t{
    pool[back]=t;
    back = forward(back);
    lastTime = t->time;
}

-(sample*)retrieveData:(long long)begintime r:(long long)retriveTime{
    
    if(lastTime<=retriveTime){
        return NULL;
    }
    
    sample* res = malloc(sizeof(sample));
    
    
    int po = front;
    
    while([self countElementFrom:po]>1 && pool[forward(po)]->time < begintime)po = forward(po);
   
    res->startTime = begintime;
    res->size = [self countElementFrom:po];
    res->data = malloc((res->size)*sizeof(trial));
    
    
    int t = 0;
    
    while(po!=back){
        res->data[t] = *pool[po];
        t ++;
        po = forward(po);
    }
    
    

    NSLog(@"Returned Some Data!");
    
    return res;

}



-(sample*)getSample:(long long)beginTime{
    
    if(lastTime == 0 ||  beginTime<=pool[front]->time || beginTime+LENGTH>lastTime){
        return NULL;
    }
    
    while(pool[forward(front)]->time < beginTime)front = forward(front);
    
    
    sample* res = malloc(sizeof(sample));
    res->startTime = beginTime;
    res->size = [self countElement];
    res->data = malloc((res->size)*sizeof(trial));
    
    int po = front, t = 0;
    while(po!=back){
        res->data[t] = *pool[po];
        t++;
        po = forward(po);
    }
    
    return res;
}
@end
