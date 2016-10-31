/*
users controller
handle actions for:
 - R: view users
 - D: destroy user
*/
// index
angular.module("custSupportTickets")
	.controller("usersCtrl", ["$scope", "$window", "currRoute", "UsersResource", function($scope, $window, currRoute, UsersResource){
		// load users
		$scope.users = UsersResource.query();

		// redirect to 
		$scope.viewUser = function(id){
			currRoute.goTo("loggedIn.showUser", { id: id })
		}

		// destroy user
		$scope.destroyUser = function(ev, indx, id, currId){
			// pevent redirect from row click
			ev.stopPropagation();

			// prevent user from destroying handlingmself
			if (id == currId){ return false; }

			// display confirmation popup to ensure action
			var deleteConfirm = $window.confirm("Are you sure you wish to delete this user?");
			if (deleteConfirm){
				// delete user if confirmed
				UsersResource.destroy({ id: id }, function(success){
					// success handling for user deletion
					// remove user from $scope.users
					$scope.users.splice(indx, 1);
				}, function(error){
					// error handling (error.data.errors => error messages)
					alert(error.data.errors)
				});
			}
		}
	}]);

// show
angular.module("custSupportTickets")
	.controller("showUserCtrl", ["$scope", "$window", "currRoute", "UsersResource", function($scope, $window, currRoute, UsersResource){
		// load record
		var userId = currRoute.getCurrState().params.id;
		$scope.user = UsersResource.read({ id: userId });

		
			// toggle user admin role
			$scope.toggleAdmin = function(on_off){
				// display confirmation popup to ensure action
				var toggleConfirm = $window.confirm("Are you sure you wish to change this user's admin role?");
				if (toggleConfirm){
					// close user if action confirmed
					UsersResource.toggle_admin({ id: $scope.user.id, admin: on_off }, function(success){
						// success handling after status update
						$scope.user = success // set user as updated return
					}, function(error){
						// error handling (error.data.errors => error messages)
						alert(error.data.errors);
					});
				}
			}
	}]);