import 'dart:async';

import 'package:get/get.dart';
import 'package:product_catalog/data/model/product.dart';
import 'package:product_catalog/data/model/product_list.dart';
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

  String _query = '';
  Timer? _debounce;
  int _requestId = 0;

  bool get hasMore => _skip < _total;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  bool _isLoading = false;

  Future<void> loadInitial({bool showSpinner = true}) async {
    final id = ++_requestId;
    _isLoading = true;
    if (showSpinner) state.value = ViewState.loading;
    try {
      final result = await _fetch(0);
      if (id != _requestId) return;
      products.assignAll(result.products);
      _total = result.total;
      _skip = result.products.length;
      state.value = products.isEmpty ? ViewState.empty : ViewState.success;
    } catch (e) {
      if (id != _requestId) return;
      errorMessage.value = e.toString();
      state.value = ViewState.error;
    } finally {
      if (id == _requestId) _isLoading = false;
    }
  }

  Future<void> onPullRefresh() async {
    await loadInitial(showSpinner: false);
  }

  void onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final q = text.trim();
      if (q == _query) return;
      _query = q;
      loadInitial();
    });
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value || _isLoading) return;
    if (state.value != ViewState.success) return;

    isLoadingMore.value = true;
    try {
      final result = await _fetch(_skip);
      products.addAll(result.products);
      _total = result.total;
      _skip += result.products.length;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<ProductList> _fetch(int skip) {
    return _query.isEmpty
        ? _repository.getProducts(limit: _pageSize, skip: skip)
        : _repository.searchProducts(_query, limit: _pageSize, skip: skip);
  }
}
