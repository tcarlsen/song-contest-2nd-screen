angular.module "socketService", []
  .service "socket", ->
    connet: (api, event) ->
      socket = io "//#{api}"

      socket.on "connect", ->
        socket.emit "join", event
