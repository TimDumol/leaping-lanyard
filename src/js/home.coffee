module = angular.module 'tamad.home', [
  'tamad.auth'
]

module.controller 'HomeCtrl', ($scope, CurrentUser) ->
  setHomeUrl = ->
    if CurrentUser.loggedIn()
      $scope.homeUrl = '/html/home_logged_in.html'
    else
      $scope.homeUrl = '/html/home_anon.html'

  $scope.$on 'login-changed', (event) ->
    console.log "got login changed!"
    setHomeUrl()

  setHomeUrl()


module.controller 'HomeLoggedInCtrl', ($scope, CurrentUser, $http, Errand, Toastr) ->
  $scope.user = CurrentUser.data()
  console.log "FUU"
  Errand.query {exclude_self: true}, (errands) ->
    $scope.errands = errands
    filterErrands()

  filterErrands = ->
    filteredErrands = $scope.errands
    if $scope.searchText
      filteredErrands = _.filter $scope.filteredErrands, (errand) ->
        errand.body.indexOf($scope.searchText) != -1 and errand.title.indexOf($scope.searchText)
    lat = CurrentUser.data()?.latitude
    long = CurrentUser.data()?.longitude
    if lat? and long?
      latLng = new L.LatLng(lat, long)
      filteredErrands = _.sortBy filteredErrands, (errand) ->
        if errand.latitude? and errand.longitude?
          latLng.distanceTo(new L.LatLng(+errand?.latitude, +errand.longitude))
        else
          1e9
    $scope.filteredErrands = filteredErrands

  $scope.$watch 'errands', filterErrands
  $scope.$watch 'searchText', filterErrands
  $scope.$watch (-> CurrentUser.data()?.latitude), filterErrands
  $scope.run = (errand) ->
    console.log "you chose to run errand:", errand
    $http.post("/api/errands/#{errand.id}/apply").success (response) ->
      console.log "success", response
      Toastr.success 'Success! You applied for an errand.'
      errand.applied = true
    .error (response) ->
      console.log "didn't finish run successfully", response

module.controller 'HomeAnonCtrl', ($scope, Errand) ->
  for t in $('#targets li')
    do (t) ->
      $t = $(t)
      do ($t) ->
        $t.hover((ev) ->
          $t.find('.desc').animate({bottom: '0px'})
        , (ev) ->
          $t.find('.desc').animate({bottom: $t.find('.desc').data('orig')})
        )
