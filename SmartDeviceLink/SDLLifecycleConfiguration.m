//
//  SDLManagerConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLLifecycleConfiguration.h"

#import "SDLFile.h"
#import "SDLVideoEncoder.h"

static NSString *const DefaultTCPIPAddress = @"192.168.0.1";
static UInt16 const DefaultTCPIPPort = 12345;
static NSString *const DefaultBackgroundTitleStringFormat = @"Please re-open %@";

NS_ASSUME_NONNULL_BEGIN

@interface SDLLifecycleConfiguration ()

@property (assign, nonatomic, readwrite) BOOL tcpDebugMode;
@property (copy, nonatomic, readwrite, null_resettable) NSString *tcpDebugIPAddress;
@property (assign, nonatomic, readwrite) UInt16 tcpDebugPort;

@end


@implementation SDLLifecycleConfiguration

#pragma mark Lifecycle

- (instancetype)initDefaultConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId {
    self = [super init];
    if (!self) {
        return nil;
    }

    _tcpDebugMode = NO;
    _tcpDebugIPAddress = DefaultTCPIPAddress;
    _tcpDebugPort = DefaultTCPIPPort;

    _appName = appName;
    _appId = appId;

    _appType = SDLAppHMITypeDefault;
    _language = SDLLanguageEnUs;
    _languagesSupported = @[_language];
    _appIcon = nil;
    _shortAppName = nil;
    _ttsName = nil;
    _voiceRecognitionCommandNames = nil;
    _logFlags = SDLLogOutputNone;
    
    _streamingEncryption = SDLStreamingEncryptionFlagAuthenticateAndEncrypt;
    
    _backgroundTitleString = [NSString stringWithFormat:DefaultBackgroundTitleStringFormat, appName];

    return self;
}

+ (SDLLifecycleConfiguration *)defaultConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId {
    return [[self alloc] initDefaultConfigurationWithAppName:appName appId:appId];
}

+ (SDLLifecycleConfiguration *)debugConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId ipAddress:(NSString *)ipAddress port:(UInt16)port {
    SDLLifecycleConfiguration *config = [[self alloc] initDefaultConfigurationWithAppName:appName appId:appId];
    config.tcpDebugMode = YES;
    config.tcpDebugIPAddress = ipAddress;
    config.tcpDebugPort = port;

    config.logFlags = SDLLogOutputConsole;

    return config;
}

#pragma mark Computed Properties

- (BOOL)isMedia {
    if ([self.appType isEqualToEnum:SDLAppHMITypeMedia]) {
        return YES;
    }

    return NO;
}

- (void)setTcpDebugIPAddress:(nullable NSString *)tcpDebugIPAddress {
    if (tcpDebugIPAddress == nil) {
        _tcpDebugIPAddress = DefaultTCPIPAddress;
    } else {
        _tcpDebugIPAddress = tcpDebugIPAddress;
    }
}

- (void)setAppType:(nullable SDLAppHMIType)appType {
    if (appType == nil) {
        _appType = SDLAppHMITypeDefault;
    }

    _appType = appType;
}

- (void)setBackgroundTitleString:(nullable NSString *)backgroundTitleString {
    if (backgroundTitleString == nil) {
        _backgroundTitleString = [NSString stringWithFormat:DefaultBackgroundTitleStringFormat, self.appName];
        return;
    }
    
    _backgroundTitleString = backgroundTitleString;
}


#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLLifecycleConfiguration *newConfig = [[self.class allocWithZone:zone] initDefaultConfigurationWithAppName:_appName appId:_appId];
    newConfig->_tcpDebugMode = _tcpDebugMode;
    newConfig->_tcpDebugIPAddress = _tcpDebugIPAddress;
    newConfig->_tcpDebugPort = _tcpDebugPort;
    newConfig->_appType = _appType;
    newConfig->_language = _language;
    newConfig->_languagesSupported = _languagesSupported;
    newConfig->_appIcon = _appIcon;
    newConfig->_shortAppName = _shortAppName;
    newConfig->_ttsName = _ttsName;
    newConfig->_voiceRecognitionCommandNames = _voiceRecognitionCommandNames;
    newConfig->_videoEncoderSettings = _videoEncoderSettings;

    return newConfig;
}

@end

NS_ASSUME_NONNULL_END
