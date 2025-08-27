import 'package:equatable/equatable.dart';
class Currency extends Equatable {
  final String code;
  final String name;
  final String symbol;
  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });
  @override
  List<Object> get props => [code, name, symbol];
} 