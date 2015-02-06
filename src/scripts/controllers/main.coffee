angular.module "mainCtrl", []
  .controller "mainController", ($scope, $http, $cookieStore, $timeout, socket, uuid) ->
    config =
      apiUrl: "10.86.233.62:8000"
      event: "mgp2015"
      logo: "/img/mgp2015logo.png"
    socket = socket.connet(config.apiUrl, config.event)
    cookie = null

    $scope.logo = config.logo
    $scope.songs = null
    $scope.activeSong = null
    $scope.render = 0

    $scope.vote = (vote) ->
      socket.emit vote,
        song: $scope.songs[$scope.activeSong].id
        event: config.event
        session: cookie

    $scope.navigate = (direction) ->
      $scope.activeSong -= 1 if direction is "up"
      $scope.activeSong += 1 if direction is "down"

      $scope.activeSong = 0 if $scope.activeSong < 0
      $scope.activeSong = $scope.songs.length - 1 if $scope.activeSong is $scope.songs.length

      $scope.render++

    $scope.toggleReview = ->
      $scope.showReview = if $scope.showReview is true then false else true

    socket.on "nowplaying", (data) ->
      if data.active is false
        $scope.activeSong = 0

        for key, value of $scope.songs
          $scope.songs[key].active = 0

        $scope.$apply()
      else if data.active_all
        $scope.activeSong = $scope.songs.length - 1

        for key, value of $scope.songs
          $scope.songs[key].active = 1

        $scope.$apply()
      else

        for key, value of $scope.songs
          if value.id is data.song
            $scope.activeSong = key
            $scope.songs[key].active = 1
            $scope.render++
            $scope.$apply()

            break

    socket.on "newrating", (data) ->
      for key, value of $scope.songs
        if value.id is data.song
          $scope.songs[key].likes = data.likes
          $scope.songs[key].dislikes = data.dislikes
          $scope.songs[key].score = data.score
          $scope.render++
          $scope.$apply()

          break

    socket.on "neworder", -> getArtistList()

    getArtistList = ->
      $http.get "//#{config.apiUrl}/events/#{config.event}"
        .then ((response) ->
          $scope.songs = response.data.songs
          $scope.activeSong = response.data.nowplaying_index || 0
          $scope.render++
        ), (data) ->
          console.log "fuck"
          $timeout getArtistList, 1000

    getArtistList()

    do ->
      cookie = $cookieStore.get "berlingske_#{config.event}"

      if cookie is undefined
        cookie = uuid.generate()
        $cookieStore.put "berlingske_#{config.event}", cookie
