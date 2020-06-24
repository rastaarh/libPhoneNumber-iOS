//
//  NBPhoneNumberOfflineGeocoder.m
//  libPhoneNumberiOS
//
//  Created by Rastaar Haghi on 6/12/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

#import "NBPhoneNumberOfflineGeocoder.h"
#import "Metadata/NBGeocoderMetadataHelper.h"
#import "NBPhoneNumber.h"
#import "NBPhoneNumberUtil.h"

@implementation NBPhoneNumberOfflineGeocoder {
 @private
  NBPhoneNumberUtil *_phoneNumberUtil;
  NSCache<NSString *, NBGeocoderMetadataHelper *> *_metadataHelpers;
}

- (instancetype)init {
  self = [super init];
  if (self != nil) {
    _phoneNumberUtil = NBPhoneNumberUtil.sharedInstance;
    // NSLocale provides an array of the user's preferred languages, which can be used
    // to gather the appropriate language code for NBGeocoderMetadataHelper
//    NSString *languageCode = [[NSLocale preferredLanguages] firstObject];
//    if (languageCode == nil) {
//      return nil;
//    }
    _metadataHelpers = [[NSCache alloc] init];
  }
  return self;
}

- (nullable NSString *)countryNameForNumber:(NBPhoneNumber *)number
                           withLanguageCode:(NSString *)languageCode {
  NSArray *regionCodes = [_phoneNumberUtil getRegionCodesForCountryCode:number.countryCode];
  if ([regionCodes count] == 1) {
    return [self regionDisplayName:regionCodes[0] withLanguageCode:languageCode];
  } else {
    NSString *regionWhereNumberIsValid = @"ZZ";
    for (NSString *regionCode in regionCodes) {
      if ([_phoneNumberUtil isValidNumberForRegion:number regionCode:regionCode]) {
        if (![regionWhereNumberIsValid isEqualToString:@"ZZ"]) {
          return nil;
        }
        regionWhereNumberIsValid = regionCode;
      }
    }

    return [self regionDisplayName:regionWhereNumberIsValid withLanguageCode:languageCode];
  }
}

- (nullable NSString *)regionDisplayName:(NSString *)regionCode
                        withLanguageCode:(NSString *)languageCode {
  if (regionCode == nil || [regionCode isEqualToString:@"ZZ"] ||
      [regionCode isEqual:NB_REGION_CODE_FOR_NON_GEO_ENTITY]) {
    return nil;
  } else {
    return [[NSLocale localeWithLocaleIdentifier:languageCode]
                               displayNameForKey:NSLocaleCountryCode value:regionCode];
  }
}

- (nullable NSString *)descriptionForValidNumber:(NBPhoneNumber *)phoneNumber
                                withLanguageCode:(NSString *)languageCode {
  // If the NSCache doesn't contain a key equivalent to languageCode, create a new
  // NBGeocoderMetadataHelper object with a language set equal to languageCode and
  // default country code to United States / Canada
  if ([_metadataHelpers objectForKey:languageCode] == nil) {
    [_metadataHelpers setObject:[[NBGeocoderMetadataHelper alloc] initWithCountryCode:@1
                                                                         withLanguage:languageCode]
                         forKey:languageCode];
  }
  NSString * ans = [[_metadataHelpers objectForKey:languageCode] searchPhoneNumber:phoneNumber];
    if (ans == nil) {
        NSLog(@"Entered this nil statement");
        return [self countryNameForNumber:phoneNumber withLanguageCode:languageCode];
    } else {
        return ans;
    }
}

- (nullable NSString *)descriptionForValidNumber:(NBPhoneNumber *)phoneNumber
                                withLanguageCode:(NSString *)languageCode
                                  withUserRegion:(NSString *)userRegion {
  NSString *regionCode = [_phoneNumberUtil getRegionCodeForNumber:phoneNumber];
  if ([userRegion isEqualToString:regionCode]) {
      return [self descriptionForValidNumber:phoneNumber withLanguageCode:languageCode];
  }
  return [self regionDisplayName:regionCode withLanguageCode:languageCode];
}

- (nullable NSString *)descriptionForNumber:(NBPhoneNumber *)phoneNumber
                           withLanguageCode:(NSString *)languageCode {
  NBEPhoneNumberType numberType = [_phoneNumberUtil getNumberType:phoneNumber];
  if (numberType == NBEPhoneNumberTypeUNKNOWN) {
      NSLog(@"Phone Number: %@ is unknown type", phoneNumber.nationalNumber);

    return nil;
  } else if (![_phoneNumberUtil isNumberGeographical:phoneNumber]) {
      NSLog(@"Phone Number: %@ is not geographical", phoneNumber.nationalNumber);
    return [self countryNameForNumber:phoneNumber withLanguageCode:languageCode];
  }
  return [self descriptionForValidNumber:phoneNumber withLanguageCode:languageCode];
}

- (nullable NSString *)descriptionForNumber:(NBPhoneNumber *)phoneNumber
                           withLanguageCode:(NSString *)languageCode
                             withUserRegion:(NSString *)userRegion {
  NBEPhoneNumberType numberType = [_phoneNumberUtil getNumberType:phoneNumber];
  if (numberType == NBEPhoneNumberTypeUNKNOWN) {
    return nil;
  } else if (![_phoneNumberUtil isNumberGeographical:phoneNumber]) {
    return [self countryNameForNumber:phoneNumber withLanguageCode:languageCode];
  }
  return [self descriptionForValidNumber:phoneNumber
                        withLanguageCode:languageCode
                          withUserRegion:userRegion];
}

- (nullable NSString *)descriptionForNumber:(NBPhoneNumber *)phoneNumber {
  NBEPhoneNumberType numberType = [_phoneNumberUtil getNumberType:phoneNumber];
  NSString *languageCode = [[NSLocale preferredLanguages] firstObject];

  if (languageCode == nil) {
    return nil;
  }

  if (numberType == NBEPhoneNumberTypeUNKNOWN) {
    return nil;
  } else if (![_phoneNumberUtil isNumberGeographical:phoneNumber]) {
    return [self countryNameForNumber:phoneNumber withLanguageCode:languageCode];
  }
  return [self descriptionForValidNumber:phoneNumber withLanguageCode:languageCode];
}

- (nullable NSString *)descriptionForNumber:(NBPhoneNumber *)phoneNumber
                             withUserRegion:(NSString *)userRegion {
  NBEPhoneNumberType numberType = [_phoneNumberUtil getNumberType:phoneNumber];
  NSString *languageCode = [[NSLocale preferredLanguages] firstObject];

  if (languageCode == nil) {
    return nil;
  }

  if (numberType == NBEPhoneNumberTypeUNKNOWN) {
    return nil;
  } else if (![_phoneNumberUtil isNumberGeographical:phoneNumber]) {
    return [self countryNameForNumber:phoneNumber withLanguageCode:languageCode];
  }
  return [self descriptionForValidNumber:phoneNumber
                        withLanguageCode:languageCode
                          withUserRegion:userRegion];
}

@end