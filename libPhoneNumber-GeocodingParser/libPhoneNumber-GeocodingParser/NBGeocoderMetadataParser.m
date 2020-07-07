//
//  NBGeocoderMetadataParser.m
//  libPhoneNumber-GeocodingParser
//
//  Created by Rastaar Haghi on 7/1/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

#import "NBGeocoderMetadataParser.h"

@implementation NBGeocoderMetadataParser {
  NSString *_desiredDatabaseDestination;
}

- (instancetype)initWithDesiredDatabaseDestination:(NSString *)desiredDatabaseDestination {
  self = [super init];
  if (self != nil) {
    _desiredDatabaseDestination = desiredDatabaseDestination;
  }
  return self;
}

- (void)convertFileToSQLiteDatabase:(NSString *)completeTextFilePath
                       withFileName:(NSString *)textFileName
                       withLanguage:(NSString *)languageCode {
  NSString *fileContentString = [[NSString alloc] initWithContentsOfFile:completeTextFilePath
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];
  NSArray<NSString *> *countryCodes = [textFileName componentsSeparatedByString:@"."];

  NSString *countryCode = countryCodes[0];
  NBSQLiteDatabaseConnection *databaseConnection =
      [[NBSQLiteDatabaseConnection alloc] initWithCountryCode:countryCode
                                                 withLanguage:languageCode
                                       withDesiredDestination:_desiredDatabaseDestination];

  // Split into phone number prefix and region description.
  NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
  NSArray *components = [fileContentString componentsSeparatedByCharactersInSet:separator];
  NSArray<NSString *> *keyValuePair;

  NSString *key, *value;
  BOOL indexNeededFlag = YES;
  for (NSString *str in components) {
    @autoreleasepool {
      // This program skips entries if invalid, improperly formatted, or a comment
      if (([str length] > 0) && ([str characterAtIndex:0] == '#')) {
        continue;
      }
      keyValuePair = [str componentsSeparatedByString:@"|"];
      if ([keyValuePair count] != 2) {
        continue;
      }
      key = [keyValuePair[0]
          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      value = [keyValuePair[1]
          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      [databaseConnection addEntryToDB:key withDescription:value withCountryCode:countryCode];
      indexNeededFlag = NO;
    }
  }
}

@end
