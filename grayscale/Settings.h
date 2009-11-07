//
//  Settings.h
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

#import <Cocoa/Cocoa.h>

#define DEFAULT_RED_FACTOR_VALUE 0.59
#define DEFAULT_GREEN_FACTOR_VALUE 0.3
#define DEFAULT_BLUE_FACTOR_VALUE 0.11
#define DEFAULT_GRAIN_FACTOR_VALUE 0.0
#define DEFAULT_SEPIA_FACTOR_VALUE 0.0


@interface Settings : NSObject {
  CGFloat redSetting;
  CGFloat greenSetting;
  CGFloat blueSetting;
  CGFloat grainSetting;
  CGFloat sepiaSetting;
}

@property (nonatomic, assign) CGFloat redSetting;
@property (nonatomic, assign) CGFloat greenSetting;
@property (nonatomic, assign) CGFloat blueSetting;
@property (nonatomic, assign) CGFloat grainSetting;
@property (nonatomic, assign) CGFloat sepiaSetting;

-(id)init;

-(NSNumber *)redSettingNumber;
-(NSNumber *)greenSettingNumber;
-(NSNumber *)blueSettingNumber;
-(NSNumber *)grainSettingNumber;
-(NSNumber *)sepiaSettingNumber;

-(void)revertToDefaults;

-(NSString*)description;

@end
