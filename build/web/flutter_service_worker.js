'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "9ea93b7545f61d59326479c1a192d6d6",
"index.html": "464fadd6a16a595d2b165441088915be",
"/": "464fadd6a16a595d2b165441088915be",
"main.dart.js": "b36668b9b3121dc994205f303f246782",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "46284fc7b2401323716775f8c4d45b25",
"assets/AssetManifest.json": "8ea213c77687fda2bcb8e3644637e2a3",
"assets/NOTICES": "2fc8120881258aa669028ca4f8e9d863",
"assets/FontManifest.json": "7e8f46373e8ad3a571afa115589b9d70",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/youtube_player_iframe/assets/player.html": "dc7a0426386dc6fd0e4187079900aea8",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "9cda082bd7cc5642096b56fa8db15b45",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "0a94bab8e306520dc6ae14c2573972ad",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b00363533ebe0bfdb95f3694d7647f6d",
"assets/packages/youtube_player_flutter/assets/speedometer.webp": "50448630e948b5b3998ae5a5d112622b",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/assets/video/videoDark.mp4": "b4d42127fb5d9ee99eabdf67c3ced873",
"assets/assets/video/videoLight.mp4": "6729c99dbb1bfc1c13778e50d745b30d",
"assets/assets/config/main.json": "650f96ab369975a577b6315943dd0f72",
"assets/assets/images/desktopbg.png": "cf73ec88fab7bd931340a7618dab038c",
"assets/assets/images/lightLogin.jpg": "4d86b5b929d436b26e0b61c29f6c10a9",
"assets/assets/images/desktopLogin.png": "3bdf63116b42a0d826a034f5e9892604",
"assets/assets/images/onboardImage.jpg": "f2acaeedec2977c58ce5dcc66ba947cd",
"assets/assets/images/background.png": "d1ca12e1ba6f8046567ffd58d951efb8",
"assets/assets/images/movies/movie2.jpg": "fe81c0fd5e02426b9332e0fd89dd2334",
"assets/assets/images/movies/movie3.jpg": "37ee300603651483d51c63cc2d7dc547",
"assets/assets/images/movies/movie1.jpg": "5bda1d88c01faaf9a356a66dcf863cb8",
"assets/assets/images/movies/movies10.jpeg": "5ac79cc6de09c52a2da684a2ade8fdb0",
"assets/assets/images/movies/movie6.jpeg": "c7b4b2606d92da934aff90607d519090",
"assets/assets/images/movies/movies9.jpeg": "70dc7bc693a78a80cec0b322d50252fa",
"assets/assets/images/movies/movies8.jpeg": "24c3f99a4592eb1abe22ecc1593dcb08",
"assets/assets/images/movies/movie4.jpg": "67900dd349d5336771b829fa17e67c49",
"assets/assets/images/movies/movies11.jpeg": "aa81b8915a292720fef2c6fdb945afb2",
"assets/assets/images/movies/movies14.jpeg": "5f4b7b779549a6b23b29aee42aa7e527",
"assets/assets/images/movies/movies15.jpeg": "155704110303efb86bfcce1a7efe7bc0",
"assets/assets/images/movies/movies7.jpeg": "f090b954dcaf50dcfe559d766ed8c153",
"assets/assets/images/movies/movies12.jpeg": "6590e1d8942635f3227c3ca4a4c6b1cf",
"assets/assets/images/movies/movie16.jpeg": "5bada8b9d7af567ffc8b78eefbe26717",
"assets/assets/images/movies/movies13.jpeg": "a184a1e37d1b397c3353a3266afc04ab",
"assets/assets/images/movies/movie5.jpeg": "5b9a9597989145f3c20098dc31ee2032",
"assets/assets/icons/cineLogoLight.png": "403f4b7f5068511a3dae0cd7ef11be21",
"assets/assets/icons/logoLight.png": "1518840f55f95fad800f579c66c881d3",
"assets/assets/icons/googleLogo.png": "781fc4aa328b113f490a0ae3a979e070",
"assets/assets/icons/cineLogoDark.png": "24f3282b508c9d5310b9f99fcf3c2600",
"assets/assets/icons/logo.png": "b2593dcb374ffbf588ba119b719c357e",
"assets/assets/icons/youtube_social_icon_red.png": "fe8ee891f21a0d64514a292b20be6c76",
"assets/assets/icons/youtube.png": "67b8b90257d168753be2f612f0780a9c",
"assets/assets/icons/logoDark.png": "29003927a61718fcff6506eb9513c71a",
"assets/assets/fonts/DMSans-Regular.ttf": "7c217bc9433889f55c38ca9d058514d3",
"assets/assets/fonts/Baskervville-Regular.ttf": "507221dfc4c53afa0dfc1b25b8a3923b",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
