// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('text contrast guideline', () {
    testWidgets('black text on white background - Text Widget - direct style', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        const Text(
          'this is a test',
          style: TextStyle(fontSize: 14.0, color: Colors.black),
        ),
      ));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('white text on black background - Text Widget - direct style', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new Container(
          width: 200.0,
          height: 200.0,
          color: Colors.black,
          child: const Text(
            'this is a test',
            style: TextStyle(fontSize: 14.0, color: Colors.white),
          ),
        ),
      ));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('black text on white background - Text Widget - inherited style', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new DefaultTextStyle(
          style: const TextStyle(fontSize: 14.0, color: Colors.black),
          child: new Container(
            color: Colors.white,
            child: const Text('this is a test'),
          ),
        ),
      ));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('white text on black background - Text Widget - inherited style', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new DefaultTextStyle(
          style: const TextStyle(fontSize: 14.0, color: Colors.white),
          child: new Container(
            width: 200.0,
            height: 200.0,
            color: Colors.black,
            child: const Text('this is a test'),
          ),
        ),
      ));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('Material text field - amber on amber', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(new MaterialApp(
        home: new Scaffold(
          body: new Container(
            width: 200.0,
            height: 200.0,
            color: Colors.amberAccent,
            child: new TextField(
              style: const TextStyle(color: Colors.amber),
              controller: new TextEditingController(text: 'this is a test'),
            ),
          ),
        ),
      ));
      await expectLater(tester, doesNotMeetGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('Material text field - default style', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(new MaterialApp(
          home: new Scaffold(
            body: new Center(
              child: new TextField(
                controller: new TextEditingController(text: 'this is a test'),
              ),
            ),
          ),
        ),
      );
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('yellow text on yellow background fails with correct message', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new Container(
          width: 200.0,
          height: 200.0,
          color: Colors.yellow,
          child: const Text(
            'this is a test',
            style: TextStyle(fontSize: 14.0, color: Colors.yellowAccent),
          ),
        ),
      ));
      final Evaluation result = await textContrastGuideline.evaluate(tester);
      expect(result.passed, false);
      expect(result.reason,
        'SemanticsNode#21(Rect.fromLTRB(300.0, 200.0, 500.0, 400.0), label: "this is a test",'
        ' textDirection: ltr):\nExpected contrast ratio of at least '
        '4.5 but found 0.88 for a font size of 14.0. '
        'The computed foreground color was: Color(0xffffeb3b), '
        'The computed background color was: Color(0xffffff00)\n'
        'See also: https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html');
      handle.dispose();
    });

    testWidgets('label without corresponding text is skipped', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new Semantics(
          label: 'This is not text',
          container: true,
          child: new Container(
            width: 200.0,
            height: 200.0,
            child: const Placeholder(),
          ),
        ),
      ));

      final Evaluation result = await textContrastGuideline.evaluate(tester);
      expect(result.passed, true);
      handle.dispose();
    });

    testWidgets('offscreen text is skipped', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new Stack(
          children: <Widget>[
            new Positioned(
              left: -300.0,
              child: new Container(
                width: 200.0,
                height: 200.0,
                color: Colors.yellow,
                child: const Text(
                  'this is a test',
                  style: TextStyle(fontSize: 14.0, color: Colors.yellowAccent),
                ),
              ),
            )
          ],
        )
      ));

      final Evaluation result = await textContrastGuideline.evaluate(tester);
      expect(result.passed, true);
      handle.dispose();
    });
  });

  group('tap target size guideline', () {
    testWidgets('Tappable box at 48 by 48', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new SizedBox(
          width: 48.0,
          height: 48.0,
          child: new GestureDetector(
            onTap: () {},
          ),
        ),
      ));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('Tappable box at 47 by 48', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new SizedBox(
          width: 47.0,
          height: 48.0,
          child: new GestureDetector(
            onTap: () {},
          ),
        ),
      ));
      await expectLater(tester, doesNotMeetGuideline(androidTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('Tappable box at 48 by 47', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new SizedBox(
          width: 48.0,
          height: 47.0,
          child: new GestureDetector(
            onTap: () {},
          ),
        ),
      ));
      await expectLater(tester, doesNotMeetGuideline(androidTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('Tappable box at 48 by 48 shrunk by transform', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new Transform.scale(
          scale: 0.5, // should have new height of 24 by 24.
          child: new SizedBox(
            width: 48.0,
            height: 48.0,
            child: new GestureDetector(
              onTap: () {},
            ),
          ),
        ),
      ));
      await expectLater(tester, doesNotMeetGuideline(androidTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('Too small tap target fails with the correct message', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new SizedBox(
          width: 48.0,
          height: 47.0,
          child: new GestureDetector(
            onTap: () {},
          ),
        ),
      ));
      final Evaluation result = await androidTapTargetGuideline.evaluate(tester);
      expect(result.passed, false);
      expect(result.reason,
        'SemanticsNode#41(Rect.fromLTRB(376.0, 276.5, 424.0, 323.5), actions: [tap]): expected tap '
        'target size of at least Size(48.0, 48.0), but found Size(48.0, 47.0)\n'
        'See also: https://support.google.com/accessibility/android/answer/7101858?hl=en');
      handle.dispose();
    });

    testWidgets('Box that overlaps edge of window is skipped', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      final Widget smallBox = new SizedBox(
        width: 48.0,
        height: 47.0,
        child: new GestureDetector(
          onTap: () {},
        ),
      );
      await tester.pumpWidget(
        new MaterialApp(
          home: new Stack(
            children: <Widget>[
              new Positioned(
                left: 0.0,
                top: -1.0,
                child: smallBox,
              ),
            ],
          ),
        ),
      );

      final Evaluation overlappingTopResult = await androidTapTargetGuideline.evaluate(tester);
      expect(overlappingTopResult.passed, true);

      await tester.pumpWidget(
        new MaterialApp(
          home: new Stack(
            children: <Widget>[
              new Positioned(
                left: -1.0,
                top: 0.0,
                child: smallBox,
              ),
            ],
          ),
        ),
      );

      final Evaluation overlappingLeftResult = await androidTapTargetGuideline.evaluate(tester);
      expect(overlappingLeftResult.passed, true);

      await tester.pumpWidget(
        new MaterialApp(
          home: new Stack(
            children: <Widget>[
              new Positioned(
                bottom: -1.0,
                child: smallBox,
              ),
            ],
          ),
        ),
      );

      final Evaluation overlappingBottomResult = await androidTapTargetGuideline.evaluate(tester);
      expect(overlappingBottomResult.passed, true);

      await tester.pumpWidget(
        new MaterialApp(
          home: new Stack(
            children: <Widget>[
              new Positioned(
                right: -1.0,
                child: smallBox,
              ),
            ],
          ),
        ),
      );

      final Evaluation overlappingRightResult = await androidTapTargetGuideline.evaluate(tester);
      expect(overlappingRightResult.passed, true);
      handle.dispose();
    });

    testWidgets('Does not fail on mergedIntoParent child', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_boilerplate(
        new MergeSemantics(
          child: new Semantics(
            container: true,
            child: new SizedBox(
              width: 50.0,
              height: 50.0,
              child: new Semantics(
                container: true,
                child: new GestureDetector(
                  onTap: () {},
                  child: const SizedBox(width: 4.0, height: 4.0),
                )
              )
            ),
          )
        )
      ));

      final Evaluation overlappingRightResult = await androidTapTargetGuideline.evaluate(tester);
      expect(overlappingRightResult.passed, true);
      handle.dispose();
    });
  });
}

Widget _boilerplate(Widget child) {
  return new MaterialApp(
    home: new Scaffold(body: new Center(child: child)),
  );
}
