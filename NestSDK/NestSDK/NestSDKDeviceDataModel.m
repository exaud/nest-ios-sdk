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

#import "NestSDKDeviceDataModel.h"
#import "NestSDKUtils.h"

@implementation NestSDKDeviceDataModel
#pragma mark Override

- (void)copyPropertiesToDataModelCopy:(id <NestSDKDataModelProtocol>)copy {
    [super copyPropertiesToDataModelCopy:copy];

    NestSDKDeviceDataModel *deviceDataModelCopy = (NestSDKDeviceDataModel *) copy;
    deviceDataModelCopy.deviceId = self.deviceId;
    deviceDataModelCopy.softwareVersion = self.softwareVersion;
    deviceDataModelCopy.structureId = self.structureId;
    deviceDataModelCopy.name = self.name;
    deviceDataModelCopy.nameLong = self.nameLong;
    deviceDataModelCopy.isOnline = self.isOnline;
    deviceDataModelCopy.whereId = self.whereId;
}

- (NSUInteger)hash {
    NSUInteger intValueForYes = 1231;
    NSUInteger intValueForNo = 1237;

    NSUInteger prime = 31;
    NSUInteger result = 1;

    result = prime * result + self.deviceId.hash;
    result = prime * result + self.softwareVersion.hash;
    result = prime * result + self.structureId.hash;
    result = prime * result + self.name.hash;
    result = prime * result + self.nameLong.hash;
    result = prime * result + (self.isOnline ? intValueForYes : intValueForNo);
    result = prime * result + self.whereId.hash;

    return result;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;

    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    NestSDKDeviceDataModel *otherDevice = (NestSDKDeviceDataModel *) other;
    return ([NestSDKUtils object:self.deviceId isEqualToObject:otherDevice.deviceId] &&
            ([NestSDKUtils object:self.softwareVersion isEqualToObject:otherDevice.softwareVersion]) &&
            ([NestSDKUtils object:self.structureId isEqualToObject:otherDevice.structureId]) &&
            ([NestSDKUtils object:self.name isEqualToObject:otherDevice.name]) &&
            ([NestSDKUtils object:self.nameLong isEqualToObject:otherDevice.nameLong]) &&
            (self.isOnline == otherDevice.isOnline) &&
            ([NestSDKUtils object:self.whereId isEqualToObject:otherDevice.whereId]));
}

@end