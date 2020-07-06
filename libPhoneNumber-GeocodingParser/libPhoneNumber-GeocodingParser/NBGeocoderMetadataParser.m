//
//  NBGeocoderMetadataParser.m
//  libPhoneNumber-GeocodingParser
//
//  Created by Rastaar Haghi on 7/1/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

#import "NBGeocoderMetadataParser.h"

@implementation NBGeocoderMetadataParser

- (void)convertFileToSQLiteDatabase:(NSString *)completeTextFilePath
                       withFileName:(NSString *)textFileName
                       withLanguage:(NSString *)languageCode {
  NSString *fileContentString = [[NSString alloc] initWithContentsOfFile:completeTextFilePath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
  NSArray<NSString *> *countryCodes = [textFileName componentsSeparatedByString:@"."];
  NSString *countryCode = countryCodes[0];
  NBSQLiteDatabaseConnection *databaseConnection =
      [[NBSQLiteDatabaseConnection alloc] initWithCountryCode:countryCode language:languageCode];

  // This program splits each line of the text file into the two important
  // pieces of info: phone number prefix and the corresponding region
  // description.
  NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
  NSArray *components = [fileContentString componentsSeparatedByCharactersInSet:separator];
  NSArray<NSString *> *keyValuePair;

  NSString *key, *value;
  BOOL indexNeededFlag = YES;
  for (NSString *str in components) {
    @autoreleasepool {
      // This program skips entries if they are invalid or improperly
      // formatted and if they are a comment line
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
