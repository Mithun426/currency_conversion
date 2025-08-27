import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:country_flags/country_flags.dart';
import '../../domain/entities/conversion_result.dart';
import '../../data/models/currency_model.dart';
import '../pages/trend_screen.dart';
class ConversionResultWidget extends StatefulWidget {
  final ConversionResult? result;
  final List<CurrencyModel> currencies;
  const ConversionResultWidget({
    super.key,
    this.result,
    required this.currencies,
  });
  @override
  State<ConversionResultWidget> createState() => _ConversionResultWidgetState();
}
class _ConversionResultWidgetState extends State<ConversionResultWidget>
    with TickerProviderStateMixin {
  late AnimationController _countUpController;
  late Animation<double> _countUpAnimation;
  double _displayAmount = 0;
  bool _isVisible = false;
  @override
  void initState() {
    super.initState();
    _countUpController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _countUpAnimation = CurvedAnimation(
      parent: _countUpController,
      curve: Curves.easeOutCubic,
    );
    _countUpAnimation.addListener(() {
      if (widget.result != null) {
        setState(() {
          _displayAmount = widget.result!.convertedAmount * _countUpAnimation.value;
        });
      }
    });
    if (widget.result != null) {
      _isVisible = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _countUpController.forward();
      });
    }
  }
  @override
  void dispose() {
    _countUpController.dispose();
    super.dispose();
  }
  @override
  void didUpdateWidget(ConversionResultWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.result != oldWidget.result) {
      if (widget.result != null) {
        setState(() {
          _isVisible = true;
        });
        _countUpController.reset();
        _countUpController.forward();
      } else {
        setState(() {
          _isVisible = false;
        });
      }
    }
  }
  CurrencyModel _getCurrency(String code) {
    return widget.currencies.firstWhere(
      (currency) => currency.code == code,
      orElse: () => CurrencyModel(code: code, name: code, symbol: code),
    );
  }
  @override
  Widget build(BuildContext context) {
    if (!_isVisible || widget.result == null) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final formatter = NumberFormat('#,##0.##');
    final fromCurrency = _getCurrency(widget.result!.fromCurrency);
    final toCurrency = _getCurrency(widget.result!.toCurrency);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Card(
        elevation: isDarkMode ? 12 : 8,
        shadowColor: isDarkMode 
            ? const Color(0xFF64B5F6).withOpacity(0.3)
            : Colors.blue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                      const Color(0xFF1E2329),
                      const Color(0xFF2A2D37),
                      const Color(0xFF1A1D23),
                    ]
                  : [
                      Colors.blue[50]!,
                      Colors.white,
                      Colors.green[50]!,
                    ],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: isDarkMode ? const Color(0xFF4CAF50) : Colors.green[600],
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Conversion Result',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? const Color(0xFFE3F2FD) : Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDarkMode 
                          ? const Color(0xFF4CAF50).withOpacity(0.2)
                          : Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Live Rate',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? const Color(0xFF4CAF50) : Colors.green[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? const Color(0xFF3A3D47).withOpacity(0.5)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      height: 36,
                      child: fromCurrency.countryCode != 'XX' 
                          ? CountryFlag.fromCountryCode(
                              fromCurrency.countryCode,
                              height: 36,
                              width: 48,
                            )
                          : Text(
                              fromCurrency.flagEmoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.result!.fromCurrency,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? const Color(0xFFE3F2FD) : Colors.black,
                            ),
                          ),
                          Text(
                            fromCurrency.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? const Color(0xFFB0BEC5) : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatter.format(widget.result!.amount),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? const Color(0xFFE3F2FD) : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDarkMode 
                        ? const Color(0xFF4CAF50).withOpacity(0.3)
                        : Colors.green[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      height: 36,
                      child: toCurrency.countryCode != 'XX' 
                          ? CountryFlag.fromCountryCode(
                              toCurrency.countryCode,
                              height: 36,
                              width: 48,
                            )
                          : Text(
                              toCurrency.flagEmoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.result!.toCurrency,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? const Color(0xFF4CAF50) : Colors.green[700],
                            ),
                          ),
                          Text(
                            toCurrency.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? const Color(0xFF81C784) : Colors.green[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _countUpAnimation,
                      builder: (context, child) {
                        return Text(
                          formatter.format(_displayAmount),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? const Color(0xFF4CAF50) : Colors.green[700],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? const Color(0xFF64B5F6).withOpacity(0.1)
                      : Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: isDarkMode ? const Color(0xFF64B5F6) : Colors.blue[600],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '1 ${widget.result!.fromCurrency} = ${formatter.format(widget.result!.exchangeRate)} ${widget.result!.toCurrency}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? const Color(0xFF64B5F6) : Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => TrendScreen(
                      fromCurrency: widget.result!.fromCurrency,
                      toCurrency: widget.result!.toCurrency,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDarkMode ? const Color(0xFFAB47BC) : Colors.purple[600],
                  side: BorderSide(
                    color: isDarkMode 
                        ? const Color(0xFFAB47BC).withOpacity(0.5)
                        : Colors.purple[300]!,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                icon: Icon(
                  Icons.show_chart,
                  size: 18,
                  color: Colors.purple[600],
                ),
                label: Text(
                  '5-Day Trend',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple[600],
                  ),
                ),
              ).animate()
                  .fadeIn(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 400))
                  .slideY(begin: 0.2, duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 400)),
            ],
          ),
        ),
      ),
    )
        .animate()
        .slideY(begin: 0.3, duration: 800.ms, curve: Curves.elasticOut)
        .fadeIn(duration: 600.ms);
  }
} 