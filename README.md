# YoutubeTracker

To start youtube tracker:

  * create file './config/secrets.exs
  * fill the file with the following:
    ```
      use Mix.Config

      config :youtube_tracker, youtube_key: "<<YOUR PERSONAL YOUTUBE API KEY GOES HERE, CHECK GOOGLES GUIDE ON HOW TO GET ONE>>"
    ```
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## About the app:

This is an Elixir/Phoenix app built to track youtube channels and view their latest 10 videos.

It is split into two main contexts:
  * Accounts
  * Channels

The accounts context contains code for storing and querying users and credentials

The Channels context contains code for storing and querying youtube channels and videos

Furthermore there are several helpers for authentication and interacting with the Youtube API

## Using the app

When first accessing the app you are presented with a UI for either registering or logging in.

You can log in after creating a user.

Doing so presents you with a page that shows you your tracked channels, and an overview of all the latest videos from your tracked channels.

As of now it is empty.

You can track a channel by using the search bar, just under the navbar.

Enter your query and how many results you want, click search.

Doing so presents you with youtube's results.

Click on the 'track' button for the one you want to track.

This brings you back to your personal page, but as you can see the channel you selected is now being tracked, and it's video's are being displayed.

The video list shows the video's for ALL your channels.

If you want to see only one channel's video click on the 'see latest video' button for that channel.

Doing so takes you to a page where you can view a channels most recent 10 videos.

This list of videos updates EVERY HOUR!

You can view a video from the list of all videos by clicking on it's title.

Doing so takes you to the page for the channel the video belongs to, to the exact location of the video you wanted to see.

When you are done you can log out by using the button in the navbar.

