module = angular.module 'tamad.directives', [

]

module.directive 'rsErrand', -> {
  scope:
    errand: '='
    user: '=?'
    run: '&'
  template: '''
  <div class="errand">
    <img ng-src="{{errand.user.fb_id | photo}}"></img>
    <div class="title">{{ errand.title }}</div>
    <div class="price"><i class="icon-money"></i> PHP {{ errand.price | number:2 }}</div>
    <div class="location"><i class="icon-location-arrow"></i> {{ errand.location }}<span ng-show="user">  {{errand|distance:user}}</span></div>
    <div class="body">{{ errand.body }}</div>
    <button ng-click="_run(errand.id)" ng-show="user">Apply</button>
  </div>
  '''
  link: (scope, element, attrs) ->
    scope._run = (id) ->
      scope.run errandId: id
}