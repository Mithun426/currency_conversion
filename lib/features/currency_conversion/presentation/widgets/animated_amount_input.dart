import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:currency_picker/currency_picker.dart';

class AnimatedAmountInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? currency;

  const AnimatedAmountInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.currency,
  });

  @override
  State<AnimatedAmountInput> createState() => _AnimatedAmountInputState();
}

class _AnimatedAmountInputState extends State<AnimatedAmountInput>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _focusController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;

  bool _isValid = true;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _focusController,
        curve: Curves.easeInOut,
      ),
    );

    _borderColorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.blue[600],
    ).animate(_focusController);

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      
      if (_isFocused) {
        _focusController.forward();
      } else {
        _focusController.reverse();
      }
    });

    widget.controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _focusController.dispose();
    _focusNode.dispose();
    widget.controller.removeListener(_validateInput);
    super.dispose();
  }

  void _validateInput() {
    final text = widget.controller.text;
    final isValid = text.isEmpty || double.tryParse(text.replaceAll(',', '')) != null;
    
    if (!isValid && _isValid) {
      _bounceController.forward().then((_) {
        _bounceController.reverse();
      });
    }
    
    setState(() {
      _isValid = isValid;
    });
  }

  void _formatInput() {
    final text = widget.controller.text.replaceAll(',', '');
    final value = double.tryParse(text);
    
    if (value != null && text.isNotEmpty) {
      final formatter = NumberFormat('#,##0.##');
      final formatted = formatter.format(value);
      
      widget.controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    
    if (widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
  }

  String get _getCurrencySymbol {
    if (widget.currency == null) return '\$'; // Default to dollar
    
    try {
      final currency = CurrencyService().findByCode(widget.currency!);
      return currency?.symbol ?? widget.currency!;
    } catch (e) {
      // Fallback to currency code if not found
      return widget.currency!;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            !_isValid ? 'Amount (Invalid)' : 'Amount',
            key: ValueKey(_isValid),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: !_isValid ? Colors.red[600] : Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: Listenable.merge([_bounceAnimation, _scaleAnimation, _borderColorAnimation]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_bounceAnimation.value, 0),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isFocused
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    onChanged: (value) => _formatInput(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _isValid ? Colors.black87 : Colors.red[600],
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: widget.currency != null
                          ? Container(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                _getCurrencySymbol,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _isValid 
                                      ? (_isFocused ? Colors.blue[600] : Colors.grey[600])
                                      : Colors.red[600],
                                ),
                              ),
                            )
                          : const Icon(Icons.attach_money, size: 28),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: _isValid ? Colors.grey[300]! : Colors.red[300]!,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: _isValid 
                              ? _borderColorAnimation.value ?? Colors.blue[600]!
                              : Colors.red[600]!,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.red[600]!, width: 2),
                      ),
                      filled: true,
                      fillColor: _isValid 
                          ? (_isFocused ? Colors.blue[50] : Colors.grey[50])
                          : Colors.red[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (!_isValid)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              'Please enter a valid amount',
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
              .animate()
              .slideY(begin: -0.5, duration: 200.ms)
              .fadeIn(duration: 200.ms),
      ],
    );
  }
} 