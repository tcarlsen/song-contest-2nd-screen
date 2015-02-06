angular.module "socketService", []
  .service "socket", ->
    connet: (api, event) ->
      socket = io "//#{api}"

      socket.on "connect", -> console.log "Up and running"
      socket.on "disconnect", -> console.log "Down and stopped"
      socket.emit "join", event
