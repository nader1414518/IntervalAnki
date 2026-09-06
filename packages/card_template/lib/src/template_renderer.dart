final _fieldTag = RegExp(r'\{\{([^{}#^/]+?)\}\}');
final _sectionTag = RegExp(
  r'\{\{([#^])([^{}]+?)\}\}(.*?)\{\{/\2\}\}',
  dotAll: true,
);
final _clozeDeletion = RegExp(
  r'\{\{c(\d+)::(.*?)(?:::(.*?))?\}\}',
  dotAll: true,
);

/// Resolves an Anki-style card template (`{{Field}}`, `{{#Field}}...
/// {{/Field}}`, `{{cloze:Field}}`, `{{FrontSide}}`) against a note's field
/// values.
///
/// `{{type:Field}}` (Anki's type-in-answer marker) is rendered as the plain
/// field value — checking a typed answer against it is a study-session
/// concern, not a template-rendering one, and isn't implemented in this
/// pass.
class CardTemplateRenderer {
  /// Creates a renderer.
  const CardTemplateRenderer();

  /// Renders a front template. [clozeOrd] (1-based) is required only for
  /// Cloze note types, to know which deletion this card is testing.
  String renderFront(
    String template,
    Map<String, String> fields, {
    int? clozeOrd,
  }) {
    return _render(template, fields, isFront: true, clozeOrd: clozeOrd);
  }

  /// Renders a back template. [renderedFront] fills in `{{FrontSide}}`.
  String renderBack(
    String template,
    Map<String, String> fields,
    String renderedFront, {
    int? clozeOrd,
  }) {
    return _render(
      template,
      fields,
      isFront: false,
      clozeOrd: clozeOrd,
      frontSide: renderedFront,
    );
  }

  String _render(
    String template,
    Map<String, String> fields, {
    required bool isFront,
    int? clozeOrd,
    String frontSide = '',
  }) {
    final withSections = _resolveSections(template, fields);
    return withSections.replaceAllMapped(_fieldTag, (match) {
      final rawName = match.group(1)!.trim();

      if (rawName == 'FrontSide') return frontSide;

      if (rawName.startsWith('cloze:')) {
        final fieldName = rawName.substring('cloze:'.length);
        return _renderCloze(fields[fieldName] ?? '', clozeOrd, isFront);
      }

      if (rawName.startsWith('type:')) {
        final fieldName = rawName.substring('type:'.length);
        return fields[fieldName] ?? '';
      }

      return fields[rawName] ?? '';
    });
  }

  /// Resolves `{{#Field}}...{{/Field}}` (shown if non-empty) and
  /// `{{^Field}}...{{/Field}}` (shown if empty) sections, before plain
  /// `{{Field}}` substitution runs.
  String _resolveSections(String template, Map<String, String> fields) {
    var result = template;
    while (_sectionTag.hasMatch(result)) {
      result = result.replaceAllMapped(_sectionTag, (match) {
        final modifier = match.group(1)!;
        final name = match.group(2)!.trim();
        final inner = match.group(3)!;
        final value = fields[name] ?? '';
        final show = modifier == '#' ? value.isNotEmpty : value.isEmpty;
        return show ? inner : '';
      });
    }
    return result;
  }

  String _renderCloze(String fieldValue, int? activeOrd, bool isFront) {
    return fieldValue.replaceAllMapped(_clozeDeletion, (match) {
      final ord = int.parse(match.group(1)!);
      final text = match.group(2)!;
      final hint = match.group(3);
      final isActive = ord == activeOrd;

      if (isFront && isActive) {
        return '<span class="cloze">[${hint ?? '...'}]</span>';
      }
      if (isActive) {
        return '<span class="cloze">$text</span>';
      }
      return text;
    });
  }
}
