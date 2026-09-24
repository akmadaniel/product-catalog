# Product Catalog

Flutter app that lists products from the dummy api, with pagination, search and a detail screen. Built for the Neurogine technical assessment.

## How to run
1. Install Flutter (I used 3.35.1 flutter version).
2. `flutter pub get`
3. `flutter run`
4. Tests: `flutter test`

## Stack
- Flutter, Dart
- GetX (state management, navigation, dependency injection)
- `http` for networking. The app only needs plain GET requests, so I skipped `dio`. `http` has no built-in timeout, so I add one myself.

## Architecture
Two layers under `lib/`:
- `data/`: `model` (Product, ProductList), `api` (ProductApi, ApiException)
- `repository/` (ProductRepository)
- `presentation/`: `bindings`, `controllers`, `views`, `widgets`

The controller receives its repository through the constructor, so tests can pass in a fake. The repository turns network errors into one `ApiException` with a readable message. The screen has 4 states: loading, error with retry, empty, success. Pagination uses `skip` with `total` (`hasMore = skip < total`).

## Search: server-side
Only 20 items are loaded at a time out of 194, so client-side filtering would miss most products. I use `/products/search?q=` with a 500 ms debounce. Each request gets an id, and older responses are ignored, so a slow response can't overwrite a newer one.

## UI/UX detail
The search box sits in the app bar, outside the state switch, so it stays visible and keeps its text in the loading, error and empty states. The loading indicator is the last list row, so it scrolls with the list.

## AI usage disclosure
I used Claude Code as a tutor while building this. It explained the concepts, suggested the folder structure and build order, reviewed my code and helped me find bugs (for example the double request on startup and a price parsing crash that my unit test caught). For most files, it showed me reference code, which I typed into my own files, then changed and tested.

## Known limitations / TODOs
- `loadMore` doesn't check the request id, so a search started during a page load could append stale results.
- Detail page builds its own repository instead of reusing the one from the list binding.
- No widget tests, only `Product.fromJson` unit tests.