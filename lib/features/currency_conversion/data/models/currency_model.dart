import 'package:country_flags/country_flags.dart';
import '../../domain/entities/currency.dart';
class CurrencyModel extends Currency {
  const CurrencyModel({
    required super.code,
    required super.name,
    required super.symbol,
  });
  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
    };
  }
  String get countryCode {
    switch (code) {
      case 'USD': return 'US';
      case 'EUR': return 'EU';
      case 'GBP': return 'GB';
      case 'JPY': return 'JP';
      case 'CAD': return 'CA';
      case 'AUD': return 'AU';
      case 'CHF': return 'CH';
      case 'CNY': return 'CN';
      case 'INR': return 'IN';
      case 'KRW': return 'KR';
      case 'SGD': return 'SG';
      case 'HKD': return 'HK';
      case 'THB': return 'TH';
      case 'MYR': return 'MY';
      case 'IDR': return 'ID';
      case 'PHP': return 'PH';
      case 'VND': return 'VN';
      case 'PKR': return 'PK';
      case 'BDT': return 'BD';
      case 'LKR': return 'LK';
      case 'NPR': return 'NP';
      case 'MMK': return 'MM';
      case 'LAK': return 'LA';
      case 'KHR': return 'KH';
      case 'NOK': return 'NO';
      case 'SEK': return 'SE';
      case 'DKK': return 'DK';
      case 'PLN': return 'PL';
      case 'CZK': return 'CZ';
      case 'HUF': return 'HU';
      case 'RON': return 'RO';
      case 'BGN': return 'BG';
      case 'HRK': return 'HR';
      case 'RSD': return 'RS';
      case 'RUB': return 'RU';
      case 'UAH': return 'UA';
      case 'TRY': return 'TR';
      case 'ISK': return 'IS';
      case 'AED': return 'AE';
      case 'SAR': return 'SA';
      case 'QAR': return 'QA';
      case 'KWD': return 'KW';
      case 'BHD': return 'BH';
      case 'OMR': return 'OM';
      case 'JOD': return 'JO';
      case 'LBP': return 'LB';
      case 'ILS': return 'IL';
      case 'IRR': return 'IR';
      case 'IQD': return 'IQ';
      case 'ZAR': return 'ZA';
      case 'EGP': return 'EG';
      case 'NGN': return 'NG';
      case 'KES': return 'KE';
      case 'GHS': return 'GH';
      case 'ETB': return 'ET';
      case 'UGX': return 'UG';
      case 'TZS': return 'TZ';
      case 'ZMW': return 'ZM';
      case 'BWP': return 'BW';
      case 'MAD': return 'MA';
      case 'TND': return 'TN';
      case 'DZD': return 'DZ';
      case 'BRL': return 'BR';
      case 'MXN': return 'MX';
      case 'ARS': return 'AR';
      case 'CLP': return 'CL';
      case 'COP': return 'CO';
      case 'PEN': return 'PE';
      case 'VES': return 'VE';
      case 'UYU': return 'UY';
      case 'PYG': return 'PY';
      case 'BOB': return 'BO';
      case 'GTQ': return 'GT';
      case 'HNL': return 'HN';
      case 'NIO': return 'NI';
      case 'CRC': return 'CR';
      case 'PAB': return 'PA';
      case 'JMD': return 'JM';
      case 'TTD': return 'TT';
      case 'NZD': return 'NZ';
      case 'FJD': return 'FJ';
      case 'TOP': return 'TO';
      case 'WST': return 'WS';
      case 'SBD': return 'SB';
      case 'VUV': return 'VU';
      case 'PGK': return 'PG';
      case 'XAU':
      case 'XAG':
      case 'BTC':
      case 'ETH':
        return 'XX'; 
      default: return 'XX';
    }
  }
  String get flagEmoji {
    switch (code) {
      case 'USD': return '🇺🇸';
      case 'EUR': return '🇪🇺';
      case 'GBP': return '🇬🇧';
      case 'JPY': return '🇯🇵';
      case 'CAD': return '🇨🇦';
      case 'AUD': return '🇦🇺';
      case 'CHF': return '🇨🇭';
      case 'CNY': return '🇨🇳';
      case 'INR': return '🇮🇳';
      case 'KRW': return '🇰🇷';
      case 'SGD': return '🇸🇬';
      case 'HKD': return '🇭🇰';
      case 'THB': return '🇹🇭';
      case 'MYR': return '🇲🇾';
      case 'IDR': return '🇮🇩';
      case 'PHP': return '🇵🇭';
      case 'VND': return '🇻🇳';
      case 'PKR': return '🇵🇰';
      case 'BDT': return '🇧🇩';
      case 'LKR': return '🇱🇰';
      case 'NPR': return '🇳🇵';
      case 'MMK': return '🇲🇲';
      case 'LAK': return '🇱🇦';
      case 'KHR': return '🇰🇭';
      case 'NOK': return '🇳🇴';
      case 'SEK': return '🇸🇪';
      case 'DKK': return '🇩🇰';
      case 'PLN': return '🇵🇱';
      case 'CZK': return '🇨🇿';
      case 'HUF': return '🇭🇺';
      case 'RON': return '🇷🇴';
      case 'BGN': return '🇧🇬';
      case 'HRK': return '🇭🇷';
      case 'RSD': return '🇷🇸';
      case 'RUB': return '🇷🇺';
      case 'UAH': return '🇺🇦';
      case 'TRY': return '🇹🇷';
      case 'ISK': return '🇮🇸';
      case 'AED': return '🇦🇪';
      case 'SAR': return '🇸🇦';
      case 'QAR': return '🇶🇦';
      case 'KWD': return '🇰🇼';
      case 'BHD': return '🇧🇭';
      case 'OMR': return '🇴🇲';
      case 'JOD': return '🇯🇴';
      case 'LBP': return '🇱🇧';
      case 'ILS': return '🇮🇱';
      case 'IRR': return '🇮🇷';
      case 'IQD': return '🇮🇶';
      case 'ZAR': return '🇿🇦';
      case 'EGP': return '🇪🇬';
      case 'NGN': return '🇳🇬';
      case 'KES': return '🇰🇪';
      case 'GHS': return '🇬🇭';
      case 'ETB': return '🇪🇹';
      case 'UGX': return '🇺🇬';
      case 'TZS': return '🇹🇿';
      case 'ZMW': return '🇿🇲';
      case 'BWP': return '🇧🇼';
      case 'MAD': return '🇲🇦';
      case 'TND': return '🇹🇳';
      case 'DZD': return '🇩🇿';
      case 'BRL': return '🇧🇷';
      case 'MXN': return '🇲🇽';
      case 'ARS': return '🇦🇷';
      case 'CLP': return '🇨🇱';
      case 'COP': return '🇨🇴';
      case 'PEN': return '🇵🇪';
      case 'VES': return '🇻🇪';
      case 'UYU': return '🇺🇾';
      case 'PYG': return '🇵🇾';
      case 'BOB': return '🇧🇴';
      case 'GTQ': return '🇬🇹';
      case 'HNL': return '🇭🇳';
      case 'NIO': return '🇳🇮';
      case 'CRC': return '🇨🇷';
      case 'PAB': return '🇵🇦';
      case 'JMD': return '🇯🇲';
      case 'TTD': return '🇹🇹';
      case 'NZD': return '🇳🇿';
      case 'FJD': return '🇫🇯';
      case 'TOP': return '🇹🇴';
      case 'WST': return '🇼🇸';
      case 'SBD': return '🇸🇧';
      case 'VUV': return '🇻🇺';
      case 'PGK': return '🇵🇬';
      case 'XAU': return '🥇'; 
      case 'XAG': return '🥈'; 
      case 'BTC': return '₿'; 
      case 'ETH': return 'Ξ'; 
      default: return '🏳️';
    }
  }
} 