import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharly_app_light/models/activity_index.dart';
import 'package:sharly_app_light/services/api/api_helper.dart';

import '../utilities/string_res.dart';
import '../widgets/statistics.dart';

/// A screen showing the details of the given [ActivityIndex] as well as some
/// statistics about the activity.
class ActivityIndexScreen extends StatefulWidget {
  const ActivityIndexScreen({Key? key, this.index}) : super(key: key);

  /// The [ActivityIndex] which should be detailed.
  final ActivityIndex? index;

  static const routeName = "activityIndex";

  @override
  State<ActivityIndexScreen> createState() => _ActivityIndexScreenState();
}

class _ActivityIndexScreenState extends State<ActivityIndexScreen> {
  late final Future<ActivityIndex> _future = widget.index != null
      ? Future.value(widget.index!)
      : context.read<APIHelper>().getLatestActivityIndex();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final index = snapshot.requireData;
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
              children: [
                Text(
                  s(context).activityIndexMessageTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 30,
                ),
                SectionTitle(s(context).activityIndexRating),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      index.emoji,
                      textScaleFactor: 3,
                    ),
                    Text("(${index.title})")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                SectionTitle(s(context).activityIndexStatistics),
                const Statistics()
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                s(context).activityIndexError(snapshot.error.toString()),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        // textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

/// A statistic shown in the activity index screen. WIP
class Statistic extends StatelessWidget {
  const Statistic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        height: 300,
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
        // child: SizedBox(height: 100),
      ),
    );
  }
}
