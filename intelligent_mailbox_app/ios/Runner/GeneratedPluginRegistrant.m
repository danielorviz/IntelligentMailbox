//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<firebase_auth/FLTFirebaseAuthPlugin.h>)
#import <firebase_auth/FLTFirebaseAuthPlugin.h>
#else
@import firebase_auth;
#endif

#if __has_include(<firebase_core/FLTFirebaseCorePlugin.h>)
#import <firebase_core/FLTFirebaseCorePlugin.h>
#else
@import firebase_core;
#endif

#if __has_include(<firebase_database/FLTFirebaseDatabasePlugin.h>)
#import <firebase_database/FLTFirebaseDatabasePlugin.h>
#else
@import firebase_database;
#endif

#if __has_include(<firebase_messaging/FLTFirebaseMessagingPlugin.h>)
#import <firebase_messaging/FLTFirebaseMessagingPlugin.h>
#else
@import firebase_messaging;
#endif

#if __has_include(<flutter_nfc_kit/FlutterNfcKitPlugin.h>)
#import <flutter_nfc_kit/FlutterNfcKitPlugin.h>
#else
@import flutter_nfc_kit;
#endif

#if __has_include(<google_sign_in_ios/FLTGoogleSignInPlugin.h>)
#import <google_sign_in_ios/FLTGoogleSignInPlugin.h>
#else
@import google_sign_in_ios;
#endif

#if __has_include(<qr_code_scanner_plus/FlutterQrPlusPlugin.h>)
#import <qr_code_scanner_plus/FlutterQrPlusPlugin.h>
#else
@import qr_code_scanner_plus;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

#if __has_include(<wifi_iot/WifiIotPlugin.h>)
#import <wifi_iot/WifiIotPlugin.h>
#else
@import wifi_iot;
#endif

#if __has_include(<wifi_scan/WifiScanPlugin.h>)
#import <wifi_scan/WifiScanPlugin.h>
#else
@import wifi_scan;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTFirebaseAuthPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseAuthPlugin"]];
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FLTFirebaseDatabasePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseDatabasePlugin"]];
  [FLTFirebaseMessagingPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseMessagingPlugin"]];
  [FlutterNfcKitPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterNfcKitPlugin"]];
  [FLTGoogleSignInPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTGoogleSignInPlugin"]];
  [FlutterQrPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterQrPlusPlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
  [WifiIotPlugin registerWithRegistrar:[registry registrarForPlugin:@"WifiIotPlugin"]];
  [WifiScanPlugin registerWithRegistrar:[registry registrarForPlugin:@"WifiScanPlugin"]];
}

@end
