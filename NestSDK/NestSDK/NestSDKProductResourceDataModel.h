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

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import <CoreGraphics/CGBase.h>
#import <NestSDK/NestSDKProductResource.h>
#import "NestSDKDataModel.h"

/**
 * An object containing the resource use type (electricity, gas, water), with data values and measurement timestamps.
 */
@interface NestSDKProductResourceDataModel : NestSDKDataModel <NestSDKProductResource>
#pragma mark Properties

/**
 * Number of resource units consumed in the time period (where time period is measurementTime - measurementResetTime).
 * The unit of measure for this value is defined during company verification, typically joules or liters:
 *      electricity (joules)
 *      gas (joules)
 *      water (liters)
 */
@property(nonatomic) CGFloat value;

/**
 * Timestamp that identifies the start of the measurement time period, in ISO 8601 format.
 * Generally you won't change this value, except in the rare case that connectivity or power to the device is lost.
 */
@property(nonatomic, copy) NSDate <Optional> *measurementResetTime;

/**
 * Timestamp that identifies the measurement time (the time when the resource use data was measured), in ISO 8601 format.
 */
@property(nonatomic, copy) NSDate <Optional> *measurementTime;

@end