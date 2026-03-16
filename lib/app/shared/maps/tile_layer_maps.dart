import 'package:flutter/material.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

import '../../core/constant/variables.dart';
import 'package:flutter_map/flutter_map.dart';

class TileLayerMaps {
  TileLayer sharedTile() {
    return TileLayer(
      urlTemplate: Variables.baseUrlMaps,
      additionalOptions: {"api_key": Variables.apiKeyMaps},

      maxZoom: 20,
      maxNativeZoom: 20,

      keepBuffer: 2,
      panBuffer: 1,

      retinaMode: false,

      userAgentPackageName: 'dev.fleaflet.flutter_map.example',

      tileProvider: FMTCTileProvider(
        stores: const {'mapStore': BrowseStoreStrategy.readUpdateCreate},
      ),

      // subdomains: ['a', 'b', 'c'],

      errorImage: AssetImage('assets/images/ic_empty_box.png'),
      errorTileCallback: (tile, error, stackTrace) {
        debugPrint('Error Map: $error');
        // mapError = true;
        // debugPrint('Error Map: $mapError');
      },
    );
    // Plenty of other options available!
    // return TileLayer(
    //   urlTemplate: Variables.baseUrlMaps,
    //   userAgentPackageName: 'com.ags.lancar_cat',
    //   maxZoom: 16,
    //   // urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
    //   subdomains: ['a', 'b', 'c', 'd'],
    //   tileProvider: FMTCTileProvider(
    //     stores: const {'mapStore': BrowseStoreStrategy.readUpdateCreate},
    //   ),
    //   // FMTCStore('mapStore').getTileProvider(),
    //   // NetworkTileProvider(
    //   //   headers: {
    //   //     'User-Agent': 'FlutterMapApp/1.0 (com.ags.lancar_cat)',
    //   //     'Accept': '*/*',
    //   //   },
    //   // ),
    //   // Plenty of other options available!
    // );
  }
}
