angular.module("custSupportTickets")
	.service("currRoute", ["$rootScope", "$state", "$window", function($rootScope, $state, $window){
		// set this for nested calls
		var self = this;

		/*
		handle current route navigation
		*/
		// keep track of states and params
		$rootScope.$on("$stateChangeSuccess", function(ev, curr, params){
			var rootRegex = /^\/\w+/,
				actionRegex = /\/\w+$/;

			$rootScope.currState = {
				root: (curr.url.match(rootRegex) ? curr.url.match(rootRegex)[0] : null), // prevent null[0] errors
				action: (curr.url.match(actionRegex) ? curr.url.match(actionRegex)[0] : null), // prevent null[0] errors
				path: curr.url,
				params: params
			};
		});

		// return current state object
		this.getCurrState = function(){
			return $rootScope.currState;
		};

		/*
		handle navigation
		*/
		// navigate to given route
		this.goTo = function(state, params){
			return $state.go(state, params);
		}

		// navigate route history back
		this.goBack = function(){
			return $window.history.back();
		}

		// make go back global for app
		$rootScope.goBack = this.goBack;
	}])