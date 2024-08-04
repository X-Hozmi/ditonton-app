import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv_episode.dart';
import 'package:flutter/material.dart';

class EpisodeCardList extends StatelessWidget {
  final Episode episode;

  const EpisodeCardList({
    super.key,
    required this.episode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                    imageUrl: episode.stillPath != null
                        ? '$BASE_IMAGE_URL${episode.stillPath}'
                        : 'https://i.ibb.co/TWLKGMY/No-Image-Available.jpg',
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.black26,
                      child: const Center(
                        child: Text('Error Image'),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Episode ${episode.episodeNumber}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        episode.name,
                        style: kHeading6,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
            child: Text(
              episode.overview,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
