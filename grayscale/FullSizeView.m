//
//  FullSizeView.m
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

#import "FullSizeView.h"


@implementation FullSizeView

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
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
