import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:innove_gen_ai_frontend/views/product_review_summary_view.dart';
import 'package:provider/provider.dart';

import '../models/filter_info.dart';
import '../util/decoration_util.dart';
import 'package:url_launcher/url_launcher.dart';

class MyFilterCard extends StatefulWidget {
  const MyFilterCard({Key? key, required this.buy, this.search}) : super(key: key);
  final bool buy;
  final String? search;

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

  double padding() {

    double defaultMargin = 0;
    double defaultWidth = 550;
    double width = MediaQuery.of(context).size.width;

    double paddingToUse() {
      if (kIsWeb) {
        if(width <= defaultWidth){
          return defaultMargin;
        } else {
          double paddingToUse = (width - defaultWidth) / 4;
          if(paddingToUse > 100){
            return 100;
          } else {
            return paddingToUse;
          }
        }
      } else {
        return defaultMargin;
      }
    }

    double paddingToReturn = paddingToUse();
    print("padding to apply = $paddingToReturn");
    return paddingToReturn;
  }


  void _launchURL() async {

    final Uri uri = Uri.parse('https://www.google.com/search?q=${widget.search}&tbm=shop');

    print("clicked link - $uri");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Widget makeCard(){
    if(widget.buy){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.shopping_cart_outlined),
            title: Text('Buy Now'),
            onTap: _launchURL,
          ),
        ],
      );

    } else {
      return Column(
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding()),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100,
          borderRadius: BorderRadius.circular(20)
        ),
        child: makeCard(),
      ),
    );
  }
}
