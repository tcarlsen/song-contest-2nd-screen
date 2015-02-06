angular.module "artistDirective", []
  .directive "artistView", ->
    restrict: "E"
    templateUrl: "partials/artist-view.html"
    link: (scope, element) ->
      render = (data) ->
        votes = [
          {
            value: data[scope.activeSong].likes
            class: "like"
          }
          {
            value: data[scope.activeSong].dislikes
            class: "dislike"
          }
        ]

        svg = d3.select ".song-chart svg"
        radius = 100
        pi = Math.PI
        arc = d3.svg.arc()
          .outerRadius radius
        pie = d3.layout.pie()
          .sort null
          .startAngle -90 * (pi / 180)
          .endAngle 90 * (pi / 180)
          .value (d) -> d.value

        chart = svg.selectAll ".chart"
          .data [votes]

        chart
          .enter()
            .append "g"
            .attr "class", "chart"
            .attr "transform", "translate(#{radius}, #{radius})"

        slices = chart.selectAll ".slice"
          .data pie

        slices
          .enter()
            .append "path"
            .attr "class", (d) -> "#{d.data.class} slice"
        slices
          .transition().duration(1000)
            .attr "d", arc

      scope.$watch "songs", (newData, oldData) ->
        render newData if newData isnt null
      , true
