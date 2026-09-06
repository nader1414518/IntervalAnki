import 'package:card_template/card_template.dart';
import 'package:test/test.dart';

void main() {
  const renderer = CardTemplateRenderer();

  group('basic field substitution', () {
    test('substitutes a simple field', () {
      final result = renderer.renderFront('{{Front}}', {'Front': 'Hola'});
      expect(result, equals('Hola'));
    });

    test('renders an unknown field as empty', () {
      final result = renderer.renderFront('{{Missing}}', {'Front': 'Hola'});
      expect(result, equals(''));
    });

    test('FrontSide on the back template is the rendered front', () {
      final result = renderer.renderBack('{{FrontSide}}<hr>{{Back}}', {
        'Front': 'Hola',
        'Back': 'Hello',
      }, 'Hola');
      expect(result, equals('Hola<hr>Hello'));
    });
  });

  group('conditional sections', () {
    test('{{#Field}} shows its content when the field is non-empty', () {
      final result = renderer.renderFront('{{#Extra}}shown{{/Extra}}', {
        'Extra': 'x',
      });
      expect(result, equals('shown'));
    });

    test('{{#Field}} hides its content when the field is empty', () {
      final result = renderer.renderFront('{{#Extra}}shown{{/Extra}}', {
        'Extra': '',
      });
      expect(result, equals(''));
    });

    test('{{^Field}} shows its content only when the field is empty', () {
      final shown = renderer.renderFront('{{^Extra}}fallback{{/Extra}}', {
        'Extra': '',
      });
      final hidden = renderer.renderFront('{{^Extra}}fallback{{/Extra}}', {
        'Extra': 'x',
      });
      expect(shown, equals('fallback'));
      expect(hidden, equals(''));
    });
  });

  group('cloze rendering', () {
    const text = 'The capital of {{c1::France}} is {{c2::Paris}}.';

    test('front hides the active deletion, reveals the others', () {
      final result = renderer.renderFront('{{cloze:Text}}', {
        'Text': text,
      }, clozeOrd: 1);
      expect(
        result,
        equals('The capital of <span class="cloze">[...]</span> is Paris.'),
      );
    });

    test('front uses the hint text when one is given', () {
      const withHint = 'The capital of {{c1::France::country}} is Paris.';
      final result = renderer.renderFront('{{cloze:Text}}', {
        'Text': withHint,
      }, clozeOrd: 1);
      expect(result, contains('[country]'));
    });

    test('back reveals the active deletion, highlighted', () {
      final result = renderer.renderBack(
        '{{cloze:Text}}',
        {'Text': text},
        '',
        clozeOrd: 1,
      );
      expect(
        result,
        equals('The capital of <span class="cloze">France</span> is Paris.'),
      );
    });

    test('a different card ord hides its own deletion instead', () {
      final result = renderer.renderFront('{{cloze:Text}}', {
        'Text': text,
      }, clozeOrd: 2);
      expect(
        result,
        equals('The capital of France is <span class="cloze">[...]</span>.'),
      );
    });
  });
}
