import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models.dart';
import '../view_models/admin_view_model.dart';

/// Renders the complete, highly responsive administrative workstation layout,
/// featuring a navigation sidebar, an interactive visualizer tree, source
/// ingestion editors, approval diff boards, and data exporters.
class AdminDashboardView extends StatefulWidget {
  final AdminViewModel viewModel;

  const AdminDashboardView({super.key, required this.viewModel});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _activeTab = 0; // 0: Dashboard, 1: Content Visualizer, 2: Ingestion & LLM, 3: Approval Board
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _fileContentController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();

  String _selectedModuleId = 'polity_u1_m1'; // Target module default for approvals

  @override
  void dispose() {
    _urlController.dispose();
    _fileContentController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 1. Sidebar Navigation
          _buildSidebar(),
          const VerticalDivider(),
          // 2. Main content area
          Expanded(
            child: AnimatedBuilder(
              animation: widget.viewModel,
              builder: (context, _) {
                if (widget.viewModel.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  );
                }
                return _buildMainWorkspace();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final theme = Theme.of(context);
    return Container(
      width: 250,
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shield, color: Colors.amber, size: 28),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'upscLearn',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 0.5),
                    ),
                    Text(
                      'ADMIN PANEL v1',
                      style: TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Navigation Links
          _buildSidebarNavItem(0, Icons.dashboard, 'Dashboard Summary'),
          const SizedBox(height: 12),
          _buildSidebarNavItem(1, Icons.account_tree, 'Syllabus Visualizer'),
          const SizedBox(height: 12),
          _buildSidebarNavItem(2, Icons.cloud_upload, 'Source Ingestion'),
          const SizedBox(height: 12),
          _buildSidebarNavItem(3, Icons.fact_check, 'Approval Queue'),

          const Spacer(),
          const Divider(),
          const SizedBox(height: 16),
          // User footer profile
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Text('AD'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Admin Console', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('Level 1 Approver', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSidebarNavItem(int index, IconData icon, String title) {
    final isActive = _activeTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          _activeTab = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: isActive ? Colors.amber.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: Colors.amber.withValues(alpha: 0.3), width: 1)
              : Border.all(color: Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: isActive ? Colors.amber : Colors.grey, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Colors.amber : Colors.grey.shade300,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainWorkspace() {
    switch (_activeTab) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildVisualizerTab();
      case 2:
        return _buildIngestionTab();
      case 3:
        return _buildApprovalTab();
      default:
        return const Center(child: Text('Console Panel'));
    }
  }

  // --- TAB 0: DASHBOARD TAB ---
  Widget _buildDashboardTab() {
    final activeSubject = widget.viewModel.subjects.firstWhere((s) => s.id == 'polity',
        orElse: () => const Subject(id: 'polity', name: 'Polity', description: '', iconName: '', units: []));
    final unitCount = activeSubject.units.length;
    int moduleCount = 0;
    int lessonCount = 0;
    for (var u in activeSubject.units) {
      moduleCount += u.modules.length;
      for (var m in u.modules) {
        lessonCount += m.lessons.length;
      }
    }

    final pendingApprovals = widget.viewModel.ingestedSources.where((s) => s.status == IngestionStatus.pending).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Console Dashboard', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Monitor content ingestion, database integrity status, and perform SQLite data exports.',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
          const SizedBox(height: 32),

          // Metric Stats Cards Grid
          Row(
            children: [
              Expanded(child: _buildMetricCard('Active Subjects', '1 Live (3 Locked)', Icons.book, Colors.amber)),
              const SizedBox(width: 16),
              Expanded(child: _buildMetricCard('Total Units', '$unitCount Units', Icons.list_alt, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _buildMetricCard('Total Modules', '$moduleCount Modules', Icons.splitscreen, Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildMetricCard('Total Lessons', '$lessonCount Lessons', Icons.import_contacts, Colors.purple)),
            ],
          ),
          const SizedBox(height: 32),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Exporter Panel
              Expanded(
                flex: 4,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.save_alt, color: Colors.amber),
                            SizedBox(width: 12),
                            Text('Database Exporter Center',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Generate the new polity_content.json file. You can drop this directly into the main app assets/ directory to overwrite and update the offline SQLite database at runtime on first boot.',
                          style: TextStyle(height: 1.5, fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                final jsonDb = widget.viewModel.compileJsonDatabase();
                                Clipboard.setData(ClipboardData(text: jsonDb));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('JSON database structure copied to Clipboard!')),
                                );
                              },
                              icon: const Icon(Icons.copy),
                              label: const Text('Copy JSON DB to Clipboard'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                // Direct JSON file download emulation
                                final bytes = utf8.encode(widget.viewModel.compileJsonDatabase());
                                final kb = bytes.length / 1024;
                                // Custom download dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Export JSON File'),
                                    content: Text(
                                        'File "polity_content.json" compiled successfully (${kb.toStringAsFixed(1)} KB). Save it to copy into mobile assets.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Dismiss'),
                                      )
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Download polity_content.json'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.amber),
                                foregroundColor: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final success = await widget.viewModel.writeAndSyncJsonDatabase();
                                if (!mounted) return;
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Successfully wrote and synced polity_content.json to both app asset folders!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to write JSON files. Ensure the app has write access.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber.shade700,
                                foregroundColor: Colors.black,
                              ),
                              icon: const Icon(Icons.sync),
                              label: const Text('Write & Sync to Project Assets'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Right: Ingestion Stats Summary
              Expanded(
                flex: 3,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.history, color: Colors.amber),
                            SizedBox(width: 12),
                            Text('Approvals Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildApprovalStatRow('Pending Review', '$pendingApprovals drafts', Colors.amber),
                        const Divider(height: 20),
                        _buildApprovalStatRow(
                            'Approved Ingestions',
                            '${widget.viewModel.ingestedSources.where((s) => s.status == IngestionStatus.approved).length} approved',
                            Colors.green),
                        const Divider(height: 20),
                        _buildApprovalStatRow(
                            'Rejected Feeds',
                            '${widget.viewModel.ingestedSources.where((s) => s.status == IngestionStatus.rejected).length} rejected',
                            Colors.red),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String val, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              radius: 24,
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), overflow: TextOverflow.ellipsis),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
      ],
    );
  }

  // --- TAB 1: SYLLABUS VISUALIZER ---
  Widget _buildVisualizerTab() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Syllabus Visualizer', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Explore the nested Subject -> Units -> Modules -> Lessons structure inside the active SQLite DB.',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: widget.viewModel.subjects.isEmpty
                ? const Center(child: Text('No subjects loaded.'))
                : ListView.builder(
                    itemCount: widget.viewModel.subjects.length,
                    itemBuilder: (context, index) {
                      final subject = widget.viewModel.subjects[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ExpansionTile(
                          leading: const Icon(Icons.gavel, color: Colors.amber),
                          title: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${subject.units.length} Units', style: const TextStyle(fontSize: 12)),
                          children: subject.units.map((unit) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                color: Colors.black26,
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ExpansionTile(
                                  title: Text(unit.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  subtitle: Text('${unit.modules.length} Modules', style: const TextStyle(fontSize: 11)),
                                  children: unit.modules.map((module) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: ExpansionTile(
                                        title: Text(module.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                        subtitle: Text('${module.lessons.length} Lessons | ${module.quiz.questions.length} Quiz Questions', style: const TextStyle(fontSize: 10)),
                                        children: [
                                          // Lessons list header
                                          const ListTile(
                                            dense: true,
                                            title: Text('Lessons:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 11)),
                                          ),
                                          ...module.lessons.map((lesson) {
                                            return ListTile(
                                              leading: const Icon(Icons.arrow_right, size: 16),
                                              dense: true,
                                              title: Text(lesson.name, style: const TextStyle(fontSize: 12)),
                                              subtitle: Text(lesson.description, style: const TextStyle(fontSize: 10)),
                                              trailing: TextButton.icon(
                                                onPressed: () {
                                                  widget.viewModel.selectExistingLesson(lesson, module.id);
                                                  setState(() {
                                                    _activeTab = 3; // Switch to editor workspace tab
                                                  });
                                                },
                                                icon: const Icon(Icons.edit, size: 12, color: Colors.amber),
                                                label: const Text('Edit', style: TextStyle(fontSize: 11, color: Colors.amber)),
                                              ),
                                            );
                                          }),
                                          // Quizzes list header
                                          const ListTile(
                                            dense: true,
                                            title: Text('Quiz MCQs:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 11)),
                                          ),
                                          ...module.quiz.questions.map((q) {
                                            return ListTile(
                                              leading: const Icon(Icons.help_outline, size: 16),
                                              dense: true,
                                              title: Text(q.questionText, style: const TextStyle(fontSize: 12)),
                                              subtitle: Text('Correct option: Option ${q.correctOptionIndex + 1}', style: const TextStyle(fontSize: 10)),
                                            );
                                          }),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: INGESTION & LLM INTAKE ---
  Widget _buildIngestionTab() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Add Source Forms
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Source Ingestion Portal', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Paste reference URLs or copy/paste raw text files to feed the simulated LLM extraction engine.',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
                const SizedBox(height: 32),

                // URL Input Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ingest Web URL Link', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _urlController,
                          decoration: const InputDecoration(
                            hintText: 'https://drishtiias.com/blog/judicial-review-issues...',
                            prefixIcon: Icon(Icons.link),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_urlController.text.trim().isEmpty) return;
                            widget.viewModel.ingestUrl(_urlController.text.trim());
                            _urlController.clear();
                          },
                          icon: const Icon(Icons.rocket_launch),
                          label: const Text('Ingest & Analyze URL'),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // File Input Card
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ingest Local Document File Content',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _fileNameController,
                            decoration: const InputDecoration(
                              hintText: 'Document Title (e.g. fundamental_duties_notes.txt)',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: TextField(
                              controller: _fileContentController,
                              maxLines: null,
                              expands: true,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: const InputDecoration(
                                hintText: 'Paste note summaries or raw document texts here...',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (_fileNameController.text.isEmpty || _fileContentController.text.isEmpty) return;
                              widget.viewModel.ingestFile(_fileNameController.text, _fileContentController.text);
                              _fileNameController.clear();
                              _fileContentController.clear();
                            },
                            icon: const Icon(Icons.document_scanner),
                            label: const Text('Ingest & Extract File'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          // Right: Ingested Feeds Queue List
          Expanded(
            flex: 3,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ingestion Review Feed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      'Feeds generated via the LLM pipeline. Click any pending item to open the Approval Board.',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: widget.viewModel.ingestedSources.isEmpty
                          ? const Center(child: Text('No sources ingested yet.'))
                          : ListView.builder(
                              itemCount: widget.viewModel.ingestedSources.length,
                              itemBuilder: (context, index) {
                                final item = widget.viewModel.ingestedSources[index];
                                final isPending = item.status == IngestionStatus.pending;
                                final color = item.status == IngestionStatus.approved
                                    ? Colors.green
                                    : (item.status == IngestionStatus.rejected ? Colors.red : Colors.amber);

                                return Card(
                                  color: Colors.black26,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    leading: Icon(
                                      item.type == IngestedSourceType.file ? Icons.description : Icons.link,
                                      color: color,
                                    ),
                                    title: Text(item.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      isPending ? 'Draft generated | Click to review' : 'Status: ${item.status.name}',
                                      style: TextStyle(fontSize: 10, color: color),
                                    ),
                                    trailing: const Icon(Icons.chevron_right, size: 16),
                                    onTap: () {
                                      widget.viewModel.selectSource(item);
                                      setState(() {
                                        _activeTab = 3; // Switch to approval tab
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- TAB 3: APPROVAL QUEUE TAB ---
  Widget _buildApprovalTab() {
    final isEditing = widget.viewModel.isEditingExisting;
    final source = widget.viewModel.selectedSource;

    if (source == null && !isEditing) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fact_check, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Approval Board Empty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8),
              Text('Please select an item from Ingestion Feed or Visualizer to inspect and edit content.',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _activeTab = isEditing ? 1 : 2; // Return to Visualizer or Ingestion
                    });
                    if (isEditing) {
                      widget.viewModel.cancelEditing();
                    }
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          isEditing
                              ? 'Edit Existing Lesson: ${widget.viewModel.editorLessonName}'
                              : 'Approval Review: ${source?.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                          isEditing
                              ? 'Modify the selected syllabus lesson, manually or using LLM refinement.'
                              : 'Compare the raw ingested content source vs. the parsed LLM syllabus notes.',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),

            // Double card row - locked to 580px height inside ScrollView to maintain side-by-side alignment
            SizedBox(
              height: 580,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Panel: Ingested Source or Editor Guide
                  Expanded(
                    flex: 3,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(isEditing ? Icons.edit_note : Icons.subject, color: Colors.amber),
                                const SizedBox(width: 12),
                                Text(isEditing ? 'Editing Live Content' : 'Original Ingested Source',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                            const Divider(height: 24),
                            Expanded(
                              child: SingleChildScrollView(
                                child: isEditing
                                    ? const Text(
                                        'You are currently editing an existing lesson in the live database.\n\n'
                                        '- **Manual Changes**: Edit the fields directly in the right panel and click "Save Changes to DB".\n\n'
                                        '- **LLM Refinement**: Click "Refine with LLM" in the bottom control bar to automatically expand sections, improve phrasing, or generate new practice quiz MCQs based on the current text.',
                                        style: TextStyle(height: 1.6, fontSize: 13),
                                      )
                                    : Text(
                                        source?.content ?? '',
                                        style: const TextStyle(height: 1.6, fontSize: 13, fontFamily: 'monospace'),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Right Panel: Lesson Workstation Editor
                  Expanded(
                    flex: 4,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(isEditing ? Icons.edit : Icons.smart_toy, color: Colors.green),
                                const SizedBox(width: 12),
                                Text(isEditing ? 'Lesson Workstation Editor' : 'LLM Structured Draft Note',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                            const Divider(height: 24),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 1. Title Form field
                                    const Text('Lesson Title',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      key: ValueKey('title_${widget.viewModel.activeEditorKey}'),
                                      initialValue: widget.viewModel.editorLessonName,
                                      onChanged: widget.viewModel.updateEditorLessonName,
                                      decoration: const InputDecoration(isDense: true),
                                    ),
                                    const SizedBox(height: 20),

                                    // 1.5. Description Form field
                                    const Text('Lesson Description',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      key: ValueKey('desc_${widget.viewModel.activeEditorKey}'),
                                      initialValue: widget.viewModel.editorLessonDescription,
                                      onChanged: widget.viewModel.updateEditorLessonDescription,
                                      decoration: const InputDecoration(isDense: true),
                                    ),
                                    const SizedBox(height: 20),

                                    // 2. Reading Time & Description
                                    const Text('Estimated Reading Time (Minutes)',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Slider(
                                            min: 1,
                                            max: 20,
                                            divisions: 19,
                                            value: widget.viewModel.editorReadingTime.toDouble(),
                                            onChanged: (val) {
                                              widget.viewModel.updateEditorReadingTime(val.toInt());
                                            },
                                            activeColor: Colors.amber,
                                          ),
                                        ),
                                        Text('${widget.viewModel.editorReadingTime} min',
                                            style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                                    // 3. Lesson Markdown Text
                                    const Text('Lesson Rich Content (Markdown Supported)',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      key: ValueKey('content_${widget.viewModel.activeEditorKey}'),
                                      initialValue: widget.viewModel.editorLessonContent,
                                      maxLines: 12,
                                      onChanged: widget.viewModel.updateEditorLessonContent,
                                      decoration: const InputDecoration(hintText: 'Markdown content...'),
                                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                                    ),
                                    const SizedBox(height: 28),

                                    // 4. Revision Cards Editor
                                    Row(
                                      children: [
                                        const Icon(Icons.layers_outlined, color: Colors.tealAccent, size: 16),
                                        const SizedBox(width: 8),
                                        const Text('Revision Warmup Cards',
                                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                        const Spacer(),
                                        TextButton.icon(
                                          onPressed: () {
                                            final cards = List<RevisionCard>.from(
                                                widget.viewModel.editorRevisionCards);
                                            cards.add(const RevisionCard(
                                              heading: 'New Revision Fact',
                                              body: 'Enter the key fact or concept here.',
                                            ));
                                            widget.viewModel.updateEditorRevisionCards(cards);
                                          },
                                          icon: const Icon(Icons.add, size: 14, color: Colors.tealAccent),
                                          label: const Text('Add Card',
                                              style: TextStyle(fontSize: 11, color: Colors.tealAccent)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ...List.generate(
                                      widget.viewModel.editorRevisionCards.length,
                                      (ci) {
                                        final card = widget.viewModel.editorRevisionCards[ci];
                                        return Card(
                                          color: const Color(0xFF0F1828),
                                          margin: const EdgeInsets.only(bottom: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: const BorderSide(
                                                color: Color(0xFF0F766E), width: 1),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('Card ${ci + 1}',
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.tealAccent)),
                                                    const Spacer(),
                                                    InkWell(
                                                      onTap: () {
                                                        final cards = List<RevisionCard>.from(
                                                            widget.viewModel.editorRevisionCards);
                                                        cards.removeAt(ci);
                                                        widget.viewModel.updateEditorRevisionCards(cards);
                                                      },
                                                      child: const Icon(Icons.close,
                                                          size: 14, color: Colors.redAccent),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                // Heading
                                                TextFormField(
                                                  key: ValueKey(
                                                      'rc_h_${widget.viewModel.activeEditorKey}_$ci'),
                                                  initialValue: card.heading,
                                                  onChanged: (val) {
                                                    final cards = List<RevisionCard>.from(
                                                        widget.viewModel.editorRevisionCards);
                                                    cards[ci] = RevisionCard(
                                                        heading: val,
                                                        body: cards[ci].body,
                                                        tip: cards[ci].tip);
                                                    widget.viewModel.updateEditorRevisionCards(cards);
                                                  },
                                                  decoration: const InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Heading',
                                                      labelStyle: TextStyle(fontSize: 11)),
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                                const SizedBox(height: 8),
                                                // Body
                                                TextFormField(
                                                  key: ValueKey(
                                                      'rc_b_${widget.viewModel.activeEditorKey}_$ci'),
                                                  initialValue: card.body,
                                                  maxLines: 4,
                                                  onChanged: (val) {
                                                    final cards = List<RevisionCard>.from(
                                                        widget.viewModel.editorRevisionCards);
                                                    cards[ci] = RevisionCard(
                                                        heading: cards[ci].heading,
                                                        body: val,
                                                        tip: cards[ci].tip);
                                                    widget.viewModel.updateEditorRevisionCards(cards);
                                                  },
                                                  decoration: const InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Body (Markdown)',
                                                      labelStyle: TextStyle(fontSize: 11)),
                                                  style: const TextStyle(
                                                      fontSize: 12, fontFamily: 'monospace'),
                                                ),
                                                const SizedBox(height: 8),
                                                // Tip (optional)
                                                TextFormField(
                                                  key: ValueKey(
                                                      'rc_t_${widget.viewModel.activeEditorKey}_$ci'),
                                                  initialValue: card.tip ?? '',
                                                  onChanged: (val) {
                                                    final cards = List<RevisionCard>.from(
                                                        widget.viewModel.editorRevisionCards);
                                                    cards[ci] = RevisionCard(
                                                        heading: cards[ci].heading,
                                                        body: cards[ci].body,
                                                        tip: val.trim().isEmpty
                                                            ? null
                                                            : val);
                                                    widget.viewModel.updateEditorRevisionCards(cards);
                                                  },
                                                  decoration: const InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Quick Tip (optional)',
                                                      labelStyle: TextStyle(fontSize: 11)),
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    if (widget.viewModel.editorRevisionCards.isEmpty)
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.03),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey.shade700, width: 1),
                                        ),
                                        child: const Center(
                                          child: Text(
                                              'No revision cards yet. Click "Add Card" to create one.',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.grey)),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Control Bar
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    // Target Module Select Row (inline)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Target Module: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: isEditing ? widget.viewModel.editingModuleId : _selectedModuleId,
                          dropdownColor: const Color(0xFF131722),
                          onChanged: isEditing
                              ? null
                              : (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedModuleId = val;
                                    });
                                  }
                                },
                          items: const [
                            DropdownMenuItem(
                                value: 'polity_u1_m1',
                                child: Text('Unit 1 > Module 1: Historical Background', style: TextStyle(fontSize: 12))),
                            DropdownMenuItem(
                                value: 'polity_u1_m2',
                                child: Text('Unit 1 > Module 2: Making of Constitution', style: TextStyle(fontSize: 12))),
                            DropdownMenuItem(
                                value: 'polity_u2_m3',
                                child: Text('Unit 2 > Module 3: Parliamentary System', style: TextStyle(fontSize: 12))),
                          ],
                        ),
                      ],
                    ),
                    // Action Buttons Wrap (wraps independently on constrained widths)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if (isEditing) ...[
                          OutlinedButton.icon(
                            onPressed: () {
                              widget.viewModel.cancelEditing();
                              setState(() {
                                _activeTab = 1; // Return to Visualizer
                              });
                            },
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: const Text('Cancel Edit', style: TextStyle(color: Colors.red)),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              widget.viewModel.refineLessonWithLlm();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                            icon: const Icon(Icons.smart_toy),
                            label: const Text('Refine with LLM'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await widget.viewModel.saveExistingLessonEdit();
                              setState(() {
                                _activeTab = 1; // Return to Visualizer
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Changes saved successfully into SQLite database!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            icon: const Icon(Icons.save),
                            label: const Text('Save Changes to DB'),
                          ),
                        ] else ...[
                          OutlinedButton(
                            onPressed: () {
                              widget.viewModel.rejectActiveDraft();
                              setState(() {
                                _activeTab = 2; // Return to list
                              });
                            },
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                            child: const Text('Reject & Discard', style: TextStyle(color: Colors.red)),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await widget.viewModel.approveActiveDraft(_selectedModuleId);
                              setState(() {
                                _activeTab = 0; // Return to dashboard stats
                              });
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            child: const Text('Approve & Commit to DB'),
                          )
                        ]
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
