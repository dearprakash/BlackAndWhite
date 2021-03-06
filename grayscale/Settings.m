//
//  Settings.m
//  greyscale
//
// Copyright (c) 2009-2010 Geoffrey Clements
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

static CGFloat clamp(CGFloat val, CGFloat lower, CGFloat upper) {
  if (val > upper) return upper;
  if (val < lower) return lower;
  return val;
}

@implementation Settings

@synthesize redSetting;
@synthesize greenSetting;
@synthesize blueSetting;
@synthesize grainSetting;
@synthesize sepiaSetting;
@synthesize contrastSetting;
@synthesize brightnessSetting;

-(void)validate
{
  redSetting = clamp(redSetting, 0.0, 1.0);
  greenSetting = clamp(greenSetting, 0.0, 1.0);
  blueSetting = clamp(blueSetting, 0.0, 1.0);
  grainSetting = clamp(grainSetting, 0.0, 1.0);
  sepiaSetting = clamp(sepiaSetting, 0.0, 1.0);
  contrastSetting = clamp(contrastSetting, -1.0, 1.0);
  brightnessSetting = clamp(brightnessSetting, -1.0, 1.0);
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

-(NSNumber *)contrastSettingNumber;
{
  return [NSNumber numberWithFloat:contrastSetting];
}

-(NSNumber *)brightnessSettingNumber;
{
  return [NSNumber numberWithFloat:brightnessSetting];
}

-(void)revertToDefaults
{
  redSetting = DEFAULT_RED_FACTOR_VALUE;
  greenSetting = DEFAULT_GREEN_FACTOR_VALUE;
  blueSetting = DEFAULT_BLUE_FACTOR_VALUE;
  grainSetting = DEFAULT_GRAIN_FACTOR_VALUE;
  sepiaSetting = DEFAULT_SEPIA_FACTOR_VALUE;
  contrastSetting = DEFAULT_CONTRAST_FACTOR_VALUE;
  brightnessSetting = DEFAULT_BRIGHTNESS_FACTOR_VALUE;
}

-(NSString*)description;
{
  return [NSString stringWithFormat:@"<Settings: red: %.4f green: %.4f blue: %.4f grain: %f sepia: %f contrast: %f brightness: %f>", redSetting, greenSetting, blueSetting, grainSetting, sepiaSetting, contrastSetting, brightnessSetting];
}

@end
