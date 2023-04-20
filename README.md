# Cinema Hub

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Description

The CinemaHub is a user-friendly mobile application and website that allows you to browse through an extensive collection of movies and access a wide range of information, from release dates and cast members to trailers, teasers, and more. It's built using the Flutter framework and the TMDB API.

## Table of Contents

* [Installation](#installation)
* [Usage](#usage)
* [API Reference](#api-reference)
* [Contributing](#contributing)
* [License](#license)
* [Credits](#credits)
* [Contact](#contact)

## Features
* Browse through an extensive collection of movies
* Search for movies by title or genre
* Access detailed movie information, including release dates and cast members
* Watch trailers, teasers, and more
* Explore popular movie lists curated by our team of experts

## Installation

1. Clone the repository onto your local machine:
   ```
   git clone https://github.com/your-username/cinemahub.git
   ```
2. Open the project in your preferred code editor.
3. Run the command `flutter pub get` to download the necessary dependencies.
4. Create an account on TMDB and get an API key.
5. Add your API key to the `assets/config/main.json` file.
6. Run the app using your preferred emulator or physical device.

## Usage

To use the CinemaHub app:

1. Open the app.
2. Browse through the list of movies or search for a movie by title or genre.
3. Click on a movie to access more information, including release dates and cast members.
4. Watch trailers, teasers, and more.
5. Explore popular movie lists curated by our team of experts.

## API Reference

### TMDB API

The CinemaHub app uses the TMDB API to access information about movies. The `tmdb_api.dart` file contains the logic for making API calls using the `http` package.

#### `fetchMovieDetails`

```dart
Future<MovieDetails> fetchMovieDetails(int id) async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/$id?api_key=$_apiKey&language=$_language'));

  if (response.statusCode == 200) {
    return MovieDetails.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load movie details');
  }
}
```

This method fetches the details of a specific movie by its ID.

## Contributing

Contributions are welcome! Here are some ways you can contribute:

* Report bugs and help us improve the app.
* Fix bugs and add new features by creating pull requests.

Please read our [CONTRIBUTING](CONTRIBUTING.md) file for more information.

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for details.

## Credits

* Flutter - [https://flutter.dev/](https://flutter.dev/)
* TMDB API - [https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api)
* Riverpod - [https://riverpod.dev/](https://riverpod.dev/)

## Contact

If you have any questions or suggestions, please feel free to contact us at [contact@cinemahub.com](mailto:contact@cinemahub.com).
