import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/database/app_database.dart';
import 'package:libora/features/library/data/repositories/pdf_repository.dart';
import 'package:libora/features/library/domain/models/pdf_item.dart';
import 'package:libora/features/reader/presentation/controllers/reader_controller.dart';
import 'package:libora/features/reader/presentation/controllers/reader_state.dart';

import '../helpers/test_database.dart';

void main() {
  group('ReaderState Logic & Progress Tests', () {
    test('initial state defaults to loading', () {
      const state = ReaderState();
      expect(state.status, equals(ReaderStatus.loading));
      expect(state.currentPage, equals(1));
      expect(state.totalPages, equals(0));
      expect(state.isToolbarVisible, isTrue);
      expect(state.isFileAvailable, isTrue);
    });

    test('calculates reading progress correctly', () {
      // 127 / 464 = 27.37% -> 27%
      final state = const ReaderState().copyWith(
        status: ReaderStatus.ready,
        currentPage: 127,
        totalPages: 464,
      );

      expect(state.progress, closeTo(127 / 464, 0.001));
      expect(state.progressPercent, equals(27));
      expect(state.pageIndicator, equals('127 / 464'));
    });

    test('progress edge cases: 0 pages, page 1, last page', () {
      const emptyState = ReaderState(currentPage: 1, totalPages: 0);
      expect(emptyState.progress, equals(0.0));
      expect(emptyState.progressPercent, equals(0));
      expect(emptyState.pageIndicator, equals('1'));

      const firstPage = ReaderState(currentPage: 1, totalPages: 100);
      expect(firstPage.progress, equals(0.01));
      expect(firstPage.progressPercent, equals(1));

      const lastPage = ReaderState(currentPage: 100, totalPages: 100);
      expect(lastPage.progress, equals(1.0));
      expect(lastPage.progressPercent, equals(100));
    });

    test('toggles toolbar visibility', () {
      var state = const ReaderState(isToolbarVisible: true);
      state = state.copyWith(isToolbarVisible: !state.isToolbarVisible);
      expect(state.isToolbarVisible, isFalse);
      state = state.copyWith(isToolbarVisible: !state.isToolbarVisible);
      expect(state.isToolbarVisible, isTrue);
    });

    test('controlled error state retains file availability flag', () {
      final state = const ReaderState().copyWith(
        status: ReaderStatus.error,
        errorMessage: () => 'The local file could not be found.',
        isFileAvailable: false,
      );

      expect(state.status, equals(ReaderStatus.error));
      expect(state.errorMessage, contains('could not be found'));
      expect(state.isFileAvailable, isFalse);
    });
  });

  group('ReaderController Integration & Persistence Tests', () {
    late AppDatabase db;
    late PdfRepository pdfRepo;
    late Directory tempDir;
    late File samplePdfFile;

    setUp(() async {
      db = createTestDatabase();
      pdfRepo = DriftPdfRepository(db.pdfsDao);
      tempDir = await Directory.systemTemp.createTemp('libora_reader_test_');

      // Create a valid dummy file so file.existsSync() passes
      samplePdfFile = File('${tempDir.path}/clean_code.pdf');
      await samplePdfFile.writeAsString('%PDF-1.4 dummy content');
    });

    tearDown(() async {
      await db.close();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'restores previously saved reading position (lastPage = 127)',
      () async {
        final now = DateTime.now();
        final item = PdfItem(
          id: 'pdf-restore-test',
          title: 'Clean Code',
          fileName: 'clean_code.pdf',
          localPath: samplePdfFile.path,
          currentPage: 127,
          pageCount: 464,
          createdAt: now,
          updatedAt: now,
        );
        await pdfRepo.savePdf(item);

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            pdfRepositoryProvider.overrideWithValue(pdfRepo),
          ],
        );
        addTearDown(container.dispose);

        // Read controller and wait for async loading
        container.read(readerControllerProvider('pdf-restore-test'));
        // Allow async load to complete
        await Future<void>.delayed(const Duration(milliseconds: 50));

        final state = container.read(
          readerControllerProvider('pdf-restore-test'),
        );
        expect(state.status, equals(ReaderStatus.ready));
        expect(state.currentPage, equals(127));
        expect(state.totalPages, equals(464));
        expect(state.progressPercent, equals(27));
      },
    );

    test('missing file produces controlled error state with isFileAvailable = false', () async {
      final now = DateTime.now();
      final item = PdfItem(
        id: 'pdf-missing-file',
        title: 'Ghost Document',
        fileName: 'ghost.pdf',
        localPath: '/tmp/does_not_exist_libora_99999.pdf',
        createdAt: now,
        updatedAt: now,
      );
      await pdfRepo.savePdf(item);

      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          pdfRepositoryProvider.overrideWithValue(pdfRepo),
        ],
      );
      addTearDown(container.dispose);

      container.read(readerControllerProvider('pdf-missing-file'));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = container.read(
        readerControllerProvider('pdf-missing-file'),
      );
      expect(state.status, equals(ReaderStatus.error));
      expect(state.isFileAvailable, isFalse);
      expect(state.errorMessage, contains('no longer available'));
    });

    test('persistPosition saves current page to SQLite', () async {
      final now = DateTime.now();
      final item = PdfItem(
        id: 'pdf-persist-test',
        title: 'The Pragmatic Programmer',
        fileName: 'pragmatic.pdf',
        localPath: samplePdfFile.path,
        currentPage: 1,
        pageCount: 352,
        createdAt: now,
        updatedAt: now,
      );
      await pdfRepo.savePdf(item);

      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          pdfRepositoryProvider.overrideWithValue(pdfRepo),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(
        readerControllerProvider('pdf-persist-test').notifier,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Change page to 128
      controller.onPageChanged(128);
      // Explicit immediate persist (as happens on back/exit)
      await controller.persistPosition();

      final updated = await pdfRepo.getPdfById('pdf-persist-test');
      expect(updated?.currentPage, equals(128));
      expect(updated?.lastReadAt, isNotNull);
    });

    test(
      'deletePdf cleans up entry from repository on missing file removal',
      () async {
        final now = DateTime.now();
        final item = PdfItem(
          id: 'pdf-delete-test',
          title: 'Delete Me',
          fileName: 'delete.pdf',
          localPath: '/tmp/nonexistent.pdf',
          createdAt: now,
          updatedAt: now,
        );
        await pdfRepo.savePdf(item);

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            pdfRepositoryProvider.overrideWithValue(pdfRepo),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(
          readerControllerProvider('pdf-delete-test').notifier,
        );
        await Future<void>.delayed(const Duration(milliseconds: 50));

        await controller.deletePdf();

        final queried = await pdfRepo.getPdfById('pdf-delete-test');
        expect(queried, isNull);
      },
    );
  });
}
