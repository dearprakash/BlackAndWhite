//
//  GreyscaleEditPluginView.m
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

#import "GreyscaleEditPluginView.h"


typedef enum RectPointType
{
	UnknownRectPoint = 0,
	
	TopLeftRectPoint,
	TopCenterRectPoint,
	TopRightRectPoint,
	CenterLeftRectPoint,
	CenterRectPoint,
	CenterRightRectPoint,
	BottomLeftRectPoint,
	BottomCenterRectPoint,
	BottomRightRectPoint, 
	
	FirstRectPoint = TopLeftRectPoint,
	LastRectPoint = BottomRightRectPoint
}
RectPointType;


//==============================================================================
NSRect NSRectAlignToPoint(NSRect src, RectPointType srcRectPt, NSPoint modelPt)
{
	switch (srcRectPt) {
		case TopLeftRectPoint:
			src.origin.x = modelPt.x;
			src.origin.y = modelPt.y - NSHeight(src);
			break;
			
		case TopCenterRectPoint:
			src.origin.x = modelPt.x - NSWidth(src) / 2.0;
			src.origin.y = modelPt.y - NSHeight(src);
			break;
			
		case TopRightRectPoint:
			src.origin.x = modelPt.x - NSWidth(src);
			src.origin.y = modelPt.y - NSHeight(src);
			break;
			
		case CenterLeftRectPoint:
			src.origin.x = modelPt.x;
			src.origin.y = modelPt.y - NSHeight(src) / 2.0;
			break;
			
		case CenterRectPoint:
			src.origin.x = modelPt.x - NSWidth(src) / 2.0;
			src.origin.y = modelPt.y - NSHeight(src) / 2.0;
			break;
			
		case CenterRightRectPoint:
			src.origin.x = modelPt.x - NSWidth(src);
			src.origin.y = modelPt.y - NSHeight(src) / 2.0;
			break;
			
		case BottomLeftRectPoint:
			src.origin.x = modelPt.x;
			src.origin.y = modelPt.y;
			break;
			
		case BottomCenterRectPoint:
			src.origin.x = modelPt.x - NSWidth(src) / 2.0;
			src.origin.y = modelPt.y;			
			break;
			
		case BottomRightRectPoint:
			src.origin.x = modelPt.x - NSWidth(src);
			src.origin.y = modelPt.y;
			break;
			
		case UnknownRectPoint:
			break;
	}
	
	return(src);
}

//==============================================================================
NSPoint NSRectPoint(NSRect src, RectPointType rectPt)
{
	NSPoint	result = src.origin;
	
	switch (rectPt) {
		case TopLeftRectPoint:		result.x = NSMinX(src);	result.y = NSMaxY(src);	break;
		case TopCenterRectPoint:	result.x = NSMidX(src);	result.y = NSMaxY(src);	break;
		case TopRightRectPoint:		result.x = NSMaxX(src);	result.y = NSMaxY(src);	break;
			
		case CenterLeftRectPoint:	result.x = NSMinX(src);	result.y = NSMidY(src);	break;
		case CenterRectPoint:		result.x = NSMidX(src);	result.y = NSMidY(src);	break;
		case CenterRightRectPoint:	result.x = NSMaxX(src);	result.y = NSMidY(src);	break;
			
		case BottomLeftRectPoint:	result.x = NSMinX(src);	result.y = NSMinY(src);	break;
		case BottomCenterRectPoint:	result.x = NSMidX(src);	result.y = NSMinY(src);	break;
		case BottomRightRectPoint:	result.x = NSMaxX(src);	result.y = NSMinY(src);	break;
			
		case UnknownRectPoint:		result = src.origin;						break;
	}
	
	return(result);
}

//==============================================================================
NSRect NSRectAlignWithRect(NSRect src, RectPointType srcRectPt, NSRect model, RectPointType modelRectPt)
{
	return(NSRectAlignToPoint(src, srcRectPt, NSRectPoint(model, modelRectPt)));
}

static inline NSRect NSRectCenterOverRect(NSRect src, NSRect model)
{
	return(NSRectAlignWithRect(src, CenterRectPoint, model, CenterRectPoint));
}

//==============================================================================
NSRect NSRectScale(NSRect src, float scaleWidth, float scaleHeight)
{
	src.size.width *= scaleWidth;
	src.size.height *= scaleHeight;
	
	return(src);
}

//==============================================================================
NSRect NSRectUniformScale(NSRect src, float scale)
{
	return(NSRectScale(src, scale, scale));
}

//==============================================================================
NSRect NSRectScaleToFill2(NSRect src, NSRect model, float *scale)
{
	float	widthScale, heightScale, theScale;
	
	// If the model is empty, just return empty as well
	if (NSIsEmptyRect(model))
		return(NSZeroRect);
	
	// If the src is empty, just return the model
	if (NSIsEmptyRect(src))
		return(model);
	
	// Calculate the required scalings
	widthScale = model.size.width / src.size.width;
	heightScale = model.size.height / src.size.height;
	theScale = (widthScale < heightScale ? widthScale : heightScale);
	
	if (scale)
		*scale = theScale;
	
	// Choose the smaller scale and resize
	return(NSRectUniformScale(src, theScale));
}

//==============================================================================
NSRect NSRectScaleToFill(NSRect src, NSRect model)
{
	return(NSRectScaleToFill2(src, model, nil));
}

//==============================================================================
NSRect NSRectScaleToFit(NSRect src, NSRect model)
{
	// If we're already inside, we're done
	if (NSContainsRect(model, src))
		return(src);
	
	return(NSRectScaleToFill(src, model));
}

@implementation GreyscaleEditPluginView

-(void)awakeFromNib
{
  NSRect eyeBox = self.bounds;
  _trackingArea = [[NSTrackingArea alloc] initWithRect:eyeBox
                                              options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow )
                                                owner:self userInfo:nil];
  [self addTrackingArea:_trackingArea];
}


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
	CIImage *image = [_datasource valueForKey:@"outputImage"];
  
	// Draw this into my view.
	CGRect cgRect = image.extent;
	NSRect imageRect = NSMakeRect(0, 0, cgRect.size.width, cgRect.size.height);
	NSRect drawRect = NSRectCenterOverRect(NSRectScaleToFit(imageRect, rect), rect);
  
	[image drawInRect:drawRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
  // get the local point in view
  NSPoint event_location = [theEvent locationInWindow];
  NSPoint local_point = [self convertPoint:event_location fromView:nil];
  CIImage *image = [_datasource valueForKey:@"outputImage"];
  
  CGSize cgSize = image.extent.size;
  NSRect imageRect = NSMakeRect(0, 0, cgSize.width, cgSize.height);
  // alculate the rect we are going to draw into
  NSRect drawRect = NSRectCenterOverRect(NSRectScaleToFit(imageRect, self.bounds), self.bounds);
  // if the point is in the view
  if (NSPointInRect(local_point, drawRect)) {
    // figure out what the scaling is going to be
    CGFloat widthScale = cgSize.width / drawRect.size.width;
    CGFloat heightScale = cgSize.height / drawRect.size.height;
    CGFloat theScale = (widthScale < heightScale ? widthScale : heightScale);
    // calculate the point in the image keeping in mind the image may not be drawn at 0,0
    CGPoint pt = CGPointMake((local_point.x-drawRect.origin.x)*theScale, (local_point.y-drawRect.origin.y)*theScale);
    // draw the 100% view
    [_fullView setLastMousePosition:pt];
    [_fullView setNeedsDisplay:YES];
  }
}

@end
