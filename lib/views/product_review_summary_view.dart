import 'package:flutter/material.dart';

class ProductSummary extends StatelessWidget {
  const ProductSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24)),
                margin: const EdgeInsets.all(18),
                padding: const EdgeInsets.all(24),
                height: 700,
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product name',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Overall sentiment',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 18),
                    //replace with scrollable widget containing longer text
                    Text(
                      'Overal review sumamry',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.blue[400],
                child: const Icon(
                  Icons.tune,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
