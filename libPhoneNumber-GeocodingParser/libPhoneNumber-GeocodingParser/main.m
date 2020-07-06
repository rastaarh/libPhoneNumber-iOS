//
//  main.m
//  libPhoneNumber-GeocodingParser
//
//  Created by Rastaar Haghi on 7/1/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBGeocoderMetadataParser.h"

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    NBGeocoderMetadataParser *metadataParser = [[NBGeocoderMetadataParser alloc] init];
    NSArray *dirPaths =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = dirPaths[0];
    NSString *geocodingFolder = [documents stringByAppendingFormat:@"/geocoding/"];
    NSArray *languages = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:geocodingFolder
                                                                             error:NULL];

    NSArray *textFilesAvailable;
    NSString *languageFolderPath;
    for (NSString *language in languages) {
      languageFolderPath = [NSString stringWithFormat:@"%@%@", geocodingFolder, language];

      textFilesAvailable =
          [[NSFileManager defaultManager] contentsOfDirectoryAtPath:languageFolderPath error:NULL];
      [textFilesAvailable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];

        if ([extension isEqualToString:@"txt"]) {
          NSString *completeFilePath =
              [NSString stringWithFormat:@"%@%@/%@", geocodingFolder, language, filename];
          [metadataParser convertFileToSQLiteDatabase:completeFilePath
                                         withFileName:filename
                                         withLanguage:language];
        }
      }];
    }
  }

  return 0;
}
