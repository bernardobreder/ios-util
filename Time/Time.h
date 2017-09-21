//
//  Time.h
//  iPhoneUtil
//
//  Created by Bernardo Breder on 23/02/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

@class Time;
@class MonthTime;
@class DayTime;
@class ClockTime;

@interface Time : NSObject

@end

@interface MonthTime : Time {
    NSInteger _time;
}

- (id)initWithTime:(NSUInteger)time;

- (id)initWithYear:(NSUInteger)year andMonth:(NSUInteger)month;

- (NSUInteger)month;

- (NSUInteger)year;

- (void)setMonth:(NSUInteger)month;

- (void)setYear:(NSUInteger)year;

- (void)addMonth:(NSInteger)count;

- (void)addYear:(NSInteger)count;

- (void)getYear:(NSUInteger*)year andMonth:(NSUInteger*)month;

- (NSUInteger)getElapsedMonths:(MonthTime*)time;

- (NSUInteger)lastDayOfMonth;

- (MonthTime*)monthTimeAdded:(NSUInteger)count;

- (NSUInteger)time;

- (DayTime*)firstDayTime;

- (DayTime*)lastDayTime;

/**
 * Retorna o número de semanas no mês. O mês de Janeiro de 2010 tem 6 semanas.
 */
- (NSUInteger)numberOfWeeks;
/**
 * Cria uma estrutura nova com o mesmo conteúdo
 */
- (MonthTime*)clone;

+ (NSUInteger)timeWithYear:(NSUInteger)year andMonth:(NSUInteger)month;

+ (NSString*)stringShortForMonth:(NSUInteger)month;

@end

@interface DayTime : Time {
	@package
    NSInteger _time;
}

- (id)initNow;

- (id)initWithTime:(NSUInteger)time;

- (id)initWithYear:(NSUInteger)year andMonth:(NSUInteger)month andDay:(NSUInteger)day;

- (NSUInteger)day;

- (NSUInteger)month;

- (NSUInteger)year;

- (void)setDay:(NSUInteger)day;

- (void)setMonth:(NSUInteger)month;

- (void)setYear:(NSUInteger)year;

- (void)incDay;

- (void)addDay:(NSInteger)count;

- (void)addMonth:(NSInteger)count;

- (void)addYear:(NSInteger)count;

- (void)getYear:(NSUInteger*)year andMonth:(NSUInteger*)month andDay:(NSUInteger*)day;

- (NSUInteger)getElapsedDays:(DayTime*)other;

/**
 * Retorna a semana do mês. Para o dia 13 de Janeiro de 2010, será retornado o valor 3 porque o dia está na terceira semana do mês.
 */
- (NSUInteger)weekOfMonth;

/**
 * Retorna o dia da semana começando pelo indice 0 como Domingo.
 */
- (NSUInteger)dayOfWeek;

- (NSUInteger)numberOfWeeks:(DayTime*)dayTime;

- (NSUInteger)numberOfWeeksFromCalendar:(DayTime*)dayTime;

- (NSUInteger)lastDayOfMonth;

- (bool)isToday;

- (DayTime*)clone;

- (NSInteger)compare:(DayTime*)other;

- (NSUInteger)time;

- (MonthTime*)monthTime;

- (NSDate*)toDate;

+ (NSUInteger)lastDayOfMonth:(NSUInteger)month andYear:(NSUInteger)year;

@end

@interface ClockTime : Time {
    int64_t _time;
}

- (id)initNow;

- (id)initWithTime:(int64_t)time;

- (id)initWithYear:(NSUInteger)year andMonth:(NSUInteger)month andDay:(NSUInteger)day andHour:(NSUInteger)hour andMinute:(NSUInteger)minute andSecond:(NSUInteger)second;

- (int64_t)getTime;

- (NSUInteger)year;

- (NSUInteger)month;

- (NSUInteger)day;

- (NSUInteger)getSecond;

- (NSUInteger)getMinute;

- (NSUInteger)getHour;

- (NSDate*)toDate;

- (int)compare:(ClockTime*)other;

- (ClockTime*)clone;

@end

@interface PeriodDayTime : NSObject

@property (nonatomic, strong) DayTime *startDayTime;

@property (nonatomic, strong) DayTime *endDayTime;

- (id)initWithStartDayTime:(DayTime*)startDayTime andEndDayTime:(DayTime*)endDayTime;

- (PeriodDayTime*)unionWithPeriodDayTime:(PeriodDayTime*)other;

- (PeriodDayTime*)intersectionWithPeriodDayTime:(PeriodDayTime*)other;

- (NSUInteger)numberOfDays;

- (BOOL)containDayTime:(DayTime*)dayTime;

@end
