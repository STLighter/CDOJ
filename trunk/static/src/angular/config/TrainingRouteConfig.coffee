cdoj
.config([
    "$routeProvider",
    ($routeProvider) ->
      $routeProvider.when("/training/list",
        templateUrl: "template/training/list.html"
        controller: "TrainingListController"
      ).when("/training/editor/:action",
        templateUrl: "template/training/editor.html"
        controller: "TrainingEditorController"
        resolve:
          trainingDto: ["$q", "$route", "$http", "Error",
            ($q, $route, $http, $Error) ->
              deferred = $q.defer()
              action = $route.current.params.action
              if action != "new"
                trainingId = action
                $http.post("/training/data/#{trainingId}").success((data) ->
                  if data.result == "success"
                    data.trainingDto.action = action
                    deferred.resolve(data.trainingDto)
                  else
                    $Error.error(data.error_msg)
                ).error(->
                  $Error.error("Network error!")
                )
              else
                deferred.resolve(
                  action: action
                  description: ""
                  title: ""
                )
              return deferred.promise
          ]
      ).when("/training/show/:trainingId",
        templateUrl: "template/training/show.html"
        controller: "TrainingShowController"
        resolve:
          trainingDto: ["$q", "$route", "$http", "Error",
            ($q, $route, $http, $Error) ->
              deferred = $q.defer()
              trainingId = $route.current.params.trainingId
              $http.post("/training/data/#{trainingId}").success((data) ->
                if data.result == "success"
                  deferred.resolve(data.trainingDto)
                else
                  $Error.error(data.error_msg)
              ).error(->
                $Error.error("Network error!")
              )
              return deferred.promise
          ]
          trainingUserList: ["$q", "$route", "$http", "Error", "$rootScope"
            ($q, $route, $http, $Error, $rootScope) ->
              deferred = $q.defer()
              trainingId = $route.current.params.trainingId
              $http.post(
                "/training/searchTrainingUser/#{trainingId}"
                $rootScope.trainingUserCriteria
              ).success((data) ->
                if data.result == "success"
                  deferred.resolve(data.list)
                else
                  $Error.error(data.error_msg)
              ).error(->
                $Error.error("Network error!")
              )
              return deferred.promise
          ]
          trainingContestList: ["$q", "$route", "$http", "Error", "$rootScope"
            ($q, $route, $http, $Error, $rootScope) ->
              deferred = $q.defer()
              trainingId = $route.current.params.trainingId
              $http.post(
                "/training/searchTrainingContest/#{trainingId}"
                $rootScope.trainingContestCriteria
              ).success((data) ->
                if data.result == "success"
                  deferred.resolve(data.list)
                else
                  $Error.error(data.error_msg)
              ).error(->
                $Error.error("Network error!")
              )
              return deferred.promise
          ]
      ).when("/training/contest/edit/:trainingContestId",
        templateUrl: "template/training/trainingContestEditor.html"
        controller: "TrainingContestEditorController"
        resolve:
          trainingContestData: ["$q", "$route", "$http", "Error",
            ($q, $route, $http, $Error) ->
              deferred = $q.defer()
              trainingContestId = $route.current.params.trainingContestId
              $http.post(
                "/training/trainingContestData/#{trainingContestId}"
              ).success((data) ->
                if data.result == "success"
                  deferred.resolve(
                    action: "edit"
                    trainingContestDto: data.trainingContestDto
                    rankList: data.rankList
                    fileName: ""
                  )
                else
                  $Error.error(data.error_msg)
              ).error(->
                $Error.error("Network error!")
              )
              return deferred.promise
          ]
      ).when("/training/contest/edit/new/:trainingId",
        templateUrl: "template/training/trainingContestEditor.html"
        controller: "TrainingContestEditorController"
        resolve:
          trainingContestData: ["$q", "$route", "$http", "Error",
            ($q, $route, $http, $Error) ->
              deferred = $q.defer()
              trainingId = $route.current.params.trainingId
              deferred.resolve(
                action: "new"
                trainingContestDto:
                  trainingId: trainingId
                  title: ""
                  link: ""
                  type: 0
                  platformType: 0
                rankList:
                  fields: []
                  users: []
                  fieldType: []
                  problems: []
                fileName: ""
              )
              return deferred.promise
          ]
      ).when("/training/contest/show/:trainingContestId",
        templateUrl: "template/training/trainingContest.html",
        controller: "TrainingContestShowController"
        resolve:
          trainingContestData: ["$q", "$route", "$http", "Error",
            ($q, $route, $http, $Error) ->
              deferred = $q.defer()
              trainingContestId = $route.current.params.trainingContestId
              $http.post(
                "/training/trainingContestData/#{trainingContestId}"
              ).success((data) ->
                if data.result == "success"
                  deferred.resolve(
                    trainingContestDto: data.trainingContestDto
                    rankList: data.rankList
                  )
                else
                  $Error.error(data.error_msg)
              ).error(->
                $Error.error("Network error!")
              )
              return deferred.promise
          ]
      )
  ])