//
//  SDLHexUtility.m
//  SmartDeviceLink
//

#import "SDLHexUtility.h"

@implementation SDLHexUtility

// Using this function as a fail-safe, because we know this is successful.
+ (NSString *)getHexString:(UInt8 *)bytes length:(int)length {
    NSMutableString *ret = [NSMutableString stringWithCapacity:(length * 2)];
    for (int i = 0; i < length; i++) {
        [ret appendFormat:@"%02X", ((Byte *)bytes)[i]];
    }
    return ret;
}

static inline char itoh(int i) {
    if (i > 9) return 'A' + (i - 10);
    return '0' + i;
}

NSString* getHexString(NSData *data) {
    NSUInteger length;
    unsigned char *buffer, *bytes;
    
    length = data.length;
    bytes = (unsigned char*)data.bytes;
    buffer = malloc(length*2);
    
    for (NSUInteger i = 0; i < length; i++) {
        buffer[i*2] = itoh((bytes[i] >> 4) & 0xF);
        buffer[i*2+1] = itoh(bytes[i] & 0xF);
    }
    
    NSString* hexString = [[NSString alloc] initWithBytesNoCopy:buffer
                                                         length:length*2
                                                       encoding:NSASCIIStringEncoding
                                                   freeWhenDone:YES];
    /*
     *  According to apple's special case (https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/#//apple_ref/occ/instm/NSString/initWithBytesNoCopy:length:encoding:freeWhenDone:)
     *  we must free the buffer if there is an error allocating the string.
     *  We will then fallback to our less performant method, in hopes we will be able to 
     *  convert the bytes. This is only a precaution.
     */
    if (!hexString) {
        free(buffer);
        hexString = [SDLHexUtility getHexString:bytes
                                         length:length];
    }
    return
}

+ (NSString *)getHexString:(NSData *)data {
    return getHexString(data);
}


@end
