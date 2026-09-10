import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/breakpoints.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../library/presentation/controllers/library_controller.dart';
import '../../domain/models/sync_result.dart';
import '../../domain/models/sync_status.dart';
import '../controllers/github_connection_controller.dart';
import '../controllers/github_providers.dart';
import '../controllers/github_repository_controller.dart';
import '../controllers/sync_controller.dart';

class GitHubScreen extends ConsumerStatefulWidget {
  const GitHubScreen({super.key});

  @override
  ConsumerState<GitHubScreen> createState() => _GitHubScreenState();
}

class _GitHubScreenState extends ConsumerState<GitHubScreen> {
  final TextEditingController _tokenController = TextEditingController();
  bool _obscureToken = true;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final connectionState = ref.watch(gitHubConnectionControllerProvider);
    final isMobile = Breakpoints.isMobile(MediaQuery.of(context).size.width);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? AppSpacing.md : AppSpacing.xxl,
                vertical: isMobile ? AppSpacing.md : AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSectionHeader(
                    eyebrow: 'REMOTE STORAGE',
                    title: 'GitHub Synchronization',
                    subtitle: 'Connect your GitHub repository to mirror, back up, and synchronize your PDF collection.',
                    trailing: connectionState.isConnected
                        ? AppButton.ghost(
                            label: 'Disconnect',
                            icon: Icons.link_off_rounded,
                            size: AppButtonSize.small,
                            onPressed: () => _confirmDisconnect(context),
                          )
                        : null,
                    showBottomBorder: true,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: connectionState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : connectionState.isConnected
                            ? _buildConnectedView(context, isDark, isMobile)
                            : _buildDisconnectedView(context, isDark, isMobile, connectionState),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Disconnected View: PAT Form & Instructions
  // ===========================================================================

  Widget _buildDisconnectedView(
    BuildContext context,
    bool isDark,
    bool isMobile,
    GitHubConnectionState connectionState,
  ) {
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            borderRadius: AppSpacing.roundedMd,
                            border: Border.all(color: borderColor),
                          ),
                          child: Icon(
                            Icons.key_rounded,
                            size: 24,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.strongCharcoal,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Personal Access Token',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.strongCharcoal,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Securely stored on this device in FlutterSecureStorage.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    if (connectionState.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.red.shade900.withValues(alpha: 0.15),
                          borderRadius: AppSpacing.roundedSm,
                          border: Border.all(color: Colors.red.shade800),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                connectionState.errorMessage!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red.shade200,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    TextField(
                      controller: _tokenController,
                      obscureText: _obscureToken,
                      decoration: InputDecoration(
                        labelText: 'GitHub Token',
                        hintText: 'ghp_... or github_pat_...',
                        filled: true,
                        fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                        border: OutlineInputBorder(
                          borderRadius: AppSpacing.roundedSm,
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppSpacing.roundedSm,
                          borderSide: BorderSide(color: borderColor),
                        ),
                        prefixIcon: const Icon(Icons.password_rounded, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureToken ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureToken = !_obscureToken;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    SizedBox(
                      width: double.infinity,
                      child: AppButton.primary(
                        label: connectionState.isLoading ? 'Connecting...' : 'Connect to GitHub',
                        icon: Icons.link_rounded,
                        onPressed: connectionState.isLoading
                            ? null
                            : () async {
                                final text = _tokenController.text.trim();
                                if (text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter a GitHub token.')),
                                  );
                                  return;
                                }
                                final success = await ref
                                    .read(gitHubConnectionControllerProvider.notifier)
                                    .connectWithToken(text);
                                if (success && context.mounted) {
                                  _tokenController.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('GitHub connected successfully!')),
                                  );
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Instructions Card
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOKEN PERMISSIONS & SETUP',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'To allow Libora to list repositories, push local PDFs, and mirror folders:',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildPermissionBullet(
                      'Fine-grained PAT (Recommended)',
                      'Grant "Contents: Read and write" repository permission for your target library repository.',
                      isDark,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _buildPermissionBullet(
                      'Classic Token',
                      'Check the "repo" scope (full control of private repositories).',
                      isDark,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Divider(color: borderColor),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Generate tokens at: github.com/settings/tokens',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ),
                        AppButton.ghost(
                          label: 'Copy URL',
                          icon: Icons.copy_rounded,
                          size: AppButtonSize.small,
                          onPressed: () {
                            Clipboard.setData(
                              const ClipboardData(text: 'https://github.com/settings/tokens'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('URL copied to clipboard!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionBullet(String title, String description, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: 16,
            color: isDark ? Colors.teal.shade300 : Colors.teal.shade700,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextPrimary : AppColors.strongCharcoal,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: description,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Connected View: Account, Repository Selector & Sync Status
  // ===========================================================================

  Widget _buildConnectedView(BuildContext context, bool isDark, bool isMobile) {
    final account = ref.watch(gitHubAccountStreamProvider).value;
    final selectedRepo = ref.watch(gitHubSelectedRepoStreamProvider).value;
    final allRepos = ref.watch(gitHubAllReposStreamProvider).value ?? [];
    final syncState = ref.watch(syncControllerProvider);
    final libraryState = ref.watch(libraryControllerProvider);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Account Profile Card
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  backgroundImage: account?.avatarUrl != null ? NetworkImage(account!.avatarUrl!) : null,
                  child: account?.avatarUrl == null
                      ? Text(
                          (account?.login.isNotEmpty ?? false) ? account!.login[0].toUpperCase() : 'G',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              account?.displayName ?? 'GitHub User',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.strongCharcoal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const AppBadge(label: 'CONNECTED'),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@${account?.login ?? 'unknown'}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Active Repository Card & Picker
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ACTIVE REPOSITORY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    AppButton.ghost(
                      label: 'Refresh Repos',
                      icon: Icons.refresh_rounded,
                      size: AppButtonSize.small,
                      onPressed: () => ref
                          .read(gitHubRepositoryControllerProvider.notifier)
                          .refreshRepositories(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (allRepos.isEmpty) ...[
                  Text(
                    'No repositories found. Ensure your personal access token has repository permissions.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ] else ...[
                  DropdownButtonFormField<String>(
                    initialValue: selectedRepo?.id,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                      border: OutlineInputBorder(
                        borderRadius: AppSpacing.roundedSm,
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppSpacing.roundedSm,
                        borderSide: BorderSide(color: borderColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    items: allRepos.map((repo) {
                      return DropdownMenuItem<String>(
                        value: repo.id,
                        child: Row(
                          children: [
                            Icon(
                              repo.isPrivate ? Icons.lock_outline_rounded : Icons.public_rounded,
                              size: 16,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(repo.fullName),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (selectedId) async {
                      if (selectedId != null) {
                        await ref
                            .read(gitHubRepositoryControllerProvider.notifier)
                            .selectRepository(selectedId);
                      }
                    },
                  ),
                ],
                if (selectedRepo != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Chip(
                        avatar: const Icon(Icons.fork_right_rounded, size: 14),
                        label: Text(
                          selectedRepo.defaultBranch,
                          style: const TextStyle(fontSize: 11),
                        ),
                        backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Chip(
                        avatar: Icon(
                          selectedRepo.isPrivate ? Icons.lock_rounded : Icons.public_rounded,
                          size: 14,
                        ),
                        label: Text(
                          selectedRepo.isPrivate ? 'Private' : 'Public',
                          style: const TextStyle(fontSize: 11),
                        ),
                        backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
                      ),
                      const Spacer(),
                      if (selectedRepo.lastSyncedAt != null)
                        Text(
                          'Last synced: ${DateFormat.yMMMd().add_jm().format(selectedRepo.lastSyncedAt!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Sync Action & Status Bar
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SYNCHRONIZATION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    AppButton.primary(
                      label: syncState.status.isSyncing ? 'Syncing...' : 'Sync Now',
                      icon: Icons.sync_rounded,
                      size: AppButtonSize.small,
                      onPressed: (selectedRepo == null || syncState.status.isSyncing)
                          ? null
                          : () => ref.read(syncControllerProvider.notifier).syncNow(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Overall Sync Banner
                _buildSyncStatusBanner(syncState, isDark),

                if (syncState.status.isSyncing && syncState.progress != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  LinearProgressIndicator(
                    value: syncState.progress?.percentage != null
                        ? syncState.progress!.percentage! / 100.0
                        : null,
                    backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  ),
                ],

                if (syncState.lastResult != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildSyncSummaryBox(syncState.lastResult!, isDark),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Library Mirror Status List
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MIRRORED DOCUMENTS (${libraryState.allPdfs.length})',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (libraryState.allPdfs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(
                      child: Text(
                        'No local PDFs in library yet.',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                  )
                else ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: libraryState.allPdfs.length,
                    separatorBuilder: (_, _) => Divider(color: borderColor, height: 1),
                    itemBuilder: (context, index) {
                      final pdf = libraryState.allPdfs[index];
                      return Consumer(
                        builder: (context, ref, child) {
                          final syncMeta = ref.watch(gitHubSyncMetadataForPdfProvider(pdf.id)).value;

                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.picture_as_pdf_rounded,
                              size: 20,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            title: Text(
                              pdf.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              syncMeta?.remotePath ?? pdf.fileName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                            trailing: _buildStatusPill(syncMeta?.syncStatus ?? SyncStatus.uploadPending, isDark),
                          );
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSyncStatusBanner(SyncState syncState, bool isDark) {
    Color bg;
    Color border;
    IconData icon;
    Color iconColor;
    String message;

    switch (syncState.status) {
      case OverallSyncStatus.syncing:
        bg = Colors.blue.shade900.withValues(alpha: 0.15);
        border = Colors.blue.shade700;
        icon = Icons.sync_rounded;
        iconColor = Colors.blue;
        message = syncState.progress?.message ?? 'Syncing changes with GitHub...';
        break;
      case OverallSyncStatus.synced:
        bg = Colors.teal.shade900.withValues(alpha: 0.15);
        border = Colors.teal.shade700;
        icon = Icons.check_circle_rounded;
        iconColor = Colors.teal;
        message = 'Local library is fully synchronized with GitHub.';
        break;
      case OverallSyncStatus.uploadPending:
        bg = Colors.amber.shade900.withValues(alpha: 0.15);
        border = Colors.amber.shade700;
        icon = Icons.cloud_upload_outlined;
        iconColor = Colors.amber;
        message = 'You have local documents waiting to be pushed to GitHub.';
        break;
      case OverallSyncStatus.offline:
        bg = Colors.grey.shade900.withValues(alpha: 0.15);
        border = Colors.grey.shade700;
        icon = Icons.cloud_off_rounded;
        iconColor = Colors.grey;
        message = syncState.errorMessage ?? 'Offline. Local modifications will sync once connection restores.';
        break;
      case OverallSyncStatus.conflict:
        bg = Colors.orange.shade900.withValues(alpha: 0.15);
        border = Colors.orange.shade700;
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.orange;
        message = 'Sync conflict detected. Both local and remote copies were modified.';
        break;
      case OverallSyncStatus.error:
        bg = Colors.red.shade900.withValues(alpha: 0.15);
        border = Colors.red.shade700;
        icon = Icons.error_outline_rounded;
        iconColor = Colors.red;
        message = syncState.errorMessage ?? 'An error occurred during sync.';
        break;
      case OverallSyncStatus.idle:
        bg = isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle;
        border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
        icon = Icons.cloud_done_outlined;
        iconColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
        message = 'Ready to sync with active repository.';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.roundedSm,
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextPrimary : AppColors.strongCharcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncSummaryBox(SyncResult result, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: AppSpacing.roundedSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Uploaded', result.uploadedCount.toString(), Colors.teal),
          _buildSummaryItem('Downloaded', result.downloadedCount.toString(), Colors.blue),
          _buildSummaryItem('Deleted', result.deletedCount.toString(), Colors.grey),
          _buildSummaryItem('Conflicts', result.conflictCount.toString(), Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildStatusPill(SyncStatus status, bool isDark) {
    String label;
    Color color;

    switch (status) {
      case SyncStatus.synced:
        label = 'SYNCED';
        color = Colors.teal;
        break;
      case SyncStatus.uploadPending:
        label = 'UPLOAD PENDING';
        color = Colors.amber.shade700;
        break;
      case SyncStatus.downloadPending:
        label = 'DOWNLOAD PENDING';
        color = Colors.blue;
        break;
      case SyncStatus.deletePending:
        label = 'DELETE PENDING';
        color = Colors.red;
        break;
      case SyncStatus.syncing:
        label = 'SYNCING';
        color = Colors.blue;
        break;
      case SyncStatus.conflict:
        label = 'CONFLICT';
        color = Colors.orange;
        break;
      case SyncStatus.error:
        label = 'ERROR';
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: color,
        ),
      ),
    );
  }

  Future<void> _confirmDisconnect(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Disconnect from GitHub?'),
          content: const Text(
            'Your local PDF collection, bookmarks, and folders will remain completely safe on this device. Your personal access token will be removed.',
          ),
          actions: [
            AppButton.ghost(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(false),
            ),
            AppButton.primary(
              label: 'Disconnect',
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await ref.read(gitHubConnectionControllerProvider.notifier).disconnect();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Disconnected from GitHub.')),
        );
      }
    }
  }
}
