//
//  SQLiteDatabaseConnection.h
//  libPhoneNumber-GeocodingParser
//
//  Created by Rastaar Haghi on 7/1/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface SQLiteDatabaseConnection : NSObject

- (instancetype)initWithCountryCode:(NSString *)countryCode
                       withLanguage:(NSString *)language;
- (void)addEntryToDB:(NSString *)phoneNumber
          withDescription:(NSString *)description
    withShouldCreateTable:(BOOL)createIndex
          withCountryCode:(NSString *)countryCode;
@end

NS_ASSUME_NONNULL_END
