/// Anki-compatible `{{Field}}` template renderer: resolves a note's field
/// values against a card template's front/back/css, including conditional
/// `{{#Field}}...{{/Field}}` sections and cloze reveal state.
///
/// The renderer lands in milestone M5 of the implementation plan.
library;
