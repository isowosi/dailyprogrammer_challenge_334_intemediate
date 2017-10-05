import 'dart:async';
import 'dart:math';
import 'dart:html';

final CanvasElement canvas = querySelector('canvas');
List<Timer> timer = [];
int sizeMulti;

void main() {
  final ButtonElement button = querySelector('button');
  button.onClick.listen((_) {
    timer
      ..forEach((t) => t.cancel())
      ..clear();
    sizeMulti = 1;
    final input = (querySelector('textarea') as TextAreaElement).value;
    final cells = input
        .trim()
        .split('\n')
        .map((row) => row
            .split(' ')
            .where((s) => s != '')
            .map((s) => int.parse(s))
            .toList())
        .toList();
    final iterations = cells[0][1];
    var size = pow(3, iterations);
    while (size * sizeMulti < 800) {
      sizeMulti *= 2;
    }
    canvas
      ..width = sizeMulti * size
      ..height = sizeMulti * size
      ..style.width = '${sizeMulti * size}px'
      ..style.height = '${sizeMulti * size}px'
      ..context2D.imageSmoothingEnabled = false;
    renderPixel(cells, 0, iterations, 0, 0, 0);
  });
}

renderPixel(List<List<int>> cells, int color, int maxIterations,
    int currentIteration, int posX, int posY) {
  if (currentIteration > maxIterations) return;
  final size = sizeMulti * pow(3, maxIterations - currentIteration);
  canvas.context2D
    ..fillStyle = 'hsl(0, 0%, ${color * 100.0 / (cells[0][0]-1)}%)'
    ..fillRect(posX * size, posY * size, size, size);
  timer.add(new Timer(const Duration(seconds: 1), () {
    for (int x = 0; x < 3; x++) {
      for (int y = 0; y < 3; y++) {
        renderPixel(cells, cells[1 + color][y * 3 + x], maxIterations,
            currentIteration + 1, posX * 3 + x, posY * 3 + y);
      }
    }
  }));
}
