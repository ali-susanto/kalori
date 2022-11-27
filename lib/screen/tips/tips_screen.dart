import 'package:flutter/material.dart';
import 'package:kalori/screen/tips/tips_view_model.dart';

import 'package:provider/provider.dart';


import '../../components/large_content_shimmer.dart';
import '../../components/small_content_shimmer.dart';
import '../../constants.dart';
import '../../enums.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({Key? key}) : super(key: key);

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Provider.of<TipsViewModel>(context, listen: false).getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final viewModel = Provider.of<TipsViewModel>(context);
    return Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Tips Hidup Sehat',
            style: TextStyle(color: kBlackColor),
          ),
          centerTitle: true,
          backgroundColor: kWhiteColor,
          elevation: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 13),
            child: Consumer<TipsViewModel>(builder: (context, state, child) {
              if (state.stateType == DataState.loading) {
                return Column(
                  children: [
                    LargeContentShimmer(size: size),
                    const SizedBox(height: 32),
                    Expanded(
                        child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return SmallContentShimmer(size: size);
                      },
                    ))
                  ],
                );
              }
              if (state.stateType == DataState.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            Provider.of<TipsViewModel>(context, listen: false)
                                .getData();
                          },
                          icon: const Icon(
                            Icons.error_outline_outlined,
                            size: 50,
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(viewModel.errorMessage),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(
                          2,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: InkWell(
                                onTap: () {},
                                child: Container(
                                  width: size.width * 0.82,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey, width: 2)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: size.height * 0.2,
                                          width: size.width,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                            child: Image.network(
                                              viewModel.tipsData[index].image!,
                                              fit: BoxFit.fill,
                                            ),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          viewModel.tipsData[index].title!,
                                          maxLines: 2,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(width: 2, color: Colors.grey)),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: size.width * 0.4,
                                      height: size.height * 0.12,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        child: Image.network(
                                          viewModel.tipsData[index].image!,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: SizedBox(
                                      width: size.width * 0.48,
                                      child: Text(
                                        viewModel.tipsData[index].title!,
                                        maxLines: 4,
                                        textAlign: TextAlign.justify,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            })));
  }
}
