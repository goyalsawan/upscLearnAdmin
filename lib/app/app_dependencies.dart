import '../data/models.dart';
import '../data/repositories/content_repository.dart';
import '../ui/view_models/admin_view_model.dart';

/// Container that holds all core dependencies and initial loaded state
/// required to build and render the UPSC Admin Dashboard application.
class AppDependencies {
  final ContentRepository contentRepository;
  final AdminViewModel adminViewModel;
  final List<Subject> subjects;

  const AppDependencies({
    required this.contentRepository,
    required this.adminViewModel,
    required this.subjects,
  });
}
