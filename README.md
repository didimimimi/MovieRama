# MovieRama
A simple movie catalog in Swift (UIKit), using [The Movie Databse (TMBD)]([url](https://www.themoviedb.org/)https://www.themoviedb.org/) and some of its API calls.

## Overview
This app uses the TMBD api in order to load movies from a colossal catalog. There are different API calls that get, search or bring more details about the movies.

The caveat of all this is that the entire list is not shown at once but, rather, in small chunks of movies at a time. This process is called _Pagination_ and is described later down below.

By combining the pagination and the multiple API calls, alongside a few other tricks, the user should have an almost (depending on their internet connection) flawless experience throughout the 2 screens of the app.

## Walkthrough

### Splash Screen
Upon opening the app, the user is greeting with a simplistic animation of the app's logo and colors.
<p float="left">
    <img width="200" alt="Screenshot 2023-10-30 at 00 25 51" src="https://github.com/didimimimi/MovieRama/assets/44156940/420dc159-46d5-4b2c-9e69-c16f478deb9a">
    <img width="200" alt="Screenshot 2023-10-30 at 00 25 53" src="https://github.com/didimimimi/MovieRama/assets/44156940/2a7d5764-67e8-4d17-ae35-e9615399a6a5">
    <img width="200" alt="Screenshot 2023-10-30 at 00 25 54" src="https://github.com/didimimimi/MovieRama/assets/44156940/37f4f14c-7d16-457d-ab2e-601c86eb6f0c">
</p>

This screen has to roles:
1. It loads the movies in the background so that they're ready when it finishes.
2. It's a cool transition that introduces the user in the app.

### Main List Screen
This is tha main screen of the app. Here a portion of the movies that were returned during the splash screen (at least for now) are shown here. By scrolling to the bottom, more movies will load.

<p float="left">
  <img width="200" alt="Screenshot 2023-10-30 at 00 34 17" src="https://github.com/didimimimi/MovieRama/assets/44156940/212d6288-5c9a-4c10-b7db-e76424f6dc3d">
  <img width="200" alt="Screenshot 2023-10-30 at 00 34 23" src="https://github.com/didimimimi/MovieRama/assets/44156940/18c7bd1e-1f6a-4330-b54a-19fe00f1a9e4">
  <img width="200" alt="Screenshot 2023-10-30 at 00 34 32" src="https://github.com/didimimimi/MovieRama/assets/44156940/20a72594-a560-4a4a-9283-caab9d601c22">
</p>

From left to right:
1. The top of the list.
2. Scrolling to the bottom.
3. More movies are loaded.

The pagination has a limit on the movies it holds per batch. This batch is called a _page_. In other words, the app has a defined number of movies per page (set arbitrarily by me), so if a page holds X movies, after scrolling X movies, a new page with X movies will appear. The data source of those movies is the `movie/popular` endpoint, which returns a list of 20 movies for a specified page.

The complication with this is that there are actually two types of adding another page; a local and an API addition.
1. The local addition of a page means that if a small number of movies per page is set, we might have to fetch from those pages first in order to fill up the list.
2. The API addition comes into play when we run out of local pages. At that point, the aforementioned endpoint is called with the correct next page. Then those new movies are distributed accordingly into the pagination system (e.g. filling up the last page before creating new ones). Finally, they work as a local addtion if needed, until we run out again.

The user sees no difference between those 2 types.

Every info has two tappable elements:
1. The heart icon, which marks the movie as a favorite.
2. The rest of the tile, which opens the details of the movie.

The heart icon triggers a pseudo-API call (a simulation of an API call in other words) that has an 80% chance of success. If it's successful, the movie is marked as favorite and that state is saved in the user's device through `UserDefaults`. If it fails, an alert is shown. Tapping on an already favorite movie will try to unfavorite, again with the same pseudo-API call.

<p float="left">
  <img width="200" alt="Screenshot 2023-10-30 at 00 41 44" src="https://github.com/didimimimi/MovieRama/assets/44156940/c87dfb11-a888-4181-aa39-755fdbb3cce0">
  <img width="200" alt="Screenshot 2023-10-30 at 00 41 39" src="https://github.com/didimimimi/MovieRama/assets/44156940/9f2c609e-331d-4d09-851f-ff5818cf07d7">
  <img width="200" alt="Screenshot 2023-10-30 at 00 41 58" src="https://github.com/didimimimi/MovieRama/assets/44156940/e58a3948-2d20-4e45-a31f-76ab05b885f7">
</p>

From left to right:
1. Tapping on an unfavorited movie.
2. Small loading indicator on the icon while the pseudo-API call decides the fate of the movie.
3. A fail message.

The tapping of the tile will be explained in the next section.

Before that, a few words about the search function. This basically calls another endpoint, `search/movie`, which is identical to `movie/popular` plus the text that the user typed.

As you can imagine, the app has to hit that endpoint for every character (and mistyped character) the user inputs, which might lead to a big overload to both the server but also the app (lag). Another trick is used here in order to smooth things up. The search function (and thus the API call) will only trigger `250ms` after the user has stopped typing. This is a good amount of time to wait that's neither too long nor too short. This way, the search will only trigger when really needed. Other than that, the user still sees a list which still uses a (different) pagination system, where the only difference is the available movies.

### Movie Details Screen
This screen is rather static and simple. It contains a few extra details about the movie. Three images are worth 3000 words.

<p float="left">
    <img width="200" alt="Screenshot 2023-10-30 at 01 02 33" src="https://github.com/didimimimi/MovieRama/assets/44156940/a14c41e0-d211-4f66-9ab4-cea5d1ae10ce">
    <img width="200" alt="Screenshot 2023-10-30 at 01 02 41" src="https://github.com/didimimimi/MovieRama/assets/44156940/bb9c5aa8-2f2b-465c-95ee-bf4e504490fd">
    <img width="200" alt="Screenshot 2023-10-30 at 01 02 48" src="https://github.com/didimimimi/MovieRama/assets/44156940/8bc0c573-37ba-4c3f-8957-0602a3b61805">
</p>

As you may have noticed, the favorite button is also present here. Well, it's also tappable here and it also syncs with the tile on the list. Actually, the list also syncs with the details. It's a two-way sync.

On the other hand, the similar movies, despite being a scrollable list of movies, are not tappable (for now at least). The rest of the screen is pretty straightforward.

## Deeper Dive
It's time to speak a bit about code in a more descriptive level at least.

### Models
There are a ton of models that are used throughout the app. The most important one is `Movie` that represnts a movie. Then some API models, some transformers of those models into either a `Movie` or some other domain model, some enums for clarity and constants for consistency.

### MVI
The screen of the movies' list is constructed in an MVI architecture, while the details screen (being much simpler without many user interactions) is a plain old `UIViewController` with a few custom/reusable views.
The main screen is divided as follows:

1. `MovieListViewController`: The actual screen.
2. `MovieListIntents`: The screens intents. One intent is an interaction of the user with a screen. When they tap a square, for instance, the corresponding intent should be called.
3. `MovieListStates`: The states of the screen. For example, when an alert is shown, the screen is on an "show alert" state.
4. `MovieListViewModel`: The view model of the screen. It includes all the functionality as far as computations are concerned (for example making the API calls), so that the `MovieListViewController` is left with only the necessary functionality about the UI.

Simply put, the `MovieListIntents` is a protocol that the `MovieListViewModel` implements. The `MovieListStates` is an enum. The view model defines a protocol (delegate) of its own, the `MovieListViewModelDelegate`, with the following function:

`func update(state: MovieListStates)` : updates the state of the screen

The `ChessboardMainViewModelDelegate` is implemented by the `MovieListViewController`, which the latter defines a specific action by switching on the provided state (enum). Internally the view model will call update(state: ChessboardMainStates) in order to notify the view controller about the change and let it handle it however it wants (for example present an alert).




