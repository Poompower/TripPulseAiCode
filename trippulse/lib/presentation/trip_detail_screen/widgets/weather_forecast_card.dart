import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Weather forecast card widget displaying 5-day weather forecast
/// Shows temperature, conditions, and precipitation for each day
class WeatherForecastCard extends StatelessWidget {
  final List<Map<String, dynamic>> weatherData;
  final bool isLoading;
  final DateTime lastUpdated;

  const WeatherForecastCard({
    super.key,
    required this.weatherData,
    required this.isLoading,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'wb_sunny',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Weather Forecast',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (!isLoading)
                  Text(
                    'Updated ${lastUpdated.hour}:${lastUpdated.minute.toString().padLeft(2, '0')}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),

          // Weather forecast list
          if (isLoading)
            _buildLoadingSkeleton(theme)
          else
            SizedBox(
              height: 18.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                itemCount: weatherData.length,
                separatorBuilder: (context, index) => SizedBox(width: 3.w),
                itemBuilder: (context, index) {
                  final weather = weatherData[index];
                  return _buildWeatherDayCard(context, weather, theme);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeatherDayCard(
    BuildContext context,
    Map<String, dynamic> weather,
    ThemeData theme,
  ) {
    return Container(
      width: 20.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Day of week
          Text(
            weather['dayOfWeek'] as String,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          // Weather icon
          CustomIconWidget(
            iconName: weather['icon'] as String,
            color: theme.colorScheme.primary,
            size: 32,
          ),

          // Temperature
          Column(
            children: [
              Text(
                '${weather['tempHigh']}°',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${weather['tempLow']}°',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          // Precipitation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'water_drop',
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
                size: 12,
              ),
              SizedBox(width: 1.w),
              Text(
                '${weather['precipitation']}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton(ThemeData theme) {
    return SizedBox(
      height: 18.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(width: 3.w),
        itemBuilder: (context, index) {
          return Container(
            width: 20.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}
