import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class DailyPages extends StatefulWidget {
  const DailyPages({super.key});

  @override
  State<DailyPages> createState() => _DailyPagesState();
}

class _DailyPagesState extends State<DailyPages> {
  final List<Widget> dayCards = [const TaskContainer()];
  final CardSwiperController _swiperController = CardSwiperController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Text(
            "Learnings",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.navigate_before_outlined,
              size: 50,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.navigate_next_outlined,
                size: 50,
                color: Colors.black,
              ),
            )
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade600,
                  Colors.blue.shade400,
                  Colors.blue.shade300,
                  Colors.blue.shade100,
                  Colors.blue.shade50,
                  Colors.white70,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                transform: GradientRotation(math.pi / 3),
              ),
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: Divider(height: 4.0, color: Colors.black12),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: CardSwiper(
                controller: _swiperController,
                cardsCount: dayCards.length,
                numberOfCardsDisplayed: 1,
                isLoop: false,
                onSwipe: (prevIndex, currentIndex, direction) {
                  setState(() {
                    _currentIndex = currentIndex ?? _currentIndex;
                  });
                  return true;
                },
                cardBuilder: (context, index, horizontalOffset, verticalOffset) {
                  return dayCards[index];
                },
              ),
            ),

            // Next & Previous Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _currentIndex > 0
                        ? () => _swiperController.swipe(CardSwiperDirection.left)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Previous"),
                  ),
                  ElevatedButton.icon(
                    onPressed: _currentIndex < dayCards.length - 1
                        ? () => _swiperController.swipe(CardSwiperDirection.right)
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Next"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskContainer extends StatefulWidget {
  const TaskContainer({super.key});

  @override
  State<TaskContainer> createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  final String today = DateFormat('dd MMM yy').format(DateTime.now());
  bool wokeUpEarly = false;
  bool learnedDsa = false;
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isProductive = wokeUpEarly && learnedDsa;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isProductive
            ? const Color.fromRGBO(131, 234, 255, 1.0)
            : const Color.fromRGBO(222, 241, 255, 1.0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.black12),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "📅 $today",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const Divider(thickness: 1, height: 30),
            CheckboxListTile(
              value: wokeUpEarly,
              activeColor: Colors.green,
              checkColor: Colors.white,
              onChanged: (val) => setState(() => wokeUpEarly = val!),
              title: const Text(
                "Woke up early",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              value: learnedDsa,
              activeColor: Colors.green,
              checkColor: Colors.white,
              onChanged: (val) => setState(() => learnedDsa = val!),
              title: const Text(
                "Learned DSA today",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 10),
            const Text(
              "📝 Notes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: noteController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration.collapsed(
                  hintText: "Write your thoughts, achievements, or ideas...",
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (isProductive)
              Center(
                child: Text(
                  "✅ Awesome! You're productive today!",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
