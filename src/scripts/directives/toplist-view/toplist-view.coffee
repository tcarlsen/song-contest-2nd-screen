angular.module "toplistDirective", []
  .directive "toplistView", ->
    restrict: "E"
    scope: true
    templateUrl: "partials/toplist-view.html"
    link: (scope, element, attrs) ->
      init = scope.$watch "songs", (data) ->
        return if data is null

        scope.limit = attrs.count || data.length
        init()
