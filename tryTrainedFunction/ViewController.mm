//
//  ViewController.m
//  tryTrainedFunction
//
//  Created by Yang Jin on 3/4/16.
//  Copyright © 2016 Yang Jin. All rights reserved.
//

#import "ViewController.h"
#import "Parser.h"
#import "getMove.hpp"

#define ADMIT 0.65
@interface ViewController ()<MSBClientManagerDelegate, UITextViewDelegate>
@property (nonatomic, weak) MSBClient *client;
@end

@implementation ViewController


-(void)createFile:(NSString *)filename{
    NSString * filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createFileAtPath:filePath contents:nil attributes:nil];
}

-(void)setUpFiles{
    
    
    [self createFile:@"do.txt"];
    [self createFile:@"nothing.txt"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self markSampleReady:NO];
    self.txtOutput.delegate = self;
    [MSBClientManager sharedManager].delegate = self;
    NSArray	*clients = [[MSBClientManager sharedManager] attachedClients];
    self.client = [clients firstObject];
    if (self.client == nil)
    {
        [self output:@"Failed! No Bands attached."];
        return;
    }
    [[MSBClientManager sharedManager] connectClient:self.client];
    [self output:[NSString stringWithFormat:@"Please wait. Connecting to Band <%@>", self.client.name]];
    
    myCache = [[Cache alloc]init];
    turnedOn = 0;
    [self setUpFiles];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(long long)getFormattedTime{
    return (long long)([[NSDate date] timeIntervalSince1970] * 1000);
}

-(void)detectBehavior{
    sample* res =[myCache getSample:((long long)([[NSDate date] timeIntervalSince1970] * 1000)-2000)];
    if(res == NULL)return;
    
    
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"saved_virginica" ofType:@"txt"];
    double result = getMove([Parser parse:res],[filepath UTF8String]);
    
    NSString * output;
    if(result>4)output=@"La";
    else output = @"";
    
    self.txtField.text = output;
    
    if(result>ADMIT)NSLog([NSString stringWithFormat:@"Punched!,%f",result]);
   

}



-(NSString *)getContent:(NSString *)filename {
    NSString * filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent: filename];
    return [NSString stringWithContentsOfFile:filePath encoding:NSStringEncodingConversionAllowLossy error:nil];
}

-(void)writeContent:(NSString *)content :(NSString *)filename{
    
    NSString * filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent: filename];
    
    NSString * previous = [self getContent:filename];
    
    content = [previous stringByAppendingString:content];
    
    [content writeToFile: filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

-(void)getTrainning{
    if (turnedOn==0 )return;
    if (turnedOn==1 ){
        sample* res = [myCache retrieveData:turnedTime r:turnedTime+1000];
        if(res!=NULL){
            
            
            NSString* newthing = [Parser translate:[Parser parse:res]];
            
            newthing = [newthing stringByAppendingString:@" 1 \n\n"];
            
            [self writeContent:newthing :@"do.txt" ];
            
            turnedOn=0;
            
            [self switchCollectingButtons:true];
            
            
            
        }
    }
    
    if (turnedOn==2 ){
        sample* res = [myCache retrieveData:turnedTime r:turnedTime+1000];
        if(res!=NULL){
            
            
            NSString* newthing = [Parser translate:[Parser parse:res]];
            
            newthing = [newthing stringByAppendingString:@" -1 \n\n"];
            
            [self writeContent:newthing :@"do.txt" ];
            
            turnedOn=0;
            
            [self switchCollectingButtons:true];

            
            
        }
    }
    
}

- (IBAction)startPressed:(UIButton *)sender {
    [self markSampleReady:false];
    [self output:@"Starting to collect data..."];
    
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(detectBehavior) userInfo:nil repeats:true];
    
    void (^handler)(MSBSensorGyroscopeData *, NSError *) = ^(MSBSensorGyroscopeData *gyroscopeData, NSError *error)
    {
        trial* temp = (trial*) malloc(sizeof(trial));
        temp->x = gyroscopeData.x;
        temp->y = gyroscopeData.y;
        temp->z = gyroscopeData.z;
        temp->time = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
        
        [myCache insert:temp];
        [self getTrainning];
    };
         
    NSError *stateError;
    if (![self.client.sensorManager startGyroscopeUpdatesToQueue:nil errorRef:&stateError withHandler:handler])
    {
        [self markSampleReady:true];
        [self sampleDidCompleteWithOutput:stateError.description];
        return;
    }
         
}


- (void)sampleDidCompleteWithOutput:(NSString *)output
{
    [self output:output];
    [self markSampleReady:YES];
}


- (void)markSampleReady:(BOOL)ready
{
    self.startButton.enabled = ready;
    self.startButton.alpha = ready ? 1.0 : 0.2;
}


- (void)output:(NSString *)message
{
    if (message)
    {
        self.txtOutput.text = [NSString stringWithFormat:@"%@\n%@", self.txtOutput.text, message];
        [self.txtOutput layoutIfNeeded];
        if (self.txtOutput.text.length > 0)
        {
            [self.txtOutput scrollRangeToVisible:NSMakeRange(self.txtOutput.text.length - 1, 1)];
        }
    }
}
- (void)clientManager:(MSBClientManager *)clientManager clientDidConnect:(MSBClient *)client
{
    [self markSampleReady:YES];
    [self output:[NSString stringWithFormat:@"Band <%@> connected.", client.name]];
}

- (void)clientManager:(MSBClientManager *)clientManager clientDidDisconnect:(MSBClient *)client
{
    [self markSampleReady:NO];
    [self output:[NSString stringWithFormat:@"Band <%@> disconnected.", client.name]];
}

- (void)clientManager:(MSBClientManager *)clientManager client:(MSBClient *)client didFailToConnectWithError:(NSError *)error
{
    [self output:[NSString stringWithFormat:@"Failed to connect to Band <%@>.", client.name]];
    [self output:error.description];
}

-(void)pressDo:(id)sender{
    
    NSLog(@"la");
    turnedOn = 1;
    
    turnedTime = [self getFormattedTime];
    [self switchCollectingButtons:false];
    
}

-(void)pressNothing:(id)sender{
    
    NSLog(@"ba");
    turnedOn = 2;
    
    turnedTime = [self getFormattedTime];
    [self switchCollectingButtons:false];

    
}

-(void)switchCollectingButtons:(bool)enabled{
    if (enabled){
        self.doButton.alpha = 1.0;
        self.doButton.enabled = true;
        self.nothingButton.alpha = 1.0;
        self.nothingButton.enabled = true;
    }
    else{
        self.doButton.alpha = 0.2;
        self.doButton.enabled = false;
        self.nothingButton.alpha = 0.2;
        self.nothingButton.enabled = false;
    }
}

@end
