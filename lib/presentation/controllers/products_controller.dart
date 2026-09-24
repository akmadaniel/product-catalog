import 'package:get/get.dart';
import 'package:product_catalog/data/model/product.dart';
import 'package:product_catalog/data/repository/product_repository.dart';

enum ViewState { loading, error, empty, success }

class ProductListController extends GetxController {
  final ProductRepository _repository;
  ProductListController(this._repository);

  static const int _pageSize = 20;

  final state = ViewState.loading.obs;
  final products = <Product>[].obs;
  final errorMessage = ''.obs;
  final isLoadingMore = false.obs;

  int _skip = 0;
  int _total = 0;

  bool get hasMore => _skip < _total;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  bool _isLoading = false;

  Future<void> loadInitial({bool showSpinner = true}) async {
    if (_isLoading) return;
    _isLoading = true;
    if (showSpinner) state.value = ViewState.loading;
    try {
      final result = await _repository.getProducts(limit: _pageSize, skip: 0);
      products.assignAll(result.products);
      _total = result.total;
      _skip = result.products.length;
      state.value = products.isEmpty ? ViewState.empty : ViewState.success;
    } catch (e) {
      errorMessage.value = e.toString();
      state.value = ViewState.error;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> onPullRefresh() async {
    try {
      final result = await _repository.getProducts(limit: _pageSize, skip: 0);
      products.assignAll(result.products);
      _total = result.total;
      _skip = result.products.length;
      state.value = products.isEmpty ? ViewState.empty : ViewState.success;
    } catch (e) {
      errorMessage.value = e.toString();
      state.value = ViewState.error;
    }
  }
}
