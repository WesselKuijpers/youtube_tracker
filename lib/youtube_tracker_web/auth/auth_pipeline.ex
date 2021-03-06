defmodule YoutubeTracker.UserManager.Pipeline do
  @moduledoc """
  pipeline for making authenication possible
  """
  use Guardian.Plug.Pipeline,
    otp_app: :youtube_tracker,
    error_handler: YoutubeTracker.AuthErrorHandler,
    module: YoutubeTrackerWeb.GuardianSerializer

  # If there is a session token, restrict it to an access token and validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
