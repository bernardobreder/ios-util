//
//  Time.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 23/02/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "Time.h"

//#define DAYS_OF_FEV(Y) (28 + ((((((Y) % 4) == 0) && ((Y) % 100) != 0) || (((Y) % 400) == 0)) ? 1 : 0))
//#define DAYS_OF_MONTHS(M,Y) (((M) == 0 || (M) == 2 || (M) == 4 || (M) == 6 || (M) == 7 || (M) == 9 || (M) == 11)) ? (31) : (((M) == 3 || (M) == 5 || (M) == 8 || (M) == 10) ? (30) : DAYS_OF_FEV(Y))

@implementation Time

@end

@implementation MonthTime

+ (NSUInteger)timeWithYear:(NSUInteger)year andMonth:(NSUInteger)month
{
    return year * 100 + month;
}

- (id)initWithTime:(NSUInteger )time
{
    self = [super init];
    _time = time;
    return self;
}

- (id)initWithYear:(NSUInteger)year andMonth:(NSUInteger)month
{
    self = [super init];
    _time = year * 100 + month;
    return self;
}

- (NSUInteger)lastDayOfMonth
{
    return [DayTime lastDayOfMonth:[self month] andYear:[self year]];
}

- (NSUInteger )time
{
    return _time;
}

- (NSUInteger)month
{
    return _time - (_time / 100) * 100;
}

- (NSUInteger)year
{
    return _time / 100;
}

- (void)setMonth:(NSUInteger)month
{
    _time = (_time / 100) * 100 + month;
}

- (void)setYear:(NSUInteger)year
{
    _time = year * 100 + (_time - (_time / 100) * 100);
}

- (void)getYear:(NSUInteger*)year andMonth:(NSUInteger*)month
{
    NSInteger selfYear = _time / 100;
    NSInteger selfMonth = _time - selfYear * 100;
    if (year) {
        *year = selfYear;
    }
    if (month) {
        *month = selfMonth;
    }
}

- (void)addMonth:(NSInteger)count
{
    NSInteger year = _time / 100;
    NSInteger month = _time - year * 100;
    NSInteger newMonth = (month + count) % 12;
    NSInteger incYear = (month + count) / 12;
    _time = (year + incYear) * 100 + newMonth;
}

- (void)addYear:(NSInteger)count
{
    _time = (_time / 100 + count) * 100 + (_time - (_time / 100) * 100);
}

- (MonthTime*)monthTimeAdded:(NSUInteger)count
{
	MonthTime *time = [self clone];
	[time addMonth:count];
	return time;
}

- (NSUInteger)getElapsedMonths:(MonthTime*)time
{
    return _time < time->_time ? time->_time - _time : _time - time->_time;
}

- (DayTime*)firstDayTime
{
    return [[DayTime alloc] initWithYear:[self year] andMonth:[self month] andDay:1];
}

- (DayTime*)lastDayTime
{
    NSUInteger year, month;
    [self getYear:&year andMonth:&month];
    NSUInteger day = [DayTime lastDayOfMonth:month andYear:year];
    return [[DayTime alloc] initWithYear:year andMonth:month andDay:day];
}

- (NSUInteger)numberOfWeeks
{
    return ceil(((double)(self.firstDayTime.dayOfWeek + self.lastDayOfMonth) / 7));
}

- (MonthTime*)clone
{
    return [[MonthTime alloc] initWithTime:_time];
}

- (BOOL)isEqual:(id)other
{
    if (other == self) return YES;
    if (!other || ![other isKindOfClass:[self class]]) return NO;
    MonthTime *monthTime = (MonthTime*)other;
    return _time == monthTime->_time;
}

- (NSUInteger)hash
{
    return _time;
}

+ (NSString*)stringShortForMonth:(NSUInteger)month
{
    switch (month) {
        case 0: return @"Jan";
        case 1: return @"Fev";
        case 2: return @"Mar";
        case 3: return @"Abr";
        case 4: return @"Mai";
        case 5: return @"Jun";
        case 6: return @"Jul";
        case 7: return @"Ago";
        case 8: return @"Set";
        case 9: return @"Out";
        case 10: return @"Nov";
        case 11: return @"Dez";
        default: return nil;
    }
}

- (NSString *)description
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"%04lu/%02lu", (unsigned long)[self year], (long)[self month] + 1];
    return string;
}

@end

@implementation DayTime

- (id)initNow
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger day = (int)[components day];
    NSInteger month = (int)[components month] - 1;
    NSInteger year = (int)[components year];
    _time = year * 10000 + month * 100 + day;
    return self;
}

- (id)initWithTime:(NSUInteger)time
{
    self = [super init];
    _time = time;
    return self;
}

- (id)initWithYear:(NSUInteger)year andMonth:(NSUInteger)month andDay:(NSUInteger)day
{
    self = [super init];
    _time = year * 10000 + month * 100 + day;
    return self;
}

- (NSUInteger )time
{
    return _time;
}

- (NSUInteger)day
{
    return _time - (_time / 10000) * 10000 - ((_time / 100) * 100 - (_time / 10000) * 10000);
}

- (NSUInteger)month
{
    return _time / 100 - (_time / 10000) * 100;
}

- (NSUInteger)year
{
    return _time / 10000;
}

- (void)setDay:(NSUInteger)day
{
    _time = (_time / 10000) * 10000 + (_time / 100 - (_time / 10000) * 100) * 100 + day;
}

- (void)setMonth:(NSUInteger)month
{
    _time = (_time / 10000) * 10000 + month * 100 + (_time - (_time / 10000) * 10000 - ((_time / 100) * 100 - (_time / 10000) * 10000));
}

- (void)setYear:(NSUInteger)year
{
    _time = year * 10000 + (_time / 100 - (_time / 10000) * 100) * 100 + (_time - (_time / 10000) * 10000 - ((_time / 100) * 100 - (_time / 10000) * 10000));
}

- (NSUInteger)lastDayOfMonth
{
	NSUInteger year, month;
	[self getYear:&year andMonth:&month andDay:0];
    return [DayTime lastDayOfMonth:month andYear:year];
}

- (void)getYear:(NSUInteger*)year andMonth:(NSUInteger*)month andDay:(NSUInteger*)day
{
    unsigned short selfYear = _time / 10000;
    unsigned short selfMonth = (_time - (selfYear * 10000)) / 100;
    unsigned short selfDay = _time - (selfYear * 10000) - (selfMonth * 100);
    if (year) *year = selfYear;
    if (month) *month = selfMonth;
    if (day) *day = selfDay;
}

- (NSUInteger)dayOfWeek
{
    NSUInteger y, m, d;
    [self getYear:&y andMonth:&m andDay:&d];
    if (y >= 2000) {
        NSInteger cd = 6;
        NSInteger cy = 2000;
        while (cy < y) {
            cd += [DayTime lastDayOfMonth:1 andYear:cy] + 7 * 31 + 4 * 30;
            cy++;
        }
        NSInteger cm = 0;
        while (cm < m) {
            cd += [DayTime lastDayOfMonth:cm andYear:cy];
            cm++;
        }
        cd += d - 1;
        return cd % 7;
    } else {
        NSInteger cd = 0;
        NSInteger cy = 2000 - 1;
        while (cy >= y) {
            cd += [DayTime lastDayOfMonth:1 andYear:cy] + 7 * 31 + 4 * 30;
            cy--;
        }
        NSInteger cm = 0;
        while (cm < m) {
            cd -= [DayTime lastDayOfMonth:cm andYear:cy];
            cm++;
        }
        cd += d - 1;
        cd = cd % 7;
        return 6 - cd;
    }
}

- (NSUInteger)weekOfMonth
{
	return [self numberOfWeeks:(self.monthTime.firstDayTime)] - 1;
}

- (NSUInteger)numberOfWeeks:(DayTime*)dayTime
{
    NSInteger compare = [self compare:dayTime];
    if (compare == 0) return 1;
    if (compare > 0) {
        return [dayTime numberOfWeeks:self];
    }
	DayTime *aux = self.clone;
	NSUInteger n = aux.dayOfWeek;
	NSInteger dayMonth = dayTime.month;
	NSInteger dayYear = dayTime.year;
	if (aux.month != dayMonth || aux.year != dayYear) {
		n += -aux.day + 1;
		do {
			n += aux.lastDayOfMonth;
			[aux addMonth:1];
		} while (aux.month != dayMonth || aux.year != dayYear);
		aux.day = 1;
	}
	n += dayTime.day - aux.day + 1;
	n = ceil(((double)n / 7));
	return n;
}

- (NSUInteger)numberOfWeeksFromCalendar:(DayTime*)dayTime
{
    NSUInteger numberOfWeeks = [self numberOfWeeks:dayTime];
	MonthTime *startMonthTime = self.monthTime;
	MonthTime *endMonthTime = dayTime.monthTime;
	NSUInteger months = [endMonthTime getElapsedMonths:startMonthTime];
	MonthTime *auxMonthTime = [startMonthTime clone];
	for (NSUInteger n = 0 ; n < months ; n++) {
		if (auxMonthTime.lastDayTime.dayOfWeek != 6) {
			numberOfWeeks++;
		}
		[auxMonthTime addMonth:1];
	}
	return numberOfWeeks;
}

- (void)incDay
{
	NSUInteger year, month, day;
    [self getYear:&year andMonth:&month andDay:&day];
	if (day >= 28 && day == [DayTime lastDayOfMonth:month andYear:year]) {
		day = 1;
		if (month == 11) {
			month = 0;
			year++;
		}
		else {
			month++;
		}
	} else {
		day++;
	}
	_time = year * 10000 + month * 100 + day;
}

- (void)addDay:(NSInteger)count
{
    if (count == 0) {
        return;
    }
	NSUInteger year, month, day;
    [self getYear:&year andMonth:&month andDay:&day];
    if (count > 0) {
        while (count > 0) {
            NSInteger delta = MIN(count, [DayTime lastDayOfMonth:month andYear:year] - day);
            count -= delta;
            day += delta;
            if (count == 0) {
                break;
            }
            count--;
            day = 1;
            if (month == 11) {
                month = 0;
                year++;
            }
            else {
                month++;
            }
        }
    }
    else {
        while (count < 0) {
            NSInteger delta = MIN(-count, day - 1);
            count += delta;
            day -= delta;
            if (count == 0) {
                break;
            }
            count++;
            if (month == 0) {
                month = 11;
                year--;
            }
            else {
                month--;
            }
            day = [DayTime lastDayOfMonth:month andYear:year];
        }
    }
    _time = year * 10000 + month * 100 + day;
}

- (void)addMonth:(NSInteger)count
{
    if (count == 0) {
        return;
    }
	NSUInteger year, month, day;
    [self getYear:&year andMonth:&month andDay:&day];
    if (count > 0) {
        while (count > 0) {
            NSInteger delta = MIN(count, 11 - month);
            count -= delta;
            month += delta;
            if (count == 0) {
                break;
            }
            count--;
            month = 0;
            year++;
        }
    }
    else {
        while (count < 0) {
            NSInteger delta = MIN(-count, month);
            count += delta;
            month -= delta;
            if (count == 0) {
                break;
            }
            count++;
            month = 11;
            year--;
        }
    }
    NSInteger lastDayOfMonth = [DayTime lastDayOfMonth:month andYear:year];
    if (day > lastDayOfMonth) {
        day = lastDayOfMonth;
    }
    _time = year * 10000 + month * 100 + day;
}

- (void)addYear:(NSInteger)count
{
    if (count == 0) {
        return;
    }
	NSUInteger year, month, day;
    [self getYear:&year andMonth:&month andDay:&day];
    year += count;
    NSUInteger lastDayOfMonth = [DayTime lastDayOfMonth:month andYear:year];
    if (day > lastDayOfMonth) {
        day = lastDayOfMonth;
    }
    _time = year * 10000 + month * 100 + day;
}

- (NSUInteger)getElapsedDays:(DayTime*)other
{
    if ([self isEqual:other]) {
        return 0;
    }
    DayTime *min = [self compare:other] > 0 ? other : self;
    DayTime *max = [self compare:other] > 0 ? self : other;
    NSUInteger minYear, minMonth, minDay, maxYear, maxMonth, maxDay;
    [min getYear:&minYear andMonth:&minMonth andDay:&minDay];
    [max getYear:&maxYear andMonth:&maxMonth andDay:&maxDay];
    NSInteger elapsed = 0;
    {
        if (minDay < maxDay) {
            elapsed += maxDay - minDay;
        }
        else if (minDay > maxDay) {
            elapsed += [DayTime lastDayOfMonth:minMonth andYear:minYear] - minDay + maxDay;
            if (minMonth == 11) {
                minMonth = 0;
                minYear++;
            } else {
                minMonth++;
            }
        }
    }
    {
        if (minMonth != maxMonth) {
            while (minMonth != maxMonth) {
                elapsed += [DayTime lastDayOfMonth:minMonth andYear:minYear];
                minMonth++;
                if (minMonth == 12) {
                    minMonth = 0;
                    ++minYear;
                }
            }
        }
    }
    {
        if (minYear < maxYear) {
            NSInteger m = maxMonth;
            while (minYear <= maxYear) {
                NSInteger size = minYear == maxYear ? maxMonth : 12;
                for (NSInteger n = m; n < size; n++) {
                    elapsed += [DayTime lastDayOfMonth:n andYear:minYear];
                }
                m = 0;
                minYear++;
            }
        }
    }
    return elapsed;
}

- (NSUInteger)getElapsedInDay:(NSUInteger*)fields
{
    NSInteger minDay = fields[2];
    NSInteger maxDay = fields[5];
    if (minDay == maxDay) {
        return 0;
    }
    else if (minDay > maxDay) {
        NSInteger minMonth = fields[1]++;
        NSInteger minYear = fields[0];
        if (minMonth == 11) {
            fields[1] = 0;
            fields[0]++;
        }
        return [DayTime lastDayOfMonth:minMonth andYear:minYear] - minDay + maxDay;
    }
    else {
        return maxDay - minDay;
    }
}

- (NSUInteger)getElapsedInMonth:(NSUInteger*)fields
{
    NSInteger minMonth = fields[1];
    NSInteger maxMonth = fields[4];
    if (minMonth == maxMonth) {
        return 0;
    }
    NSInteger minYear = fields[0];
    NSInteger elapsed = 0;
    while (minMonth != maxMonth) {
        elapsed += [DayTime lastDayOfMonth:minMonth andYear:minYear];
        minMonth++;
        if (minMonth == 12) {
            fields[1] = minMonth = 0;
            fields[0] = ++minYear;
        }
    }
    return elapsed;
}

- (NSUInteger)getElapsedInYear:(NSUInteger*)fields
{
    NSInteger minYear = fields[0];
    NSInteger maxYear = fields[3];
    if (minYear >= maxYear) {
        return 0;
    }
    NSInteger maxMonth = fields[4];
    NSInteger m = maxMonth;
    NSInteger elapsed = 0;
    while (minYear <= maxYear) {
        NSInteger size = minYear == maxYear ? maxMonth : 12;
        for (NSInteger n = m; n < size; n++) {
            elapsed += [DayTime lastDayOfMonth:n andYear:minYear];
        }
        m = 0;
        minYear++;
    }
    return elapsed;
}

- (bool)isToday
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSInteger day = (int)[components day];
    NSInteger month = (int)[components month] - 1;
    NSInteger year = (int)[components year];
    NSInteger time = year * 10000 + month * 100 + day;
    return _time == time;
}

- (MonthTime*)monthTime
{
	NSUInteger year, month;
    [self getYear:&year andMonth:&month andDay:0];
	return [[MonthTime alloc] initWithYear:year andMonth:month];
}

- (NSDate*)toDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[self day]];
    [components setMonth:[self month] + 1];
    [components setYear:[self year]];
    return [calendar dateFromComponents:components];
}

- (NSInteger)compare:(DayTime*)other
{
    return _time - other->_time;
}

- (DayTime*)clone
{
    return [[DayTime alloc] initWithTime:_time];
}

+ (NSUInteger)lastDayOfMonth:(NSUInteger)month andYear:(NSUInteger)year
{
    switch (month) {
        case 0:
        case 2:
        case 4:
        case 6:
        case 7:
        case 9:
        case 11:
            return 31;
        case 3:
        case 5:
        case 8:
        case 10:
            return 30;
        case 1: {
            return 28 + (((((year % 4) == 0) && (year % 100) != 0) || ((year % 400) == 0)) ? 1 : 0);
        }
        default:
            return -1;
    }
}

- (BOOL)isEqual:(id)other
{
    if (other == self) return YES;
    if (!other || ![other isKindOfClass:[self class]]) return NO;
    DayTime *dayTime = (DayTime*)other;
    return _time == dayTime->_time;
}

- (NSUInteger)hash
{
    return _time;
}

- (NSString *)description
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"%04lu/%02lu/%02lu", (unsigned long)[self year], (unsigned long)[self month] + 1, (unsigned long)[self day]];
    return string;
}

@end

@implementation ClockTime

- (id)initNow
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:currentDate];
    int64_t day = (int)[components day];
    int64_t month = (int)[components month] - 1;
    int64_t year = (int)[components year];
    NSInteger hour = (int)[components hour];
    NSInteger min = (int)[components minute];
    NSInteger sec = (int)[components second];
    _time = (year * 10000 + month * 100 + day) * 1000000;
    _time += hour * 10000 + min * 100 + sec;
    return self;
}

- (id)initWithTime:(int64_t)time
{
    self = [super init];
    _time = time;
    return self;
}

- (id)initWithYear:(NSUInteger)year andMonth:(NSUInteger)month andDay:(NSUInteger)day andHour:(NSUInteger)hour andMinute:(NSUInteger)minute andSecond:(NSUInteger)second
{
    self = [super init];
    _time = ((int64_t)year * 10000 + month * 100 + day) * 1000000;
    _time += hour * 10000 + minute * 100 + second;
    return self;
}

- (int64_t)getTime
{
    return _time;
}

- (NSUInteger)year
{
    int64_t t = _time / 1000000l;
    return (NSUInteger) (t / 10000);
}

- (NSUInteger)month
{
    int64_t t = _time / 1000000l;
    return (NSUInteger) (t / 100 - (t / 10000) * 100);
}

- (NSUInteger)day
{
    int64_t t = _time / 1000000l;
    return (NSUInteger) (t - (t / 10000) * 10000 - ((t / 100) * 100 - (t / 10000) * 10000));
}

- (NSUInteger)getSecond
{
    int64_t t = _time / 1000000l;
    t = _time - t * 1000000l;
    return (NSUInteger) (t - (t / 10000) * 10000 - ((t / 100) * 100 - (t / 10000) * 10000));
}

- (NSUInteger)getMinute
{
    int64_t t = _time / 1000000l;
    t = _time - t * 1000000l;
    return (NSUInteger) (t / 100 - (t / 10000) * 100);
}

- (NSUInteger)getHour
{
    int64_t t = _time / 1000000;;
    t = _time - t * 1000000;;
    return (NSUInteger) (t / 10000);
}

- (NSDate*)toDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[self day]];
    [components setMonth:[self month] + 1];
    [components setYear:[self year]];
    [components setHour:[self getHour]];
    [components setMinute:[self getMinute]];
    [components setSecond:[self getSecond]];
    return [calendar dateFromComponents:components];
}

- (int)compare:(ClockTime*)other
{
    return (int)(_time - other->_time);
}

- (ClockTime*)clone
{
    return [[ClockTime alloc] initWithTime:_time];
}

- (BOOL)isEqual:(id)other
{
    if (other == self) return YES;
    if (!other || ![other isKindOfClass:[self class]]) return NO;
    ClockTime *clockTime = (ClockTime*)other;
    return _time == clockTime->_time;
}

- (NSUInteger)hash
{
    return (NSUInteger)_time;
}

@end

@implementation PeriodDayTime

@synthesize startDayTime = _startDayTime;
@synthesize endDayTime = _endDayTime;

- (id)initWithStartDayTime:(DayTime*)startDayTime andEndDayTime:(DayTime*)endDayTime
{
    if (!(self = [super init])) return nil;
    _startDayTime = startDayTime;
    _endDayTime = endDayTime;
    return self;
}

- (PeriodDayTime*)unionWithPeriodDayTime:(PeriodDayTime*)other
{
    DayTime *startDayTime = self.startDayTime;
    if ([startDayTime compare:other.startDayTime] > 0) {
        startDayTime = other.startDayTime;
    }
    DayTime *endDayTime = self.endDayTime;
    if ([endDayTime compare:other.endDayTime] < 0) {
        endDayTime = other.endDayTime;
    }
    return [[PeriodDayTime alloc] initWithStartDayTime:[startDayTime clone] andEndDayTime:[endDayTime clone]];
}

- (PeriodDayTime*)intersectionWithPeriodDayTime:(PeriodDayTime*)other
{
    return nil;
}

- (BOOL)containDayTime:(DayTime*)dayTime
{
    return dayTime->_time >= self.startDayTime->_time && dayTime->_time <= self.endDayTime->_time;
}

- (NSUInteger)numberOfDays
{
    return [_endDayTime getElapsedDays:_startDayTime] + 1;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) return YES;
    if (!other || ![other isKindOfClass:[self class]]) return NO;
    PeriodDayTime *periodDayTime = (PeriodDayTime*)other;
    return [self.startDayTime isEqual:periodDayTime.startDayTime] && [self.endDayTime isEqual:periodDayTime.endDayTime];
}

- (NSUInteger)hash
{
    return ([self.startDayTime hash] << 16) + [self.endDayTime hash];
}

- (NSString *)description
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"%@ - %@", [_startDayTime description], [_endDayTime description]];
    return string;
}

@end