//
//  APCountryCodeImporter.m
//  APReverseGeocodingExample
//
//  Created by Sergii Kryvoblotskyi on 4/15/15.
//  Copyright (c) 2015 Sergii Kryvoblotskyi. All rights reserved.
//

#import "APCountryInfoBuilder.h"

@interface APCountryInfoBuilder ()

/* Represents the country code */
@property (nonatomic, copy) NSString *code;

/* Represents country locale from code */
@property (nonatomic, strong) NSLocale *countryLocale;

@end

@implementation APCountryInfoBuilder

+ (instancetype)builderWithCountryCode:(NSString *)countryCode
{
    return [[self alloc] initWithCountryCode:countryCode];
}

- (instancetype)initWithCountryCode:(NSString *)countryCode
{
    self = [super init];
    if (self) {
        _code = countryCode;
    }
    return self;
}

#pragma mark - Public

- (NSDictionary *)build
{
    if (!self.code) {
        return nil;
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    NSString *shortCode = [self _import2DigitsCode];
    if (shortCode) {
        [dictionary setObject:shortCode forKey:APCountryInfoBuilderISO31661Alpha2Key];
    }
    
    NSString *localizedName = [self _importLocalizedCountryName];
    if (localizedName) {
        [dictionary setObject:localizedName forKey:APCountryInfoBuilderLocalizedNameKey];
    }
    
    NSString *currencyCode = [self _importCurrencyCode];
    if (currencyCode) {
        [dictionary setObject:currencyCode forKey:APCountryInfoBuilderCurrencyCode];
    }
    return [dictionary copy];
}

#pragma mark - Private

- (NSString *)_import2DigitsCode
{
    NSString *countryCode = [self.countryLocale objectForKey: NSLocaleCountryCode];
    return countryCode;
}

- (NSString *)_importCurrencyCode
{
    NSString *countryCode = [self.countryLocale objectForKey: NSLocaleCurrencyCode];
    return countryCode;
}

- (NSString *)_importLocalizedCountryName
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    NSString *localizedCountryName = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
    return localizedCountryName;
}

#pragma mark - Accessors

- (NSLocale *)countryLocale
{
    if (!_countryLocale) {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: @{NSLocaleCountryCode: self.code}];
        _countryLocale = [NSLocale localeWithLocaleIdentifier:identifier];
    }
    return _countryLocale;
}

@end