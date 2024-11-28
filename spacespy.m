#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AppKit/AppKit.h>

// Private CoreGraphics declarations
typedef uint32_t CGSConnectionID;
typedef uint32_t CGSSpaceID;

// External functions declarations
extern CGSConnectionID CGSMainConnectionID(void);
extern CFArrayRef CGSCopyManagedDisplaySpaces(const CGSConnectionID cid);

NSString* getDisplayName(NSString* displayID) {
    // Get all screens
    NSArray<NSScreen *> *screens = [NSScreen screens];
    
    for (NSScreen *screen in screens) {
        NSDictionary *description = [screen deviceDescription];
        NSNumber *screenID = description[@"NSScreenNumber"];
        
        if (screenID) {
            // Get the display UUID
            CGDirectDisplayID displayIDNum = [screenID unsignedIntValue];
            CFUUIDRef uuid = CGDisplayCreateUUIDFromDisplayID(displayIDNum);
            if (uuid) {
                NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
                CFRelease(uuid);
                
                if ([displayID isEqualToString:uuidString]) {
                    // Get the localized name using the same method as Aerospace
                    return [screen localizedName];
                }
            }
        }
    }
    
    return displayID;
}

int getDisplayArrangement(CGDirectDisplayID did) {
    NSArray<NSScreen *> *screens = [NSScreen screens];
    int index = 0;
    
    for (NSScreen *screen in screens) {
        NSDictionary *description = [screen deviceDescription];
        NSNumber *screenID = description[@"NSScreenNumber"];
        
        if (screenID && [screenID unsignedIntValue] == did) {
            return index;
        }
        index++;
    }
    
    return -1;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Get the connection ID
        CGSConnectionID cid = CGSMainConnectionID();
        
        // Get all spaces
        CFArrayRef displaySpaces = CGSCopyManagedDisplaySpaces(cid);
        
        if (displaySpaces) {
            NSArray *displays = (__bridge NSArray *)displaySpaces;
            NSMutableDictionary *result = [NSMutableDictionary dictionary];
            NSMutableArray *monitorsArray = [NSMutableArray array];

            // Track global space index
            __block int globalSpaceIndex = 1;
            
            // Process displays in order of their arrangement
            NSArray *orderedDisplays = [displays sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *display1, NSDictionary *display2) {
                NSArray *spaces1 = display1[@"Spaces"];
                NSArray *spaces2 = display2[@"Spaces"];
                NSNumber *firstSpaceId1 = spaces1.firstObject[@"id64"];
                NSNumber *firstSpaceId2 = spaces2.firstObject[@"id64"];
                return [firstSpaceId1 compare:firstSpaceId2];
            }];
            
            for (NSDictionary *display in orderedDisplays) {
                NSString *displayID = display[@"Display Identifier"];
                NSArray *spaces = display[@"Spaces"];
                NSNumber *currentSpace = display[@"Current Space"][@"id64"];
                NSString *monitorName = getDisplayName(displayID);
                
                // Get the display ID from UUID
                CGDirectDisplayID displayIDNum = 0;
                CFUUIDRef uuid = CFUUIDCreateFromString(kCFAllocatorDefault, (CFStringRef)displayID);
                if (uuid) {
                    displayIDNum = CGDisplayGetDisplayIDFromUUID(uuid);
                    CFRelease(uuid);
                }

                NSMutableDictionary *monitorInfo = [NSMutableDictionary dictionary];
                monitorInfo[@"name"] = monitorName;
                monitorInfo[@"uuid"] = displayID;
                monitorInfo[@"display_number"] = @(getDisplayArrangement(displayIDNum) + 1);
                NSMutableArray *spacesArray = [NSMutableArray array];
                
                for (NSDictionary *space in spaces) {
                    NSNumber *spaceID = space[@"id64"];
                    NSNumber *managedSpaceID = space[@"ManagedSpaceID"];
                    NSString *spaceUUID = space[@"uuid"];
                    BOOL isCurrent = [spaceID isEqualToNumber:currentSpace];
                    
                    [spacesArray addObject:@{
                        @"space_number": @(globalSpaceIndex),
                        @"id": spaceID,
                        @"managed_id": managedSpaceID,
                        @"uuid": spaceUUID,
                        @"is_current": @(isCurrent)
                    }];
                    
                    globalSpaceIndex++;
                }
                
                monitorInfo[@"spaces"] = spacesArray;
                [monitorsArray addObject:monitorInfo];
            }
            
            result[@"monitors"] = monitorsArray;
            
            // Convert to JSON and print
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result
                                                             options:NSJSONWritingPrettyPrinted
                                                               error:&error];
            
            if (jsonData) {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                printf("%s\n", [jsonString UTF8String]);
            }
            
            CFRelease(displaySpaces);
        }
    }
    return 0;
}