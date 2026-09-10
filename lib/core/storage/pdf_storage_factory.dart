import 'pdf_storage_service.dart';
import 'pdf_storage_stub.dart'
    if (dart.library.io) 'desktop/desktop_pdf_storage.dart'
    if (dart.library.js_interop) 'web/web_pdf_storage.dart';

PdfStorageService getPlatformPdfStorage({dynamic localStorage}) =>
    createPdfStorage(localStorage: localStorage);
