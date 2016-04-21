//
//  Parser.m
//  Normalize
//
//  Created by Harry on 2/25/16.
//  Copyright © 2016 Harry. All rights reserved.
//

#import "Parser.h"

#define INTERVAL 100
#define DIM 10

@implementation Parser


void setToScale(trial* cur, trial* last, long long time, double* a, double* b, double* c){
    int x = time - last->time;
    int y = cur->time - time;
    
    if(x==0){
        *a = last->x;
        *b = last->y;
        *c = last->z;
        return;
    }
    else if(y==0){
        *a = cur->x;
        *b = cur->y;
        *c = cur->z;
        return;
    }
    
    double ll = ((double)y)/((double)(x+y));
    double rr = ((double)x)/((double)(x+y));
    
 //   printf("%d %d \n",x,y);
    
    *a = last->x * ll + cur->x * rr;
    *b = last->y * ll + cur->y * rr;
    *c = last->z * ll + cur->z * rr;
    
    
}


+(double*)parse:(sample *)input{
    
    
    
    long long start_time = input->startTime;
    
    trial* last_data = NULL;
    
    trial* data = input->data;
    
    int p1 = 0, p2 = 0;
    
    double* result = malloc(4*DIM * sizeof(double));
    
    double* result2 = malloc(4*DIM * sizeof(double));

    
    
  //  NSLog([NSString stringWithFormat:@"%lld\n%lld\n\n",start_time,data[0].time]);

    
    
    for(int i=0; i<DIM; i++){
        while(data[p1].time <= start_time + i*INTERVAL){
            last_data = &data[p1];
            p1++;
        }
        
        setToScale(&data[p1], last_data, start_time + i*INTERVAL, &result[3*i], &result[3*i+1], &result[3*i+2]);
        
    }
    
    
       return result;
}

+(NSString*)translate:(double *)input{
    int len = 30;
    NSString* res = @"";
    for(int i=0; i<len; i++){
        res=[res stringByAppendingString:[NSString stringWithFormat:@"%f ",input[i]]];
    }
    
    return res;
}
@end
