import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/Community/controller/community_controller.dart';
import 'package:sosoulize/Resposive/responsive.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/commons/loader.dart';
import 'package:sosoulize/core/constants/error_text.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;

  SearchCommunityDelegate({required this.ref})
      : super(
          searchFieldLabel: 'Search for communities...',
          searchFieldStyle: const TextStyle(
            fontFamily: 'carter',
            fontSize: 16,        
            fontWeight: FontWeight.w400,
            color: Colors.grey,  
          ),
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(
          Icons.search,
          size: 32,
          color: theme == ThemeMode.dark
              ? Pallete.appColorDark
              : Pallete.appColorLight,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        size: 30,
        color: theme == ThemeMode.dark
            ? Pallete.appColorDark
            : Pallete.appColorLight,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;

    return ref.watch(searchCommunityProvider(query)).when(
          data: (communities) {
            return Center(
              child: Responsive(
                child: ListView.builder(
                  itemCount: communities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final community = communities[index];
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme == ThemeMode.dark
                                ? Pallete.appColorDark
                                : Pallete.appColorLight,
                            width: 2,
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(community.avatar),
                          ),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'r/${community.name}',
                            style: const TextStyle(
                              fontFamily: 'carter',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${community.members.length} members',
                            style: const TextStyle(
                              fontFamily: 'carter',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => navigateToCommunity(context, community.name),
                    );
                  },
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName');
  }
}
