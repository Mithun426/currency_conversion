import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../models/currency_model.dart';
import '../models/exchange_rate_model.dart';
import '../models/conversion_result_model.dart';
import '../models/api_response_model.dart';
abstract class CurrencyRemoteDataSource {
  Future<List<CurrencyModel>> getAllCurrencies();
  Future<ExchangeRateModel> getExchangeRate({
    required String from,
    required String to,
  });
  Future<ConversionResultModel> convertCurrency({
    required double amount,
    required String from,
    required String to,
  });
}
class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final Dio dio;
  CurrencyRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<CurrencyModel>> getAllCurrencies() async {
    final currencies = <CurrencyModel>[
      const CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$'),
      const CurrencyModel(code: 'EUR', name: 'Euro', symbol: '€'),
      const CurrencyModel(code: 'GBP', name: 'British Pound', symbol: '£'),
      const CurrencyModel(code: 'JPY', name: 'Japanese Yen', symbol: '¥'),
      const CurrencyModel(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$'),
      const CurrencyModel(
        code: 'AUD',
        name: 'Australian Dollar',
        symbol: 'A\$',
      ),
      const CurrencyModel(code: 'CHF', name: 'Swiss Franc', symbol: 'CHF'),
      const CurrencyModel(code: 'CNY', name: 'Chinese Yuan', symbol: '¥'),
      const CurrencyModel(code: 'INR', name: 'Indian Rupee', symbol: '₹'),
      const CurrencyModel(code: 'KRW', name: 'South Korean Won', symbol: '₩'),
      const CurrencyModel(code: 'SGD', name: 'Singapore Dollar', symbol: 'S\$'),
      const CurrencyModel(
        code: 'HKD',
        name: 'Hong Kong Dollar',
        symbol: 'HK\$',
      ),
      const CurrencyModel(code: 'THB', name: 'Thai Baht', symbol: '฿'),
      const CurrencyModel(code: 'MYR', name: 'Malaysian Ringgit', symbol: 'RM'),
      const CurrencyModel(code: 'IDR', name: 'Indonesian Rupiah', symbol: 'Rp'),
      const CurrencyModel(code: 'PHP', name: 'Philippine Peso', symbol: '₱'),
      const CurrencyModel(code: 'VND', name: 'Vietnamese Dong', symbol: '₫'),
      const CurrencyModel(code: 'PKR', name: 'Pakistani Rupee', symbol: '₨'),
      const CurrencyModel(code: 'BDT', name: 'Bangladeshi Taka', symbol: '৳'),
      const CurrencyModel(code: 'LKR', name: 'Sri Lankan Rupee', symbol: '₨'),
      const CurrencyModel(code: 'NPR', name: 'Nepalese Rupee', symbol: '₨'),
      const CurrencyModel(code: 'MMK', name: 'Myanmar Kyat', symbol: 'K'),
      const CurrencyModel(code: 'LAK', name: 'Lao Kip', symbol: '₭'),
      const CurrencyModel(code: 'KHR', name: 'Cambodian Riel', symbol: '៛'),
      const CurrencyModel(code: 'NOK', name: 'Norwegian Krone', symbol: 'kr'),
      const CurrencyModel(code: 'SEK', name: 'Swedish Krona', symbol: 'kr'),
      const CurrencyModel(code: 'DKK', name: 'Danish Krone', symbol: 'kr'),
      const CurrencyModel(code: 'PLN', name: 'Polish Zloty', symbol: 'zł'),
      const CurrencyModel(code: 'CZK', name: 'Czech Koruna', symbol: 'Kč'),
      const CurrencyModel(code: 'HUF', name: 'Hungarian Forint', symbol: 'Ft'),
      const CurrencyModel(code: 'RON', name: 'Romanian Leu', symbol: 'lei'),
      const CurrencyModel(code: 'BGN', name: 'Bulgarian Lev', symbol: 'лв'),
      const CurrencyModel(code: 'HRK', name: 'Croatian Kuna', symbol: 'kn'),
      const CurrencyModel(code: 'RSD', name: 'Serbian Dinar', symbol: 'дин'),
      const CurrencyModel(code: 'RUB', name: 'Russian Ruble', symbol: '₽'),
      const CurrencyModel(code: 'UAH', name: 'Ukrainian Hryvnia', symbol: '₴'),
      const CurrencyModel(code: 'TRY', name: 'Turkish Lira', symbol: '₺'),
      const CurrencyModel(code: 'ISK', name: 'Icelandic Krona', symbol: 'kr'),
      const CurrencyModel(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ'),
      const CurrencyModel(code: 'SAR', name: 'Saudi Riyal', symbol: '﷼'),
      const CurrencyModel(code: 'QAR', name: 'Qatari Riyal', symbol: '﷼'),
      const CurrencyModel(code: 'KWD', name: 'Kuwaiti Dinar', symbol: 'د.ك'),
      const CurrencyModel(code: 'BHD', name: 'Bahraini Dinar', symbol: '.د.ب'),
      const CurrencyModel(code: 'OMR', name: 'Omani Rial', symbol: '﷼'),
      const CurrencyModel(code: 'JOD', name: 'Jordanian Dinar', symbol: 'د.ا'),
      const CurrencyModel(code: 'LBP', name: 'Lebanese Pound', symbol: '£'),
      const CurrencyModel(code: 'ILS', name: 'Israeli Shekel', symbol: '₪'),
      const CurrencyModel(code: 'IRR', name: 'Iranian Rial', symbol: '﷼'),
      const CurrencyModel(code: 'IQD', name: 'Iraqi Dinar', symbol: 'د.ع'),
      const CurrencyModel(code: 'ZAR', name: 'South African Rand', symbol: 'R'),
      const CurrencyModel(code: 'EGP', name: 'Egyptian Pound', symbol: '£'),
      const CurrencyModel(code: 'NGN', name: 'Nigerian Naira', symbol: '₦'),
      const CurrencyModel(code: 'KES', name: 'Kenyan Shilling', symbol: 'KSh'),
      const CurrencyModel(code: 'GHS', name: 'Ghanaian Cedi', symbol: '₵'),
      const CurrencyModel(code: 'ETB', name: 'Ethiopian Birr', symbol: 'Br'),
      const CurrencyModel(code: 'UGX', name: 'Ugandan Shilling', symbol: 'USh'),
      const CurrencyModel(
        code: 'TZS',
        name: 'Tanzanian Shilling',
        symbol: 'TSh',
      ),
      const CurrencyModel(code: 'ZMW', name: 'Zambian Kwacha', symbol: 'ZK'),
      const CurrencyModel(code: 'BWP', name: 'Botswana Pula', symbol: 'P'),
      const CurrencyModel(code: 'MAD', name: 'Moroccan Dirham', symbol: 'د.م.'),
      const CurrencyModel(code: 'TND', name: 'Tunisian Dinar', symbol: 'د.ت'),
      const CurrencyModel(code: 'DZD', name: 'Algerian Dinar', symbol: 'د.ج'),
      const CurrencyModel(code: 'BRL', name: 'Brazilian Real', symbol: 'R\$'),
      const CurrencyModel(code: 'MXN', name: 'Mexican Peso', symbol: '\$'),
      const CurrencyModel(code: 'ARS', name: 'Argentine Peso', symbol: '\$'),
      const CurrencyModel(code: 'CLP', name: 'Chilean Peso', symbol: '\$'),
      const CurrencyModel(code: 'COP', name: 'Colombian Peso', symbol: '\$'),
      const CurrencyModel(code: 'PEN', name: 'Peruvian Sol', symbol: 'S/'),
      const CurrencyModel(
        code: 'VES',
        name: 'Venezuelan Bolívar',
        symbol: 'Bs',
      ),
      const CurrencyModel(code: 'UYU', name: 'Uruguayan Peso', symbol: '\$U'),
      const CurrencyModel(code: 'PYG', name: 'Paraguayan Guarani', symbol: '₲'),
      const CurrencyModel(
        code: 'BOB',
        name: 'Bolivian Boliviano',
        symbol: 'Bs',
      ),
      const CurrencyModel(code: 'GTQ', name: 'Guatemalan Quetzal', symbol: 'Q'),
      const CurrencyModel(code: 'HNL', name: 'Honduran Lempira', symbol: 'L'),
      const CurrencyModel(
        code: 'NIO',
        name: 'Nicaraguan Córdoba',
        symbol: 'C\$',
      ),
      const CurrencyModel(code: 'CRC', name: 'Costa Rican Colón', symbol: '₡'),
      const CurrencyModel(
        code: 'PAB',
        name: 'Panamanian Balboa',
        symbol: 'B/.',
      ),
      const CurrencyModel(code: 'JMD', name: 'Jamaican Dollar', symbol: 'J\$'),
      const CurrencyModel(
        code: 'TTD',
        name: 'Trinidad & Tobago Dollar',
        symbol: 'TT\$',
      ),
      const CurrencyModel(
        code: 'NZD',
        name: 'New Zealand Dollar',
        symbol: 'NZ\$',
      ),
      const CurrencyModel(code: 'FJD', name: 'Fijian Dollar', symbol: 'FJ\$'),
      const CurrencyModel(code: 'TOP', name: 'Tongan Paʻanga', symbol: 'T\$'),
      const CurrencyModel(code: 'WST', name: 'Samoan Tala', symbol: 'SAT'),
      const CurrencyModel(
        code: 'SBD',
        name: 'Solomon Islands Dollar',
        symbol: 'SI\$',
      ),
      const CurrencyModel(code: 'VUV', name: 'Vanuatu Vatu', symbol: 'VT'),
      const CurrencyModel(
        code: 'PGK',
        name: 'Papua New Guinea Kina',
        symbol: 'K',
      ),
      const CurrencyModel(code: 'XAU', name: 'Gold (Troy Ounce)', symbol: 'oz'),
      const CurrencyModel(
        code: 'XAG',
        name: 'Silver (Troy Ounce)',
        symbol: 'oz',
      ),
      const CurrencyModel(code: 'BTC', name: 'Bitcoin', symbol: '₿'),
      const CurrencyModel(code: 'ETH', name: 'Ethereum', symbol: 'Ξ'),
    ];
    return currencies;
  }
  @override
  Future<ExchangeRateModel> getExchangeRate({
    required String from,
    required String to,
  }) async {
    final url = ApiConfig.getConvertUrl(from: from, to: to, amount: 1.0);
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      print("uuuuuuuuuuuuuuuuuuuuuuuu");
      final apiResponse = ApiConversionResponse.fromJson(response.data);
      return ExchangeRateModel(
        fromCurrency: from,
        toCurrency: to,
        rate: apiResponse.result.rate,
        timestamp: DateTime.now(),
      );
    } else {
      throw Exception('Failed to get exchange rate');
    }
  }
  @override
  Future<ConversionResultModel> convertCurrency({
    required double amount,
    required String from,
    required String to,
  }) async {
    final url = ApiConfig.getConvertUrl(from: from, to: to, amount: amount);
    final response = await dio.get(url);
    print("iiiiiiiiiiiiiiiiiiiiiiiiii   ${response.data}");
    print("iiiiiiiiiiiiiiiiiiiiiiiiii   ${response.statusCode}");
    if (response.statusCode == 200) {
      print("uuuuuuuuuuuuuuuuuuuuuuuu  ${ApiConversionResponse}");
      final apiResponse = ApiConversionResponse.fromJson(response.data);
      print("555555555555555555555555555  ${apiResponse}");
      return ConversionResultModel(
        amount: amount,
        fromCurrency: from,
        toCurrency: to,
        convertedAmount: apiResponse.result.convertedAmount,
        exchangeRate: apiResponse.result.rate,
        timestamp: DateTime.now(),
      );
    } else {
      throw Exception('Failed to convert currency');
    }
  }
}
