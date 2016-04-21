//
//  ViewController.h
//  tryTrainedFunction
//
//  Created by Yang Jin on 3/4/16.
//  Copyright © 2016 Yang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MicrosoftBandKit_iOS/MicrosoftBandKit_iOS.h>
#import "Parser.h"
#import "Cache.h"

@interface ViewController : UIViewController {
    
    Cache* myCache;
    
    int turnedOn;
    
    long long turnedTime;
    
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIButton *doButton;
@property (weak, nonatomic) IBOutlet UIButton *nothingButton;


@property (weak, nonatomic) IBOutlet UITextView *txtOutput;

@property (weak, nonatomic) IBOutlet UITextField *txtField;
- (IBAction)startPressed:(UIButton *)sender;

-(IBAction)pressDo:(id)sender;
-(IBAction)pressNothing:(id)sender;



@end

