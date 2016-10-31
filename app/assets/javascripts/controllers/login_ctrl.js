/*
login and signup controller
handle authentication for:
 - user login
 - user registration (new user)
*/
angular.module("custSupportTickets")
	.controller("loginCtrl", ["$scope", "$auth", "Auth", function($scope, $auth, Auth){
		/*
		handle login:
		 - keep track of errors
		 - handle form submission/login auth
		*/
		// keep track of authentication errors
		$scope.loginErrors = {
			errors: false,
			messages: []
		};

		// handle form submission for login auth
		$scope.loginSubmit = function(){
			// submit form for login
			Auth.logIn($scope.loginForm, $scope.loginErrors);
		};

		/*
		handle signup:
		 - keep track of errors
		 - handle form submission/signup auth
		*/
		$scope.signupErrors = {
			errors: false,
			messages: []
		};

		// handle form submission for signup auth
		$scope.signupSubmit = function(){
			// submit form for signup
			Auth.signUp($scope.signupForm, $scope.signupErrors);
		};

		// handle signup auth events inside controller to properly re-display login form
		// do not auto login after success so plain-text password is not passed around
		// correct signup
		/* TODO: handle error messages as root scoped flash messages of app */
		$scope.$on("auth:registration-email-success", function(ev, message){
			// set flash message for succesful registration
			$scope.flashMessage = {
				success: true,
				message: 'User succesfully registered! Please log in'
			};
			// display login form with registration success message
			$scope.toggleForm("login");
		});
		// error signup
		$scope.$on("auth:registration-email-error", function(ev, message){
			// no action required
			// error messages already handled by Auth.signUp
		})

		/*
		handle forms - general
		*/
		// keep track of login/signup form to display
		$scope.formToggle = {
			login: true,
			signup: false
		};

		// toggle login/signup form
		$scope.toggleForm = function(form){
			switch (form){
				case 'login':
					$scope.formToggle.login = true;
					$scope.formToggle.signup = false;
					break;
				case 'signup':
					$scope.formToggle.login = false;
					$scope.formToggle.signup = true;
					break;
			}
		}
	}]);