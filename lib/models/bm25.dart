import 'dart:math';

class BM25 {
  final List<List<String>> documents;
  final double k1;
  final double b;
  final Map<String, double> idf = {};
  final List<Map<String, int>> termFrequencies = [];
  final Map<String, int> docLengths = {};
  double avgDocLength = 0.0;

  BM25(this.documents, {this.k1 = 1.5, this.b = 0.75}) {
    _initialize();
  }

  void _initialize() {
    final docCount = documents.length;
    final Map<String, int> docFreqs = {};
    var totalLength = 0;

    for (var docIndex = 0; docIndex < docCount; docIndex++) {
      final doc = documents[docIndex];
      final Map<String, int> termFreqs = {};
      docLengths[docIndex.toString()] = doc.length;
      totalLength += doc.length;

      for (var term in doc) {
        termFreqs[term] = (termFreqs[term] ?? 0) + 1;
        if (termFreqs[term] == 1) {
          docFreqs[term] = (docFreqs[term] ?? 0) + 1;
        }
      }
      termFrequencies.add(termFreqs);
    }

    avgDocLength = totalLength / docCount;
    docFreqs.forEach((term, docFreq) {
      idf[term] = _idf(docFreq, docCount);
    });
  }

  double _idf(int docFreq, int docCount) {
    return (log((docCount - docFreq + 0.5) / (docFreq + 0.5)) / ln2) + 1;
  }

  double score(List<String> query, int docIndex) {
    final docLength = docLengths[docIndex.toString()]!;
    final termFreqs = termFrequencies[docIndex];
    double score = 0.0;

    for (var term in query) {
      if (!termFreqs.containsKey(term)) continue;
      final freq = termFreqs[term]!;
      final idfScore = idf[term]!;
      final tf = (freq * (k1 + 1)) / (freq + k1 * (1 - b + b * (docLength / avgDocLength)));
      score += idfScore * tf;
    }

    return score;
  }

  List<Map<String, dynamic>> search(List<String> query) {
    final scores = <Map<String, dynamic>>[];

    for (var docIndex = 0; docIndex < documents.length; docIndex++) {
      final score = this.score(query, docIndex);
      scores.add({'docIndex': docIndex, 'score': score});
    }

    scores.sort((a, b) => b['score'].compareTo(a['score']));
    return scores;
  }
}

extension Log2 on num {
  double log2() => (this > 0) ? (log(this) / ln2) : 0;
}
