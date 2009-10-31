//
//  Settings.m
//  greyscale
//
//  Created by Geoffrey Clements on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"


@implementation Settings

@synthesize redSetting;
@synthesize greenSetting;
@synthesize blueSetting;
@synthesize grainSetting;
@synthesize sepiaSetting;

-(void)validate
{
  if (redSetting > 1.0) redSetting = 1.0;
  if (greenSetting > 1.0) greenSetting = 1.0;
  if (blueSetting > 1.0) blueSetting = 1.0;
  if (grainSetting > 1.0) grainSetting = 1.0;
  if (sepiaSetting > 1.0) sepiaSetting = 1.0;
  if (redSetting < 0) redSetting = 0.0;
  if (greenSetting < 0) greenSetting = 0.0;
  if (blueSetting < 0) blueSetting = 0.0;
  if (grainSetting < 0) grainSetting = 0.0;
  if (sepiaSetting < 0) sepiaSetting = 0.0;
}

-(void)setRedSetting:(CGFloat)value
{
  redSetting = value;
  CGFloat offset = (1.0-(redSetting+greenSetting+blueSetting))/2.0;
  greenSetting += offset;
  blueSetting += offset;
  [self validate];
}

-(void)setGreenSetting:(CGFloat)value
{
  greenSetting = value;
  CGFloat offset = (1.0-(redSetting+greenSetting+blueSetting))/2.0;
  redSetting += offset;
  blueSetting += offset;
  [self validate];
}

-(void)setBlueSetting:(CGFloat)value
{
  blueSetting = value;
  CGFloat offset = (1.0-(redSetting+greenSetting+blueSetting))/2.0;
  redSetting += offset;
  greenSetting += offset;
  [self validate];
}

-(id)init
{
  if ((self = [super init]) != nil) {
    [self revertToDefaults];
  }
  return self;
}

-(NSNumber *)redSettingNumber
{
  return [NSNumber numberWithFloat:redSetting];
}

-(NSNumber *)greenSettingNumber;
{
  return [NSNumber numberWithFloat:greenSetting];
}

-(NSNumber *)blueSettingNumber;
{
  return [NSNumber numberWithFloat:blueSetting];
}

-(NSNumber *)grainSettingNumber;
{
  return [NSNumber numberWithFloat:grainSetting];
}

-(NSNumber *)sepiaSettingNumber;
{
  return [NSNumber numberWithFloat:sepiaSetting];
}

-(void)revertToDefaults
{
  redSetting = DEFAULT_RED_FACTOR_VALUE;
  greenSetting = DEFAULT_GREEN_FACTOR_VALUE;
  blueSetting = DEFAULT_BLUE_FACTOR_VALUE;
  grainSetting = DEFAULT_GRAIN_FACTOR_VALUE;
  sepiaSetting = DEFAULT_SEPIA_FACTOR_VALUE;
}

-(NSString*)description;
{
  return [NSString stringWithFormat:@"<Settings: red: %.4f green: %.4f blue: %.4f grain: %f sepia: %f>", redSetting, greenSetting, blueSetting, grainSetting, sepiaSetting];
}

@end
