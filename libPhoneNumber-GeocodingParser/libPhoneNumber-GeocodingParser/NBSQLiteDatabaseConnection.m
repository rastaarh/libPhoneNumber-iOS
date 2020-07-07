//
//  NBSQLiteDatabaseConnection.m
//  libPhoneNumber-GeocodingParser
//
//  Created by Rastaar Haghi on 7/1/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

#import "NBSQLiteDatabaseConnection.h"

@implementation NBSQLiteDatabaseConnection {
 @private
  NSString *_databasePath;
  sqlite3 *_DB;
  sqlite3_stmt *_insertStatement;
  int _sqliteDatabaseCode;
}

static NSString *const insertPreparedStatement = @"INSERT INTO geocodingPairs%@"
                                                 @"(NATIONALNUMBER, DESCRIPTION)"
                                                 @"VALUES "
                                                 @"(?, ?)";

static NSString *const createTablePreparedStatement =
    @"CREATE TABLE IF NOT EXISTS geocodingPairs%@ (ID INTEGER PRIMARY KEY "
    @"AUTOINCREMENT, "
    @"NATIONALNUMBER TEXT, DESCRIPTION TEXT)";
static NSString *const createIndexStatement = @"CREATE INDEX IF NOT EXISTS nationalNumberIndex ON "
                                              @"geocodingPairs%@(NATIONALNUMBER)";

- (instancetype)initWithCountryCode:(NSString *)countryCode
                       withLanguage:(NSString *)language
             withDesiredDestination:(NSString *)desiredDestination {
  self = [super init];
  if (self != nil) {
    NSString *databasePath = [[NSString alloc]
        initWithString:[NSString stringWithFormat:@"%@/%@.db", desiredDestination, language]];
    _sqliteDatabaseCode = sqlite3_open([databasePath UTF8String], &_DB);
      
    if (_sqliteDatabaseCode == SQLITE_OK) {
      [self createTable:countryCode];
      const char *formattedPreparedStatement =
          [[NSString stringWithFormat:insertPreparedStatement, countryCode] UTF8String];
      sqlite3_prepare_v2(_DB, formattedPreparedStatement, -1, &_insertStatement, NULL);
    } else {
      NSLog(@"Cannot open database at desired location: %@. \n"
            @"SQLite3 Error Message: %s",
            desiredDestination, sqlite3_errstr(_sqliteDatabaseCode));
    }
  }
  return self;
}

- (void)addEntryToDB:(NSString *)phoneNumber
     withDescription:(NSString *)description
     withCountryCode:(NSString *)countryCode {
  if (_sqliteDatabaseCode != SQLITE_OK) {
    NSLog(@"Cannot open database. Failed to add entry. \n"
          @"SQLite3 Error Message: %s",
          sqlite3_errstr(_sqliteDatabaseCode));
    return;
  }
  int commandResults = [self createInsertStatement:phoneNumber withDescription:description];
  if (commandResults != SQLITE_OK) {
    NSLog(@"Error when creating insert statement: %s", sqlite3_errstr(commandResults));
  }
  sqlite3_step(_insertStatement);
}

- (void)dealloc {
  sqlite3_finalize(_insertStatement);
  sqlite3_close_v2(_DB);
}

- (void)createTable:(NSString *)countryCode {
  NSString *createTable = [NSString stringWithFormat:createTablePreparedStatement, countryCode];

  const char *sqliteCreateTableStatement = [createTable UTF8String];
  char *sqliteErrorMessage;
  if (sqlite3_exec(_DB, sqliteCreateTableStatement, NULL, NULL, &sqliteErrorMessage) != SQLITE_OK) {
    NSLog(@"Error creating table, %s", sqliteErrorMessage);
  }

  NSString *createIndexQuery = [NSString stringWithFormat:createIndexStatement, countryCode];
  const char *SQLCreateIndexStatement = [createIndexQuery UTF8String];
  if (sqlite3_exec(_DB, SQLCreateIndexStatement, NULL, NULL, &sqliteErrorMessage) != SQLITE_OK) {
    NSLog(@"Error occurred when applying index to nationalnumber column: %s", sqliteErrorMessage);
  }
}

- (int)resetInsertStatement {
  sqlite3_reset(_insertStatement);
  return sqlite3_clear_bindings(_insertStatement);
}

- (int)createInsertStatement:(NSString *)phoneNumber withDescription:(NSString *)description {
  int sqliteResultCode = [self resetInsertStatement];
  if (sqliteResultCode != SQLITE_OK) {
    NSLog(@"SQLite3 error occurred when resetting and clearing bindings in "
          @"insert statement: %s",
          sqlite3_errstr(sqliteResultCode));
  } else {
    sqlite3_bind_text(_insertStatement, 1, [phoneNumber UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(_insertStatement, 2, [description UTF8String], -1, SQLITE_TRANSIENT);
  }
  return sqliteResultCode;
}

@end
