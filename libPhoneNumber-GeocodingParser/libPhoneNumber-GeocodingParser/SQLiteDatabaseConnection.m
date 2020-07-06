//
//  SQLiteDatabaseConnection.m
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
}

static NSString *const insertPreparedStatement = @"INSERT INTO geocodingPairs%@"
                                                 @"( "
                                                 @"NATIONALNUMBER, "
                                                 @"DESCRIPTION"
                                                 @")"
                                                 @"VALUES "
                                                 @"("
                                                 @"?,"
                                                 @"?"
                                                 @")";

static NSString *const createTablePreparedStatement =
    @"CREATE TABLE IF NOT EXISTS geocodingPairs%@ (ID INTEGER PRIMARY KEY "
    @"AUTOINCREMENT, "
    @"NATIONALNUMBER TEXT, DESCRIPTION TEXT)";
static NSString *const createIndexStatement =
    @"CREATE INDEX IF NOT EXISTS nationalNumberIndex ON "
    @"geocodingPairs%@(NATIONALNUMBER)";

- (instancetype)initWithCountryCode:(NSString *)countryCode
                       withLanguage:(NSString *)language {
  self = [super init];
  if (self != nil) {
    NSArray *directoryPath = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = directoryPath[0];
    NSString *databasePath = [[NSString alloc]
        initWithString:[NSString stringWithFormat:@"%@/geocoding/%@.db",
                                                  documentDirectory, language]];

    sqlite3_open([databasePath UTF8String], &_DB);

    [self createTable:countryCode];
    sqlite3_prepare_v2(_DB,
                       [[NSString stringWithFormat:insertPreparedStatement,
                                                   countryCode] UTF8String],
                       -1, &_insertStatement, NULL);
  }
  return self;
}

- (void)addEntryToDB:(NSString *)phoneNumber
          withDescription:(NSString *)description
    withShouldCreateTable:(BOOL)shouldCreateTable
          withCountryCode:(NSString *)countryCode {
  @autoreleasepool {
    int SQLCommandResults = [self createInsertStatement:phoneNumber
                                        withDescription:description];
    if (SQLCommandResults != SQLITE_OK) {
      NSLog(@"Error when creating insert statement: %s",
            sqlite3_errstr(SQLCommandResults));
    }
    sqlite3_step(_insertStatement);
  }
}

- (void)dealloc {
  sqlite3_finalize(_insertStatement);
  sqlite3_close_v2(_DB);
}

- (int)resetInsertStatement {
  sqlite3_reset(_insertStatement);
  return sqlite3_clear_bindings(_insertStatement);
}

- (void)createTable:(NSString *)countryCode {
  NSString *createTable =
      [NSString stringWithFormat:createTablePreparedStatement, countryCode];
  // create table
  const char *sqliteCreateTableStatement = [createTable UTF8String];
  char *sqliteErrorMessage;
  if (sqlite3_exec(_DB, sqliteCreateTableStatement, NULL, NULL,
                   &sqliteErrorMessage) != SQLITE_OK) {
    NSLog(@"Error creating table, %s", sqliteErrorMessage);
  }

  NSString *createIndexQuery =
      [NSString stringWithFormat:createIndexStatement, countryCode];
  const char *SQLCreateIndexStatement = [createIndexQuery UTF8String];
  if (sqlite3_exec(_DB, SQLCreateIndexStatement, NULL, NULL,
                   &sqliteErrorMessage) != SQLITE_OK) {
    NSLog(@"Error occurred when applying index to nationalnumber column: %s",
          sqliteErrorMessage);
  }
}

- (int)createInsertStatement:(NSString *)phoneNumber
             withDescription:(NSString *)description {
  int sqliteResultCode;
  @autoreleasepool {
    sqliteResultCode = [self resetInsertStatement];
    if (sqliteResultCode != SQLITE_OK) {
      NSLog(@"SQLite3 error occurred when resetting and clearing bindings in "
            @"insert statement: %s",
            sqlite3_errstr(sqliteResultCode));
    } else {
        sqlite3_bind_text(_insertStatement, 1, [phoneNumber UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(_insertStatement, 2, [description UTF8String], -1, SQLITE_TRANSIENT);
    }
  }
    NSLog(@"%s", sqlite3_expanded_sql(_insertStatement));
  return sqliteResultCode;
}

@end
