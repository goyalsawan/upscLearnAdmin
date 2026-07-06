import 'package:markdown/markdown.dart' as md;

class MarkdownCardParser {
  MarkdownCardParser._();

  /// Parses a markdown string into lesson card segments based on H1 and H2 headers.
  static List<Map<String, String>> parseMarkdownToCards(String markdown, String defaultTitle) {
    if (markdown.trim().isEmpty) return [];

    final document = md.Document();
    final nodes = document.parseLines(markdown.split('\n'));

    final List<Map<String, String>> cards = [];
    String currentHeading = defaultTitle;
    final StringBuffer currentBody = StringBuffer();

    for (final node in nodes) {
      if (node is md.Element) {
        if (node.tag == 'h1' || node.tag == 'h2') {
          // If there is accumulated body content, push it to cards
          if (currentBody.toString().trim().isNotEmpty) {
            cards.add({
              'heading': currentHeading,
              'body': currentBody.toString().trim(),
            });
          }
          currentHeading = _extractText(node).trim();
          currentBody.clear();
        } else {
          currentBody.writeln(_renderNodeToMarkdown(node));
        }
      } else if (node is md.Text) {
        currentBody.writeln(node.text);
      }
    }

    if (currentBody.toString().trim().isNotEmpty || cards.isEmpty) {
      cards.add({
        'heading': currentHeading,
        'body': currentBody.toString().trim(),
      });
    }

    return cards;
  }

  static String _extractText(md.Node node) {
    if (node is md.Text) return node.text;
    if (node is md.Element) {
      if (node.children == null) return '';
      return node.children!.map(_extractText).join('');
    }
    return '';
  }

  static String _renderNodeToMarkdown(md.Node node) {
    if (node is md.Text) return node.text;
    if (node is md.Element) {
      final childrenText = node.children?.map(_renderNodeToMarkdown).join('') ?? '';
      switch (node.tag) {
        case 'p':
          return '$childrenText\n';
        case 'li':
          return '* $childrenText';
        case 'ul':
          return childrenText;
        case 'ol':
          return childrenText;
        case 'em':
          return '*$childrenText*';
        case 'strong':
          return '**$childrenText**';
        case 'blockquote':
          return '> $childrenText\n';
        case 'pre':
          return '```\n$childrenText\n```\n';
        case 'code':
          return '`$childrenText`';
        case 'h3':
          return '### $childrenText\n';
        case 'h4':
          return '#### $childrenText\n';
        default:
          return childrenText;
      }
    }
    return '';
  }
}
