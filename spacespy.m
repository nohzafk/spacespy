// spacespy.m
#import <Foundation/Foundation.h>

// Private CoreGraphics declarations
typedef uint32_t CGSConnectionID;
typedef uint32_t CGSSpaceID;
typedef enum _CGSSpaceType {
    kCGSSpaceUser,
    kCGSSpaceSystem,
} CGSSpaceType;

typedef enum {
    kCGSSpaceCurrent = 5,
    kCGSSpaceAll = 7
} CGSSpaceSelector;

typedef int CGError;

// External functions declarations
extern CGSConnectionID CGSMainConnectionID(void);
extern CGError CGSCopySpaces(CGSConnectionID cid, CGSSpaceSelector type, CGSSpaceID **spaces, int *count);
extern CGError CGSGetSpaceType(CGSConnectionID cid, CGSSpaceID sid, CGSSpaceType *type);
extern CFArrayRef CGSCopyManagedDisplaySpaces(const CGSConnectionID cid);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Get the connection ID
        CGSConnectionID cid = CGSMainConnectionID();
        
        // Get all spaces
        CFArrayRef displaySpaces = CGSCopyManagedDisplaySpaces(cid);
        
        if (displaySpaces) {
            NSArray *displays = (__bridge NSArray *)displaySpaces;
            
            for (NSDictionary *display in displays) {
                NSString *displayID = display[@"Display Identifier"];
                NSArray *spaces = display[@"Spaces"];
                
                printf("Display: %s\n", [displayID UTF8String]);
                
                for (NSDictionary *space in spaces) {
                    NSNumber *spaceID = space[@"id64"];
                    NSNumber *managedSpaceID = space[@"ManagedSpaceID"];
                    
                    printf("  Space ID: %lld, Managed Space ID: %lld\n",
                           [spaceID longLongValue],
                           [managedSpaceID longLongValue]);
                }
                printf("\n");
            }
            
            CFRelease(displaySpaces);
        }
    }
    return 0;
}