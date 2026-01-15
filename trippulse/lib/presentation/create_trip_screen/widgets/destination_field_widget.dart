import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../../widgets/custom_icon_widget.dart';

/// Destination field with search suggestions from OpenTripMap API
/// Provides autocomplete functionality for location search
class DestinationFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onDestinationSelected;

  const DestinationFieldWidget({
    super.key,
    required this.controller,
    required this.onDestinationSelected,
  });

  @override
  State<DestinationFieldWidget> createState() => _DestinationFieldWidgetState();
}

class _DestinationFieldWidgetState extends State<DestinationFieldWidget> {
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> _suggestions = [];
  bool _isSearching = false;
  OverlayEntry? _overlayEntry;

  // Mock popular destinations for suggestions
  final List<Map<String, dynamic>> _popularDestinations = [
    {'name': 'Paris, France', 'country': 'France', 'icon': '🇫🇷'},
    {'name': 'Tokyo, Japan', 'country': 'Japan', 'icon': '🇯🇵'},
    {'name': 'New York, USA', 'country': 'United States', 'icon': '🇺🇸'},
    {'name': 'London, UK', 'country': 'United Kingdom', 'icon': '🇬🇧'},
    {'name': 'Barcelona, Spain', 'country': 'Spain', 'icon': '🇪🇸'},
    {'name': 'Dubai, UAE', 'country': 'United Arab Emirates', 'icon': '🇦🇪'},
    {'name': 'Rome, Italy', 'country': 'Italy', 'icon': '🇮🇹'},
    {'name': 'Bangkok, Thailand', 'country': 'Thailand', 'icon': '🇹🇭'},
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChanged);
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showSuggestions();
    } else {
      _removeOverlay();
    }
  }

  void _onTextChanged() {
    if (widget.controller.text.isEmpty) {
      setState(() {
        _suggestions = _popularDestinations;
      });
    } else {
      _searchDestinations(widget.controller.text);
    }
    _updateOverlay();
  }

  Future<void> _searchDestinations(String query) async {
    if (query.length < 2) return;

    setState(() => _isSearching = true);

    // Simulate API call to OpenTripMap
    await Future.delayed(const Duration(milliseconds: 300));

    final filtered = _popularDestinations
        .where(
          (dest) => (dest['name'] as String).toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();

    setState(() {
      _suggestions = filtered;
      _isSearching = false;
    });
  }

  void _showSuggestions() {
    _removeOverlay();

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        width: size.width,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: _buildSuggestionsList(),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildSuggestionsList() {
    final theme = Theme.of(context);

    if (_isSearching) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    if (_suggestions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Text(
          'No destinations found',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 30.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        shrinkWrap: true,
        itemCount: _suggestions.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        itemBuilder: (context, index) {
          final destination = _suggestions[index];
          return ListTile(
            leading: Text(
              destination['icon'] as String,
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(
              destination['name'] as String,
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              destination['country'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            onTap: () {
              widget.controller.text = destination['name'] as String;
              widget.onDestinationSelected(destination['name'] as String);
              _focusNode.unfocus();
              _removeOverlay();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Destination',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search for a destination',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'location_on',
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () {
                      widget.controller.clear();
                      _focusNode.requestFocus();
                    },
                  )
                : null,
          ),
          style: theme.textTheme.bodyLarge,
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a destination';
            }
            return null;
          },
        ),
      ],
    );
  }
}
