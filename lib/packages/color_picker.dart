import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spring_button/spring_button.dart';

import 'constants.dart';

final Map<int, double> _correctSizes = {};
final PageController pageController = PageController(keepPage: true);

class FastColorPicker extends StatelessWidget {
  final Color selectedColor;
  final IconData? icon;
  final Function(Color) onColorSelected;

  const FastColorPicker({
    Key? key,
    this.icon,
    this.selectedColor = Colors.white,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: SelectedColor(
                  icon: icon,
                  selectedColor: selectedColor,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: PageView(
                    controller: pageController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: createColors(context, Constants.colors1),
                      ),
                      Row(
                        children: createColors(context, Constants.colors2),
                      ),
                      Row(
                        children: createColors(context, Constants.colors3),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SmoothPageIndicator(
            controller: pageController, // PageController
            count: 3,
            effect: const ScrollingDotsEffect(
              spacing: 8,
              activeDotColor: Color.fromARGB(255, 24, 10, 183),
              dotColor: Color.fromARGB(42, 24, 10, 183),
              dotHeight: 8,
              dotWidth: 8,
              activeDotScale: 1,
            ),
          ),
          const SizedBox(height: 6)
        ],
      ),
    );
  }

  List<Widget> createColors(BuildContext context, List<Color> colors) {
    return [
      for (var c in colors)
        Flexible(
          flex: 1,
          child: SpringButton(
            SpringButtonType.OnlyScale,
            Padding(
              padding: EdgeInsets.all(4),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: c == selectedColor ? 4 : 2,
                    color: Colors.white,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              onColorSelected.call(c);
            },
            useCache: false,
            scaleCoefficient: 0.9,
            duration: 1000,
          ),
        ),
    ];
  }
}

class SelectedColor extends StatelessWidget {
  final Color selectedColor;
  final IconData? icon;

  const SelectedColor({Key? key, required this.selectedColor, this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      child: icon != null
          ? Icon(
              icon,
              color: selectedColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              size: 22,
            )
          : null,
      decoration: BoxDecoration(
        color: selectedColor,
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: Colors.white,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black38,
          ),
        ],
      ),
    );
  }
}
