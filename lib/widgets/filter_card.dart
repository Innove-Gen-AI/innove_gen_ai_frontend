import 'package:flutter/material.dart';
import 'package:innove_gen_ai_frontend/views/product_review_summary_view.dart';
import 'package:provider/provider.dart';

import '../models/filter_info.dart';
import '../util/decoration_util.dart';

class MyFilterCard extends StatefulWidget {
  const MyFilterCard({Key? key}) : super(key: key);

  @override
  _MyFilterCardState createState() => _MyFilterCardState();
}

class _MyFilterCardState extends State<MyFilterCard> with DecorationUtil {

  late Set<FilterOptions> filters = <FilterOptions>{};

  void updateFilterProvider(){
    Provider.of<FilterInfo>(context, listen: false).updateFilters(filters.toList());
  }

  @override
  void initState() {
    super.initState();

    final List<FilterOptions> fInfo = Provider.of<FilterInfo>(context, listen: false).getFilterOptions;
    filters = fInfo.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade100,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // filter by most recent button
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: FilterOptions.values.asMap().entries.map((option) {
                    return FilterChip(
                      showCheckmark: false,
                      label: Text(option.value.name),
                      selected: filters.contains(option.value),
                      labelStyle: TextStyle(
                          color: filters.contains(option.value)
                              ? Colors.white
                              : Colors.lightBlue),
                      selectedColor: Colors.lightBlue,
                      backgroundColor: Colors.lightBlue.shade100,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            filters.add(option.value);
                          } else {
                            filters.remove(option.value);
                          }
                        });
                      },
                    );
                }).toList(),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel',
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue)),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      print('Closing filters card pop up');
                      print('Applying filters - $filters');
                      updateFilterProvider();
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => withScreenDecoration(const ProductSummary()),
                        ),
                      );
                    },
                    child: Text('Apply',
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }
}
