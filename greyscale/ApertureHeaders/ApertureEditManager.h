/*!
	@header			ApertureEditManager.h
	@copyright		2007 Apple Inc. All rights reserved.
*/

#import "ApertureSDKCommon.h"

/* New in Aperture 2 - Allows edit plug-ins to specify the format of new editable versions */
typedef enum
{	
	kApertureImageFormatTIFF8 = 2,
	kApertureImageFormatTIFF16 = 3,
	kApertureImageFormatPSD16 = 4,
	kApertureImageFormatPSD8 = 5,
} ApertureImageFormat;


@protocol ApertureEditManager

/* All methods should only be called from the main thread */

/* Returns an array of unique ids of the versions the user selected in Aperture. The IDs are ordered in the same order that the user selected them, except the primary selection is always first. */
- (NSArray *)selectedVersionIds;
/* Returns an array of unique ids that the plug-in is allowed to edit. This may include some images the user selected if they were already marked as editable. */
- (NSArray *)editableVersionIds;
/* Returns an array of unique ids of images the plug-in has imported during this session. */
- (NSArray *)importedVersionIds;

/* A dictionary containing all the available properties for the specified image, except a thumbnail. You may obtain a thumbnail
   separately using the method below. */
- (NSDictionary *)propertiesWithoutThumbnailForVersion:(NSString *)versionUniqueID;
/* Returns an NSImage containing the thumbnail for this image. Some plug-ins may choose to operate on the large thumbnail and not request and editable version
   of the image until the user is done */
- (NSImage *)thumbnailForVersion:(NSString *)versionUniqueID size:(ApertureExportThumbnailSize)size;

/* Returns the path to the file that the plug-in should read/write for this version. This is the same path available via the properties dictionary, but if this version is not editable, this method will return nil.*/
- (NSString *)pathOfEditableFileForVersion:(NSString *)versionUniqueID;

/* Returns an array of unique IDs. If an image was already editable and the user did not want to guarantee a copy (by holding the option key when
   selecting the plug-in from the menu) then this method will return the unique ID passed in for that version. Otherwise, this method will tell
   Aperture to write out an editable image in the format specified in the user's preferences (PSD or TIFF) and will create
   a new entry in the user's library. Normally, the plug-in would then call the -pathOfEditableFileForVersion: for the unique IDs returned from
   this method, or the -propertiesWithoutThumbnailForVersion: and -thumbnailForVersion: methods. */
- (NSArray *)editableVersionsOfVersions:(NSArray *)versionUniqueIDs stackWithOriginal:(BOOL)stackWithOriginal;
- (NSArray *)editableVersionsOfVersions:(NSArray *)versionUniqueIDs requestedFormat:(ApertureImageFormat)format stackWithOriginal:(BOOL)stackWithOriginal;


/* Returns YES if Aperture will allow the plug-in to import images into the current album. Aperture will not allow import into smart albums, for example. */
- (BOOL)canImport;

/* Asynchronously import an image into the current album and calls the -editManager:didImportImageAtPath:versionUniqueID: method upon completion.
   If -canImport returns NO, this method will do nothing and the plug-in will not get a callback. The plug-in should not call -endEditSession or -cancelEditSession until it has received the import callback. */
- (void)importImageAtPath:(NSString *)imagePath referenced:(BOOL)isReferenced stackWithVersions:(NSArray *)versionUniqueIdsToStack;

/* Deletes the specified versions and their master files from the user's library. Aperture will only perform this operation for versions created by the plug-in
   during the current session. Unique IDs
   for any images that were not created by the plug-in will be ignored. This includes images that were already editable that the plug-in has modified.
   Note that this will delete all master files attached to these versions. */
- (void)deleteVersions:(NSArray *)versionUniqueIDs;

/* Will add the specified key-value pairs to the Custom Metadata for this image (The "Other" tab in the metadata inspector). If an image already has
   a value for the specified key, it will be updated to the new value */
- (void)addCustomMetadata:(NSDictionary *)customMetadata toVersions:(NSArray *)versionUniqueIDs;
/* Pass in an array of arrays. Each array specifies a keyword hierarchy.*/
- (void)addHierarchicalKeywords:(NSArray *)hierarchicalKeywords toVersions:(NSArray *)versionUniqueIDs;

/* Returns Aperture's main window - in case the plug-in needs to present a sheet, etc. */
- (NSWindow *)apertureWindow;

/* Tells Aperture that the plug-in has completed its work. The plug-in should be ready to dealloc at the time of this call and should not be running tasks
   on any other threads or running anything on the run loop that may call back after this call has finished. */
- (void)endEditSession;

/* Similar to the method above, but automatically deletes any editable versions that were created by the plug-in during this session. Note that this will NOT delete
   and versions that were edited by the plug-in, but not created during this session. This call will also not delete any referenced master files imported by the plug-in. */
- (void)cancelEditSession;

/* These methods will read and write preferences values into a preferences file specific to the plug-in - not Aperture's preferences file */
- (void)setUserDefaultsValue:(id)value forKey:(NSString *)key;
- (id)userDefaultsObjectForKey:(NSString *)key;

@end