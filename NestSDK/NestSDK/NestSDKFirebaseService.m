// Copyright (c) 2016 Petro Akzhygitov <petro.akzhygitov@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Firebase/Firebase.h>
#import "NestSDKFirebaseService.h"
#import "NestSDKAccessToken.h"
#import "NestSDKLogger.h"


@implementation NestSDKFirebaseService
#pragma mark Initializer

- (instancetype)initWithFirebase:(Firebase *)firebase accessToken:(NestSDKAccessToken *)accessToken {
    self = [super init];
    if (self) {
        _firebase = firebase;
        _accessToken = accessToken;

        if (accessToken) {
            [self authenticateWithAccessToken:accessToken];
        }
    }

    return self;
}

- (instancetype)initWithFirebase:(Firebase *)firebase {
    return [self initWithFirebase:firebase accessToken:nil];
}

#pragma mark Override

- (void)setAccessToken:(NestSDKAccessToken *)accessToken {
    _accessToken = accessToken;

    if (accessToken) {
        [self authenticateWithAccessToken:accessToken];
    }
}

#pragma mark Public

- (void)authenticateWithAccessToken:(NestSDKAccessToken *)accessToken {
    // WARNING: Do not call unathenticate method while making re-authentication

    if (!accessToken) return;

    [NestSDKLogger logInfo:@"Authenticating..." from:self];

    [self.firebase authWithCustomToken:accessToken.tokenString withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (error) {
            [NestSDKLogger logError:@"Authentication failed!" withErorr:error from:self];

            return;
        }

        [NestSDKLogger logInfo:@"Authentication successful!" from:self];
    }];
}

- (void)unauthenticate {
    [self removeAllObservers];

    [self.firebase unauth];

    [NestSDKLogger logInfo:@"Unauthenticated!" from:self];
}

- (void)valuesForURL:(NSString *)url withBlock:(NestSDKServiceUpdateBlock)block {
    Firebase *firebase = [self.firebase childByAppendingPath:url];

    [firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        block(snapshot.value, nil);

    }                  withCancelBlock:^(NSError *error) {
        block(nil, error);
    }];
}

- (void)setValues:(NSDictionary *)values forURL:(NSString *)url withBlock:(NestSDKServiceUpdateBlock)block {
    Firebase *firebase = [self.firebase childByAppendingPath:url];

    // IMPORTANT to set withLocalEvents to NO.
    // More information here: https://www.firebase.com/docs/transactions.html
    [firebase runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
        [currentData setValue:values];

        return [FTransactionResult successWithValue:currentData];

    }          andCompletionBlock:^(NSError *error, BOOL committed, FDataSnapshot *snapshot) {
        block(snapshot.value, error);

    }             withLocalEvents:NO];
}

- (NestSDKObserverHandle)observeValuesForURL:(NSString *)url withBlock:(NestSDKServiceUpdateBlock)block {
    Firebase *firebase = [self.firebase childByAppendingPath:url];

    return [firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        block(snapshot.value, nil);

    }                 withCancelBlock:^(NSError *error) {
        block(nil, error);
    }];
}

- (void)removeObserverWithHandle:(NestSDKObserverHandle)handle {
    [self.firebase removeObserverWithHandle:handle];
}

- (void)removeAllObservers {
    [self.firebase removeAllObservers];
}

@end