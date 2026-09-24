import 'package:get/get.dart';
import 'package:product_catalog/data/api/product_api.dart';
import 'package:product_catalog/data/repository/product_repository.dart';
import 'package:product_catalog/presentation/controllers/products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    final api = ProductApi();
    final repository = ProductRepository(api);
    Get.put(ProductListController(repository));
  }
}