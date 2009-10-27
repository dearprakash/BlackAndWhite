//
//  Settings.h
//  greyscale
//
//  Created by Geoffrey Clements on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DEFAULT_RED_FACTOR_VALUE 0.59
#define DEFAULT_GREEN_FACTOR_VALUE 0.3
#define DEFAULT_BLUE_FACTOR_VALUE 0.11
#define DEFAULT_GRAIN_FACTOR_VALUE 0.0


@interface Settings : NSObject {
  CGFloat redSetting;
  CGFloat greenSetting;
  CGFloat blueSetting;
  CGFloat grainSetting;

}

@property (nonatomic, assign) CGFloat redSetting;
@property (nonatomic, assign) CGFloat greenSetting;
@property (nonatomic, assign) CGFloat blueSetting;
@property (nonatomic, assign) CGFloat grainSetting;

-(id)init;

-(NSNumber *)redSettingNumber;
-(NSNumber *)greenSettingNumber;
-(NSNumber *)blueSettingNumber;
-(NSNumber *)grainSettingNumber;

-(void)revertToDefaults;

-(NSString*)description;

@end
