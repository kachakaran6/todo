import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'tags_dao.g.dart';

/// Data Access Object for Tag operations.
@DriftAccessor(tables: [Tags, TaskTags])
class TagsDao extends DatabaseAccessor<AppDatabase> with _$TagsDaoMixin {
  TagsDao(super.db);

  /// Watch all tags ordered alphabetically.
  Stream<List<Tag>> watchTags() {
    return (select(tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }

  /// Get all tags (one-shot).
  Future<List<Tag>> getTags() {
    return (select(tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  /// Insert a tag.
  Future<void> insertTag(TagsCompanion tag) async {
    await into(tags).insert(tag);
  }

  /// Update a tag.
  Future<void> updateTag(TagsCompanion tag) async {
    await (update(tags)..where((t) => t.id.equals(tag.id.value))).write(tag);
  }

  /// Delete a tag (also removes task_tag associations).
  Future<void> deleteTag(String id) async {
    await transaction(() async {
      await (delete(taskTags)..where((tt) => tt.tagId.equals(id))).go();
      await (delete(tags)..where((t) => t.id.equals(id))).go();
    });
  }

  /// Get tags for a specific task.
  Future<List<Tag>> getTagsForTask(String taskId) async {
    final tagIds = await (select(taskTags)
          ..where((tt) => tt.taskId.equals(taskId)))
        .map((r) => r.tagId)
        .get();

    if (tagIds.isEmpty) return [];

    return (select(tags)..where((t) => t.id.isIn(tagIds))).get();
  }
}
