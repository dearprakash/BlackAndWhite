//
//	greyscale.m
//	greyscale
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

#import "greyscale.h"
#import "Settings.h"

#define INPUT_RED_FACTOR @"inputRedFactor"
#define INPUT_GREEN_FACTOR @"inputGreenFactor"
#define INPUT_BLUE_FACTOR @"inputBlueFactor"
#define INPUT_GRAIN_FACTOR @"inputNoiseFactor"

CFStringRef windowFrameKey = CFSTR("BlackAndWhiteWindowFrame");


@interface greyscale(Private)

- (void)_updateButtons;
- (void)_editImage;
-(void)synchSliders;
-(void)updateFilter;
-(void)updateAndRedisplay;
-(void)saveWindowFrameToSettings;
@end


@implementation greyscale

#pragma mark -
// Private
#pragma mark Private

- (void)_updateButtons
{
	// Revert button: Enable this button if the user has changed the setting for this image.
	Settings *currentSetting = [_currentSettings objectAtIndex:_editingIndex];
	if (currentSetting.redSetting == DEFAULT_RED_FACTOR_VALUE) {
		[_revertButton setEnabled:NO];
  } else {
		[_revertButton setEnabled:YES];
  }
	
	// Next and previous buttons: Enable/Disable these depending on whether the user is at the first or last image	
	[_nextButton setEnabled:(_editingIndex < ([[_editManager selectedVersionIds] count] - 1))];
	[_previousButton setEnabled:!(_editingIndex == 0)];
	
  [self synchSliders];
}

- (void)_editImage
{
	// This method sets up the current image to be edited. When the plug-in is launched, we simply load the array with NSNull objects
	// Then, as the user edits an image, we load the actual image, set up the image filter, etc.
	
	// First, check to see if this image is still NSNull
	if ([_imagePaths objectAtIndex:_editingIndex] == [NSNull null]) {
		// Get the selected version at this index
		NSString *versionUniqueID = [[_editManager selectedVersionIds] objectAtIndex:_editingIndex];
		
		// Tell Aperture to make an editable version of this image. If this version is already editable, this method won't generate a new version
		// but will still return the appropriate properties.
		NSArray *properties = [_editManager editableVersionsOfVersions:[NSArray arrayWithObject:versionUniqueID] stackWithOriginal:YES];
		NSDictionary *imageProperties = [properties objectAtIndex:0];
		
		// Change out the NSNull object for the path of the edtiable file.
		[_imagePaths removeObjectAtIndex:_editingIndex];
		[_imagePaths insertObject:[_editManager pathOfEditableFileForVersion:[imageProperties objectForKey:kExportKeyUniqueID]] atIndex:_editingIndex];
	}
	
	// If we don't have an NSNull object, then we have a path, so use that to laod up an image.
	NSURL *imageURL = [NSURL fileURLWithPath:[_imagePaths objectAtIndex:_editingIndex]];
	CIImage *_inputCIImage = [[CIImage alloc] initWithContentsOfURL:imageURL];
	[_imageFilter setValue:_inputCIImage forKey:@"inputImage"];
	[_inputCIImage release];
  CGRect cgRect = _inputCIImage.extent;
  CIVector *rect = [CIVector vectorWithX:cgRect.origin.x Y:cgRect.origin.y Z:cgRect.size.width W:cgRect.size.height];
  [_cropFilter setValue:rect forKey:@"inputRectangle"];
  if (_grainButton.state) {
    [_randomCrop setValue:rect forKey:@"inputRectangle"];
    [_randomCrop setValue:[_randomGenerator valueForKey:@"outputImage"] forKey:@"inputImage"];
    [_blurFilter setValue:[_randomCrop valueForKey:@"outputImage"] forKey:@"inputImage"];
    [_imageFilter setValue:[_blurFilter valueForKey:@"outputImage"] forKey:@"inputBackgroundImage"];
  } else {
    [_imageFilter setValue:nil forKey:@"inputBackgroundImage"];
  }
  if (_sepiaButton.state) {
    [_sepiaFilter setValue:[_imageFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
    [_cropFilter setValue:[_sepiaFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
  } else {
    [_cropFilter setValue:[_imageFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
  }

}

-(void)synchSliders
{
	Settings *setting = [_currentSettings objectAtIndex:_editingIndex];
  [_redSlider setFloatValue:setting.redSetting];
  [_greenSlider setFloatValue:setting.greenSetting];
  [_blueSlider setFloatValue:setting.blueSetting];
}

-(void)updateFilter
{
	Settings *setting = [_currentSettings objectAtIndex:_editingIndex];
	[_imageFilter setValue:[setting redSettingNumber] forKey:INPUT_RED_FACTOR];
	[_imageFilter setValue:[setting greenSettingNumber] forKey:INPUT_GREEN_FACTOR];
	[_imageFilter setValue:[setting blueSettingNumber] forKey:INPUT_BLUE_FACTOR];
	[_imageFilter setValue:[setting grainSettingNumber] forKey:INPUT_GRAIN_FACTOR];
  if (_sepiaButton.state) {
    [_sepiaFilter setValue:[setting sepiaSettingNumber] forKey:@"inputIntensity"];
  }
}

-(void)updateAndRedisplay
{
	[self updateFilter];
  [self _editImage];
  [self _updateButtons];
	
	[_imageView setNeedsDisplay:YES];
	[_fullSizeView setNeedsDisplay:YES];
}

-(void)saveWindowFrameToSettings
{
  if (_editWindow) {
    CGRect r = CGRectMake(_editWindow.frame.origin.x, _editWindow.frame.origin.y, _editWindow.frame.size.width, _editWindow.frame.size.height);
    CFDictionaryRef d = CGRectCreateDictionaryRepresentation(r);
    CFPreferencesSetAppValue(windowFrameKey, d, kCFPreferencesCurrentApplication);
    CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
    CFRelease(d);
  }
}


//---------------------------------------------------------
// initWithAPIManager:
//
// This method is called when a plug-in is first loaded, and
// is a good point to conduct any checks for anti-piracy or
// system compatibility. This is also your only chance to
// obtain a reference to Aperture's export manager. If you
// do not obtain a valid reference, you should return nil.
// Returning nil means that a plug-in chooses not to be accessible.
//---------------------------------------------------------

- (id)initWithAPIManager:(id<PROAPIAccessing>)apiManager
{
	if (self = [super init]) {
		_apiManager	= apiManager;
		_editManager = [[_apiManager apiForProtocol:@protocol(ApertureEditManager)] retain];
		if (!_editManager) {
			return nil;
    }
    [CIPlugIn loadAllPlugIns];
				
		// Create the array we'll use to hold the paths to our images
		_imagePaths = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	// Release the top-level objects from the nib.
	[_topLevelNibObjects makeObjectsPerformSelector:@selector(release)];
	[_topLevelNibObjects release];

	[_editManager release];
	[_imagePaths release];
	[_imageFilter release];
	[_cropFilter release];
	[_blurFilter release];
	[_randomGenerator release];
	
	[super dealloc];
}


#pragma mark -
// UI Methods
#pragma mark UI Methods

- (NSWindow *)editWindow
{
	if (_editWindow == nil) {
		NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
		NSNib *myNib = [[NSNib alloc] initWithNibNamed:@"greyscale" bundle:myBundle];
		if ([myNib instantiateNibWithOwner:self topLevelObjects:&_topLevelNibObjects]) {
			[_topLevelNibObjects retain];
		}
		[myNib release];
    [_editWindow setAcceptsMouseMovedEvents:YES];
    [_editWindow setDelegate:self];
    
    CFDictionaryRef d = CFPreferencesCopyAppValue(windowFrameKey, kCFPreferencesCurrentApplication);
    if (d != nil) {
      CGRect r;
      CGRectMakeWithDictionaryRepresentation(d, &r);
      CFRelease(d);
      [_editWindow setFrame:NSRectFromCGRect(r) display:YES];
    } else {
      NSRect newFrame = [_editWindow constrainFrameRect:[_editWindow frame] toScreen:[NSScreen mainScreen]];
      [_editWindow setFrame:newFrame display:YES];
    }
	}
	
	return _editWindow;
}

#pragma mark -
// Edit Session Methods
#pragma mark Edit Session Methods

- (void)beginEditSession
{
	_editingIndex = 0;
  
	int i, count = [[_editManager selectedVersionIds] count];
	_currentSettings = [[NSMutableArray alloc] initWithCapacity:count];
	for (i=0; i < count; i++) {
		[_currentSettings addObject:[[[Settings alloc] init] autorelease]];
		[_imagePaths addObject:[NSNull null]];
	}
	
	_imageFilter = [[CIFilter filterWithName:@"grayscaleimageunitFilter"] retain];
  [self updateFilter];
	_cropFilter = [[CIFilter filterWithName:@"CICrop"] retain];
	_randomCrop = [[CIFilter filterWithName:@"CICrop"] retain];
	_blurFilter = [[CIFilter filterWithName:@"CIGaussianBlur"] retain];
  [_blurFilter setDefaults];
  [_blurFilter setValue:[NSNumber numberWithFloat:1.5] forKey:@"inputRadius"];
	_randomGenerator = [[CIFilter filterWithName:@"CIRandomGenerator"] retain];
  _sepiaFilter = [[CIFilter filterWithName:@"CISepiaTone"] retain];

	[self _editImage];
 	[self _updateButtons];
}

- (void)editManager:(id<ApertureEditManager>)editManager didImportImageAtPath:(NSString *)path versionUniqueID:(NSString *)versionUniqueID
{
	
}

- (void)editManager:(id<ApertureEditManager>)editManager didNotImportImageAtPath:(NSString *)path error:(NSError *)error
{
	
}

#pragma mark -
// Actions
#pragma mark Actions

- (IBAction)_cancelEditing:(id)sender
{
  [self saveWindowFrameToSettings];
	// Tell Aperture to cancel
	[_editManager cancelEditSession];
}

- (IBAction)_doneEditing:(id)sender
{
	// The whole point of this method is to actually write out the changes the user has made
	int i, count = [[_editManager selectedVersionIds] count];
	for (i = 0; i < count; i++) {
		NSString *filePath = [_imagePaths objectAtIndex:i];
		if ([filePath isKindOfClass:[NSString class]]) {
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			// Set up our filters/etc for the current image
			_editingIndex = i;
			[self _editImage];
			
			// This sample code will always write out 8-bit data, even if the original input was 16-bits. However,
			// it will also write out the correct format, and will include the appropriate metadata from
			// the original.
			
			CIImage *image = [self outputImage];
			CGRect cgRect = [image extent];
			NSRect imageRect = NSMakeRect(0, 0, cgRect.size.width, cgRect.size.height);
			NSImage *newImage = [[NSImage alloc] initWithSize:imageRect.size];
			
			// Draw the final result to an NSImage
			[newImage lockFocus];
			[image drawInRect:imageRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
			[newImage unlockFocus];
			
			// In order to make sure we're writing the correct format and preseving the metadata, read those from the existing image.
			NSURL *imageURL = [NSURL fileURLWithPath:filePath];
			CGImageSourceRef originalImageSource = CGImageSourceCreateWithURL((CFURLRef)imageURL, NULL);
			CFDictionaryRef originalImageProperties = CGImageSourceCopyPropertiesAtIndex(originalImageSource, 0, NULL);
			CFStringRef imageType = CGImageSourceGetType(originalImageSource);
			if (originalImageSource != NULL) {
				CFRelease(originalImageSource);
      }
			
			// Create a new image source that reads the TIFF data that we get from our NSImage.
			NSData *imageData = [newImage TIFFRepresentation];
			CGImageSourceRef finalImageSource = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
			
			// Create an image destination. This will take the image data from our source, and write it along with the metadata we read above
			// into a file in the correct format.
			CGImageDestinationRef imageDestination = CGImageDestinationCreateWithURL((CFURLRef)imageURL, imageType, 1, NULL);
			CGImageDestinationAddImageFromSource(imageDestination, finalImageSource, 0, originalImageProperties);
			if (!CGImageDestinationFinalize(imageDestination)) {
				// The sample code doesn't do any specific error handling in this case. This would be an appropriate
				// place to notify the user, put up an alert, etc.
			}
			CFRelease(imageType);
			CFRelease(finalImageSource);
			CFRelease(imageDestination);
			CFRelease(originalImageProperties);
			[newImage release];
			
			// Tag this image with a keyword stating it was edited, and a custom metadata value saying how.
			NSString *versionUniqueId = [[_editManager editableVersionIds] objectAtIndex:_editingIndex];
			if (versionUniqueId != nil) {
				NSArray *version = [NSArray arrayWithObject:versionUniqueId];
				NSString *keyword = @"Edited";
				NSArray *keywordHierarchy = [NSArray arrayWithObject:keyword];
				NSArray *keywords =  [NSArray arrayWithObject:keywordHierarchy];
				[_editManager addHierarchicalKeywords:keywords toVersions:version];
        
				NSDictionary *customMetadata = [NSDictionary dictionaryWithObject:[[_currentSettings objectAtIndex:_editingIndex] description] forKey:@"Grayscale Filter Setting"];
				[_editManager addCustomMetadata:customMetadata toVersions:version];
			}
			
			[pool release];
		}
	}
  [self saveWindowFrameToSettings];
	[_editManager endEditSession];
}

- (IBAction)_nextImage:(id)sender
{
	// Set up the next image for editing
	_editingIndex++;
	
	[self _editImage];
	[self _updateButtons];
	
	[_imageView setNeedsDisplay:YES];
}

- (IBAction)_previousImage:(id)sender
{
	// Set up the previous index for editing
	_editingIndex--;
	
	[self _editImage];
	[self _updateButtons];
	
	[_imageView setNeedsDisplay:YES];
}

- (IBAction)_revertCurrentImage:(id)anArgument
{
	Settings *setting = [_currentSettings objectAtIndex:_editingIndex];
  [setting revertToDefaults];
  [self synchSliders];
	[self updateFilter];
  [self _editImage];
	[_revertButton setEnabled:NO];
	
	[_imageView setNeedsDisplay:YES];
	[_fullSizeView setNeedsDisplay:YES];
}

- (IBAction)_changeRedSlider:(id)sender
{
	float newValue = [sender floatValue];
	Settings *setting = [_currentSettings objectAtIndex:_editingIndex];
  setting.redSetting = newValue;
  [self synchSliders];
	[self updateAndRedisplay];
}

- (IBAction)_changeGreenSlider:(id)sender
{
	float newValue = [sender floatValue];
	Settings *setting = [_currentSettings objectAtIndex:_editingIndex];
  setting.greenSetting = newValue;
  [self synchSliders];
	[self updateAndRedisplay];
}

- (IBAction)_changeBlueSlider:(id)sender
{
	float newValue = [sender floatValue];
	Settings *setting = [_currentSettings objectAtIndex:_editingIndex];
  setting.blueSetting = newValue;
  [self synchSliders];
	[self updateAndRedisplay];
}

- (IBAction)_changeGrainSlider:(id)sender;
{
	float newValue = [sender floatValue];
	Settings *setting = [_currentSettings objectAtIndex:_editingIndex];
  setting.grainSetting = newValue;
	[self updateAndRedisplay];
}

- (IBAction)_changeSepiaSlider:(id)sender;
{
	float newValue = [sender floatValue];
	Settings *setting = [_currentSettings objectAtIndex:_editingIndex];
  setting.sepiaSetting = newValue;
  [self updateAndRedisplay];
}

- (IBAction)_filmGrainChanged:(id)sender
{
  int state = [sender state];
  if (state) {
		[_grainSlider setEnabled:YES];
  } else {
		[_grainSlider setEnabled:NO];
  }
	[self updateAndRedisplay];
}

- (IBAction)_sepiaChanged:(id)sender
{
  int state = [sender state];
  if (state) {
		[_sepiaSlider setEnabled:YES];
  } else {
		[_sepiaSlider setEnabled:NO];
  }
	[self updateAndRedisplay];
}

#pragma mark -
// Accessors
#pragma mark Accessors


- (CIImage *)outputImage
{
	return [_cropFilter valueForKey:@"outputImage"];
}

#pragma mark -
// NSWindowDelegate methods
#pragma mark NSWindowDelegate methods

- (void)windowWillClose:(NSNotification *)notification
{
	[_editManager cancelEditSession];
}

@end
