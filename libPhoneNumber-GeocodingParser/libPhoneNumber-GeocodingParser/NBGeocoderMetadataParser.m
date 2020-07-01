//
//  NBGeocoderMetadataParser.m
//  libPhoneNumber-GeocodingParser
//
//  Created by Rastaar Haghi on 7/1/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

#import "NBGeocoderMetadataParser.h"

@implementation NBGeocoderMetadataParser {
 @private
  SQLiteDatabaseConnection *_databaseConnection;
}

- (instancetype)init {
  self = [super init];
  return self;
}

- (void)convertFileToSQLiteDatabase:(NSString *)completeTextFilePath
                       withFileName:(NSString *)textFileName
                       withLanguage:(NSString *)languageCode {
  NSString *fileName = completeTextFilePath;
  NSData *data = [NSData dataWithContentsOfFile:fileName];
  NSString *myStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSMutableArray<NSString *> *countryCodes =
      (NSMutableArray *)[textFileName componentsSeparatedByString:@"."];
  NSString *countryCode = countryCodes[0];
  _databaseConnection = [[SQLiteDatabaseConnection alloc] initWithCountryCode:countryCode
                                                                 withLanguage:languageCode];
  @autoreleasepool {
    // This program splits each line of the text file into the two important pieces of info:
    // phone number prefix and the corresponding region description.
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSArray *mArr = [myStr componentsSeparatedByCharactersInSet:separator];
    NSMutableArray<NSString *> *keyValuePair = [[NSMutableArray alloc] init];

    NSString *key = [[NSString alloc] init];
    NSString *value = [[NSString alloc] init];
    BOOL indexNeededFlag = YES;
    for (NSString *str in mArr) {
      @autoreleasepool {
        // This program skips entries if they are invalid or improperly formatted.
        if (([str length] > 0) && ([str characterAtIndex:0] == '#')) {
          continue;
        }
        keyValuePair = (NSMutableArray *)[str componentsSeparatedByString:@"|"];
        if ([keyValuePair count] != 2) {
          continue;
        }
        key = [keyValuePair[0]
            stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        value = [keyValuePair[1]
            stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [_databaseConnection addEntryToDB:key
                          withDescription:value
                    withShouldCreateTable:indexNeededFlag
                          withCountryCode:(NSString *)countryCode];
        [keyValuePair removeAllObjects];
        indexNeededFlag = NO;
      }
    }
  }
  return;
}

@end
