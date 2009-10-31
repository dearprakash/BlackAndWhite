//
//  Settings.m
//  greyscale
//
// Copyright (c) 2009 Geoffrey Clements
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
