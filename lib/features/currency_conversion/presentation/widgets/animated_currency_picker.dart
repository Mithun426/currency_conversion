import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:country_flags/country_flags.dart';
import 'package:currency_picker/currency_picker.dart';
import '../../data/models/currency_model.dart';

class AnimatedCurrencyPicker extends StatefulWidget {
  final String selectedCurrency;
  final List<CurrencyModel> currencies;
  final Function(Currency) onCurrencySelected;
  final String label;

  const AnimatedCurrencyPicker({
    super.key,
    required this.selectedCurrency,
    required this.currencies,
    required this.onCurrencySelected,
    required this.label,
  });

  @override
  State<AnimatedCurrencyPicker> createState() => _AnimatedCurrencyPickerState();
}

class _AnimatedCurrencyPickerState extends State<AnimatedCurrencyPicker>
    with TickerProviderStateMixin {
  late AnimationController _chipController;
  late Animation<double> _chipScale;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _chipController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _chipScale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _chipController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _chipController.dispose();
    super.dispose();
  }

  Currency get selectedCurrencyFromPicker {
    try {
      return CurrencyService().findByCode(widget.selectedCurrency) ?? 
             CurrencyService().findByCode('USD')!;
    } catch (e) {
      // Fallback to USD if not found
      return CurrencyService().findByCode('USD')!;
    }
  }

  String _getCountryCodeFromCurrency(String currencyCode) {
    // Map common currency codes to country codes for flags
    const currencyToCountry = {
      'USD': 'US', 'EUR': 'EU', 'GBP': 'GB', 'JPY': 'JP', 'CAD': 'CA',
      'AUD': 'AU', 'CHF': 'CH', 'CNY': 'CN', 'INR': 'IN', 'KRW': 'KR',
      'SGD': 'SG', 'HKD': 'HK', 'THB': 'TH', 'MYR': 'MY', 'BRL': 'BR',
      'MXN': 'MX', 'ARS': 'AR', 'ZAR': 'ZA', 'RUB': 'RU', 'TRY': 'TR',
      'PLN': 'PL', 'SEK': 'SE', 'NOK': 'NO', 'DKK': 'DK', 'CZK': 'CZ',
      'HUF': 'HU', 'ILS': 'IL', 'NZD': 'NZ', 'SAR': 'SA', 'AED': 'AE',
      'EGP': 'EG', 'QAR': 'QA', 'KWD': 'KW', 'BHD': 'BH', 'OMR': 'OM',
      'JOD': 'JO', 'LBP': 'LB', 'PKR': 'PK', 'BDT': 'BD', 'LKR': 'LK',
      'VND': 'VN', 'IDR': 'ID', 'PHP': 'PH', 'TWD': 'TW',
    };
    return currencyToCountry[currencyCode] ?? 'XX';
  }

  void _showCurrencyPicker() {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showSearchField: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      currencyFilter: widget.currencies.map((c) => c.code).toList(),
      favorite: ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY'],
      theme: CurrencyPickerThemeData(
        backgroundColor: Colors.white,
        flagSize: 25,
        titleTextStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 15, 
          color: Colors.grey[600],
          fontWeight: FontWeight.w400,
        ),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.7,
                 inputDecoration: InputDecoration(
           hintText: 'Search currency...',
           hintStyle: TextStyle(color: Colors.grey[500]),
           prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide(color: Colors.grey[300]!),
           ),
           enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide(color: Colors.grey[300]!),
           ),
           focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
           ),
           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
         ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      onSelect: (Currency currency) {
        widget.onCurrencySelected(currency);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = selectedCurrencyFromPicker;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-0.2, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
          child: Text(
            widget.label,
            key: ValueKey(widget.label),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _chipScale,
          builder: (context, child) {
            return Transform.scale(
              scale: _chipScale.value,
              child: Hero(
                tag: '${widget.label}_${widget.selectedCurrency}',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showCurrencyPicker,
                    onTapDown: (_) => setState(() => _isPressed = true),
                    onTapUp: (_) => setState(() => _isPressed = false),
                    onTapCancel: () => setState(() => _isPressed = false),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      padding: EdgeInsets.symmetric(
                        horizontal: _isPressed ? 18 : 16,
                        vertical: _isPressed ? 10 : 12,
                      ),
                      decoration: BoxDecoration(
                        color: _isPressed ? Colors.blue[100] : Colors.blue[50],
                        borderRadius: BorderRadius.circular(_isPressed ? 16 : 12),
                        border: Border.all(
                          color: _isPressed ? Colors.blue[400]! : Colors.blue[200]!,
                          width: _isPressed ? 2 : 1,
                        ),
                        boxShadow: _isPressed ? [
                          BoxShadow(
                            color: Colors.blue[200]!.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ] : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 32,
                            height: 24,
                            child: currency.flag != null
                                ? CountryFlag.fromCountryCode(
                                    _getCountryCodeFromCurrency(currency.code),
                                    shape: const RoundedRectangle(6),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.flag,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currency.code,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (currency.name.length <= 20)
                                  Text(
                                    currency.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, duration: const Duration(milliseconds: 600));
  }
} 