//
//  FullSizeView.m
//  greyscale
//
//  Created by Geoffrey Clements on 10/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FullSizeView.h"


@implementation FullSizeView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {

    // Drawing code here.
	CIImage *image = [_datasource valueForKey:@"outputImage"];
  
	// Draw this into my view.
	CGRect cgRect = image.extent;
  CGSize windowSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
  lastMousePosition.x -= windowSize.width/2.0;
  lastMousePosition.y -= windowSize.height/2.0;
  if (lastMousePosition.x < 0.0) {
    lastMousePosition.x = 0.0;
  }
  if (lastMousePosition.y < 0.0) {
    lastMousePosition.y = 0.0;
  }
  if (cgRect.size.width-lastMousePosition.x < windowSize.width) {
    lastMousePosition.x = cgRect.size.width-windowSize.width;
  }
  if (cgRect.size.height-lastMousePosition.y < windowSize.height) {
    lastMousePosition.y = cgRect.size.height-windowSize.height;
  }
	NSRect imageRect = NSMakeRect(lastMousePosition.x, lastMousePosition.y, windowSize.width, windowSize.height);
	NSRect drawRect = NSMakeRect(0, 0, windowSize.width, windowSize.height);
  
	[image drawInRect:drawRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
}

-(void)setLastMousePosition:(CGPoint)pt
{
  lastMousePosition = pt;
}


@end
