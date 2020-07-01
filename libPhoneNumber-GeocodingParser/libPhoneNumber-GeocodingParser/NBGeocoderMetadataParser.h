//
//  NBGeocoderMetadataParser.h
//  libPhoneNumber-GeocodingParser
//
//  Created by Rastaar Haghi on 7/1/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

#import "SQLiteDatabaseConnection.h"

NS_ASSUME_NONNULL_BEGIN

@interface NBGeocoderMetadataParser : NSObject

- (instancetype)init;
- (void)convertFileToSQLiteDatabase:(NSString*)metaData
                       withFileName:(NSString*)textFile
                       withLanguage:(NSString*)language;
@end

NS_ASSUME_NONNULL_END
