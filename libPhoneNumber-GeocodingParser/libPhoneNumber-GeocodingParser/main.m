//
//  main.m
//  libPhoneNumber-GeocodingParser
//
//  Created by Rastaar Haghi on 7/1/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
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
    for (NSString *language in languages) {
      textFilesAvailable = [[NSFileManager defaultManager]
          contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@%@", geocodingFolder, language]
                              error:NULL];
      [textFilesAvailable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"txt"]) {
          [metadataParser
              convertFileToSQLiteDatabase:[NSString stringWithFormat:@"%@%@/%@", geocodingFolder,
                                                                     language, filename]
                             withFileName:filename
                             withLanguage:language];
        }
      }];
    }
  }

  return 0;
}
