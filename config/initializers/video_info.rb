VideoInfo.disable_providers = [] # enable all providers
VideoInfo.provider_api_keys = {
  youtube: Figaro.env.youtube_api_key,
  vimeo: Figaro.env.vimeo_api_key
}