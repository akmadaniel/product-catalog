import 'package:get/get.dart';
import 'package:product_catalog/data/model/product.dart';
import 'package:product_catalog/data/repository/product_repository.dart';
import 'package:product_catalog/presentation/controllers/products_controller.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _repository;
  final int productId;

  ProductDetailController(this._repository, this.productId);

  final state = ViewState.loading.obs;
  final product = Rxn<Product>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = ViewState.loading;
    try {
      product.value = await _repository.getProduct(productId);
      state.value = ViewState.success;
    } catch (e) {
      errorMessage.value = e.toString();
      state.value = ViewState.error;
    }
  }
}