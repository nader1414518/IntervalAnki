/// Anki-compatible `{{Field}}` template renderer: resolves a note's field
/// values against a card template's front/back/css, including conditional
/// `{{#Field}}...{{/Field}}` sections and cloze reveal state.
library;

export 'src/template_renderer.dart';
