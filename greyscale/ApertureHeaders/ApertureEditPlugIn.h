/*!
 @header		ApertureEditPlugIn.h	
 @copyright	2007 Apple Inc. All rights reserved.
 @discussion	Version 1.0. 
 */

/*Copyright: 2007 Apple Inc. All rights reserved.*/


#import <PluginManager/PROAPIAccessing.h>
#import "ApertureSDKCommon.h"
#import "ApertureEditManager.h"


@protocol ApertureEditPlugIn

- (id)initWithAPIManager:(id<PROAPIAccessing>)apiManager;

/* Callback for the edit manager's import method. Note that the current build of Aperture will not communicate import errors.*/
- (void)editManager:(id<ApertureEditManager>)editManager didImportImageAtPath:(NSString *)path versionUniqueID:(NSString *)versionUniqueID;
- (void)editManager:(id<ApertureEditManager>)editManager didNotImportImageAtPath:(NSString *)path error:(NSError *)error;

/* Notifies your plug-in that Aperture is ready for editing - even though it has not asked for your UI yet, you can begin making calls, getting
 properties, etc. */
- (void)beginEditSession;

/* Return the window that contains your entire UI. Aperture will place this window on screen, center it over the Aperture window, and run it modally.
 Returning nil is considered an error condition, and Aperture will dealloc the plugin. */
- (NSWindow *)editWindow;


@end
