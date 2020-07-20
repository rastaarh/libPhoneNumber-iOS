//
//  main.m
//  libPhoneNumber-GeocodingParser
//
//  Created by Rastaar Haghi on 7/1/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBGeocoderMetadataParser.h"
#import "SSZipArchive.h"

int main(int argc, const char *argv[]) {
  @autoreleasepool {
      
      // Save zip file to NSData
      NSString *stringURL = @"https://github.com/google/libphonenumber/archive/master.zip";
      NSURL  *githubURL = [NSURL URLWithString:stringURL];
      NSData *githubRepoData = [NSData dataWithContentsOfURL:githubURL];
      NSLog(@"Repository Data gathered: %@", githubRepoData.description);
      
      // Gather the documents directory path
      NSString *temporaryDirectoryPath = NSTemporaryDirectory();
      NSString *zipFilePath = [temporaryDirectoryPath stringByAppendingPathComponent:@"/libPhoneNumber-iOS.zip"];
      zipFilePath = [zipFilePath stringByStandardizingPath];
      [githubRepoData writeToFile:zipFilePath atomically:YES];
      
      
      // At this point, zip file properly saved to: /Users/rastaar/Documents/libPhoneNumber-iOS.zip
      NSLog(@"Temporary path: %@", temporaryDirectoryPath);
      [SSZipArchive unzipFileAtPath:zipFilePath toDestination:temporaryDirectoryPath];
      //Save the data
      NSLog(@"Saving");
      
      NSString *folderPath = [NSString stringWithFormat:@"%@/libphonenumber-master", temporaryDirectoryPath];
      NSLog(@"FOLDER: %@", folderPath);
      NSArray *filesInDirectory =
                [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath
                                                                    error:NULL];
      if([filesInDirectory containsObject:@"resources"]) {
          NSString *resourceFilePath = [NSString stringWithFormat:@"%@/resources", folderPath];
          NSLog(@"%@", resourceFilePath);
          filesInDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourceFilePath
                                                                                 error: NULL];
          if([filesInDirectory containsObject:@"geocoding"]) {
              NSString *geocodingFolderPath = [NSString stringWithFormat:@"%@/geocoding", resourceFilePath];
              NSLog(@"%@", geocodingFolderPath);
                NSArray *languages =
                    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:geocodingFolderPath
                                                                        error:NULL];
              NSURL *databaseDesiredLocation = [NSURL fileURLWithPath:@(argv[1])];
              NBGeocoderMetadataParser *metadataParser =
                        [[NBGeocoderMetadataParser alloc] initWithDestinationPath:[databaseDesiredLocation copy]];
                NSArray *textFilesAvailable;
                NSString *languageFolderPath;
                for (NSString *language in languages) {
                  NSLog(@"Creating SQLite database file for the language: %@", language);
                  languageFolderPath =
                      [NSString stringWithFormat:@"%@/%@", geocodingFolderPath, language];
                  textFilesAvailable =
                      [[NSFileManager defaultManager] contentsOfDirectoryAtPath:languageFolderPath
                                                                          error:NULL];
                  for (NSString *filename in textFilesAvailable) {
                    NSString *extension = [[filename pathExtension] lowercaseString];
          
                    if ([extension isEqualToString:@"txt"]) {
                      NSString *completeFilePath =
                          [NSString stringWithFormat:@"%@/%@", languageFolderPath, filename];
                      [metadataParser convertFileToSQLiteDatabase:completeFilePath
                                                     withFileName:filename
                                                     withLanguage:language];
                    }
                  }
                  NSLog(@"Created SQLite database file for the language: %@", language);
              }
            }
          }
      }
      
      
//    if (argc != 3) {
//      NSLog(@"The libPhoneNumber-iOS Geocoder Parser requires two input arguments to properly "
//            @"function.");
//      NSLog(@"1. The complete folder path where the libPhoneNumber geocoding resource folder "
//            @"(found at: https://github.com/google/libphonenumber/tree/master/resources/geocoding) "
//            @"is stored on disk.");
//      NSLog(@"2. The complete directory path to the desired location to store the corresponding "
//            @"SQLite databases created.");
//      NSLog(@"Example arguments: Users/JohnDoe/Documents/geocoding Users/JohnDoe/Desktop");
//    } else {
//
//
//
//
//
//
//
//
//
//
//
//      NSString *geocodingMetadataDirectory = @(argv[1]);
//      NSURL *databaseDesiredLocation = [NSURL fileURLWithPath:@(argv[2])];
//      NBGeocoderMetadataParser *metadataParser =
//          [[NBGeocoderMetadataParser alloc] initWithDestinationPath:[databaseDesiredLocation copy]];
//      NSError *error;
//      NSArray *languages =
//          [[NSFileManager defaultManager] contentsOfDirectoryAtPath:geocodingMetadataDirectory
//                                                              error:&error];
//      if (error != NULL) {
//        NSLog(@"Error occurred when trying to read directory: %@"
//              @"Error message: %@",
//              geocodingMetadataDirectory, [error localizedDescription]);
//        return 1;
//      }
//      NSArray *textFilesAvailable;
//      NSString *languageFolderPath;
//      for (NSString *language in languages) {
//        NSLog(@"Creating SQLite database file for the language: %@", language);
//        languageFolderPath =
//            [NSString stringWithFormat:@"%@/%@", geocodingMetadataDirectory, language];
//        textFilesAvailable =
//            [[NSFileManager defaultManager] contentsOfDirectoryAtPath:languageFolderPath
//                                                                error:&error];
//        if (error != NULL) {
//          NSLog(@"Error occurred when trying to read files for the language directory: %@",
//                languageFolderPath);
//          error = NULL;
//          continue;
//        }
//        for (NSString *filename in textFilesAvailable) {
//          NSString *extension = [[filename pathExtension] lowercaseString];
//
//          if ([extension isEqualToString:@"txt"]) {
//            NSString *completeFilePath =
//                [NSString stringWithFormat:@"%@/%@", languageFolderPath, filename];
//            [metadataParser convertFileToSQLiteDatabase:completeFilePath
//                                           withFileName:filename
//                                           withLanguage:language];
//          }
//        }
//        NSLog(@"Created SQLite database file for the language: %@", language);
//    }
//  }

  return 0;
}
