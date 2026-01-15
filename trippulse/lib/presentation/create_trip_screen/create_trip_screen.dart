import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_app_bar.dart';
import 'widgets/currency_selector_widget.dart';
import 'widgets/date_picker_field_widget.dart';
import 'widgets/destination_field_widget.dart';

/// Create Trip Screen - Enables users to input essential trip details
/// through mobile-optimized form interface with validation and auto-generation
class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _destinationController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedCurrency = 'USD';
  bool _isLoading = false;
  bool _isDirty = false;

  // Character limit for trip title
  static const int _maxTitleLength = 50;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onFormChanged);
    _destinationController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (!_isDirty) {
      setState(() => _isDirty = true);
    }
  }

  bool _isFormValid() {
    return _titleController.text.trim().isNotEmpty &&
        _destinationController.text.trim().isNotEmpty &&
        _startDate != null &&
        _endDate != null &&
        _startDate!.isBefore(_endDate!);
  }

  Future<bool> _onWillPop() async {
    if (!_isDirty) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Discard Changes?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to leave?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  Future<void> _saveTrip() async {
    if (!_isFormValid()) return;

    // Trigger haptic feedback
    HapticFeedback.mediumImpact();

    setState(() => _isLoading = true);

    try {
      // Simulate Hive storage operation
      await Future.delayed(const Duration(milliseconds: 800));

      // Calculate number of days for itinerary auto-generation
      final days = _endDate!.difference(_startDate!).inDays + 1;

      // Success haptic feedback
      HapticFeedback.lightImpact();

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Trip created with $days days itinerary'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate to trip detail screen
      Navigator.pushReplacementNamed(
        context,
        '/trip-detail-screen',
        arguments: {
          'tripId': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': _titleController.text.trim(),
          'destination': _destinationController.text.trim(),
          'startDate': _startDate,
          'endDate': _endDate,
          'currency': _selectedCurrency,
          'days': days,
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to create trip. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar.createTrip(context: context),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Trip Title Field
                        _buildTripTitleField(theme),
                        SizedBox(height: 3.h),

                        // Destination Field
                        DestinationFieldWidget(
                          controller: _destinationController,
                          onDestinationSelected: (destination) {
                            setState(() {
                              _destinationController.text = destination;
                            });
                          },
                        ),
                        SizedBox(height: 3.h),

                        // Date Pickers
                        _buildDateSection(theme),
                        SizedBox(height: 3.h),

                        // Currency Selector
                        CurrencySelectorWidget(
                          selectedCurrency: _selectedCurrency,
                          onCurrencySelected: (currency) {
                            setState(() {
                              _selectedCurrency = currency;
                              _onFormChanged();
                            });
                          },
                        ),
                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),

                // Save Button (Fixed at bottom)
                _buildSaveButton(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripTitleField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Title',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _titleController,
          maxLength: _maxTitleLength,
          decoration: InputDecoration(
            hintText: 'e.g., Summer Vacation 2025',
            counterText: '${_titleController.text.length}/$_maxTitleLength',
            errorStyle: theme.inputDecorationTheme.errorStyle,
          ),
          style: theme.textTheme.bodyLarge,
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a trip title';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildDateSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Travel Dates',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: DatePickerFieldWidget(
                label: 'Start Date',
                selectedDate: _startDate,
                onDateSelected: (date) {
                  setState(() {
                    _startDate = date;
                    _onFormChanged();
                    // Reset end date if it's before new start date
                    if (_endDate != null && _endDate!.isBefore(date)) {
                      _endDate = null;
                    }
                  });
                },
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 730)),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: DatePickerFieldWidget(
                label: 'End Date',
                selectedDate: _endDate,
                onDateSelected: (date) {
                  setState(() {
                    _endDate = date;
                    _onFormChanged();
                  });
                },
                firstDate: _startDate ?? DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 730)),
                enabled: _startDate != null,
              ),
            ),
          ],
        ),
        if (_startDate != null && _endDate != null)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              '${_endDate!.difference(_startDate!).inDays + 1} days',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    final isValid = _isFormValid();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 6.h,
        child: ElevatedButton(
          onPressed: isValid && !_isLoading ? _saveTrip : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isValid
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            foregroundColor: isValid
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
            disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.onPrimary,
                    ),
                  ),
                )
              : Text(
                  'Save Trip',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
