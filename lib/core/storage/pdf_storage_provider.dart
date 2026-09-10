import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';
import 'pdf_storage_factory.dart';
import 'pdf_storage_service.dart';

final pdfStorageServiceProvider = Provider<PdfStorageService>((ref) {
  final localStorage = ref.watch(storageServiceProvider);
  return getPlatformPdfStorage(localStorage: localStorage);
});
