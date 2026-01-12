import 'dart:convert';
import '../../../../../../lib/core/common/constants/server_constant.dart';
import '../../../../core/errors/exception.dart';
import '../../models/product_model.dart';
import 'package:http/http.dart' as http;

abstract interface class ProductRemoteData {
  Future<List<ProductModel>> getAllProduct();
}

class ProductRemoteDataImpl implements ProductRemoteData {
  @override
  Future<List<ProductModel>> getAllProduct() async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/product/allproduct'),
        headers: {'Content-Type': 'application/json'},
      );
      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        throw ServerException(resBodyMap['detail']);
      }
      resBodyMap = resBodyMap as List;

      List<ProductModel> products = [];

      for (final map in resBodyMap) {
        products.add(ProductModel.fromJson(map));
      }

      return products;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
